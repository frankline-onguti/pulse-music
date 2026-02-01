import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../analytics/analytics_service.dart';

class PulseAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  final _player = AudioPlayer();
  final _analytics = AnalyticsService();

  PulseAudioHandler() {
    _player.playbackEventStream.listen(_broadcastState);
    
    // Listen to playback state changes for analytics
    playbackState.listen((state) {
      if (state.playing && mediaItem.value != null) {
        _analytics.logPlay(
          songId: mediaItem.value!.id,
          positionSeconds: state.updatePosition.inSeconds,
        );
      }
    });
  }

  void _broadcastState(PlaybackEvent event) {
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          _player.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        playing: _player.playing,
        processingState: {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ),
    );
  }

  Future<void> playSong(String path, MediaItem mediaItem) async {
    this.mediaItem.add(mediaItem);
    await _player.setFilePath(path);
    play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();
}