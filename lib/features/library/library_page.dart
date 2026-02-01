import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'library_provider.dart';
import '../../main.dart';
import '../../core/scanner/music_scanner.dart';
import '../../core/scanner/permission_service.dart';
import '../../core/database/song_repository.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  bool _isScanning = false;

  Future<void> _scanMusic() async {
    setState(() => _isScanning = true);

    try {
      final granted = await PermissionService.requestAudioPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permission denied')),
          );
        }
        return;
      }

      final songs = await MusicScanner.scan();
      await SongRepository.insertSongs(songs);

      // Refresh the library
      ref.invalidate(libraryProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scanned ${songs.length} songs')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isScanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final library = ref.watch(libraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: library.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (songs) {
          if (songs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.music_note, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No songs found'),
                  SizedBox(height: 8),
                  Text('Tap the scan button to find your music'),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: songs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final song = songs[index];

              return ListTile(
                title: Text(song['title']),
                subtitle: Text(song['artist']),
                trailing: const Icon(Icons.play_arrow),
                onTap: () {
                  audioHandler.playSong(
                    song['path'],
                    MediaItem(
                      id: song['id'],
                      title: song['title'],
                      artist: song['artist'],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isScanning ? null : _scanMusic,
        child: _isScanning
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.refresh),
      ),
    );
  }
}