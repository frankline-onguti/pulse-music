import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/audio/audio_providers.dart';
import '../../main.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaItem = ref.watch(currentMediaItemProvider);
    final playbackState = ref.watch(playbackStateProvider);

    return mediaItem.when(
      data: (item) {
        if (item == null) return const SizedBox.shrink();

        final playing = playbackState.value?.playing ?? false;

        return Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            border: const Border(
              top: BorderSide(color: Colors.white12),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.artist ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  playing ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  playing ? audioHandler.pause() : audioHandler.play();
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}