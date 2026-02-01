import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import '../../main.dart';

final playbackStateProvider =
    StreamProvider<PlaybackState>((ref) {
  return audioHandler.playbackState;
});

final currentMediaItemProvider =
    StreamProvider<MediaItem?>((ref) {
  return audioHandler.mediaItem;
});