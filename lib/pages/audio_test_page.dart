import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../main.dart';
import '../core/database/database_service.dart';

class AudioTestPage extends StatefulWidget {
  const AudioTestPage({super.key});

  @override
  State<AudioTestPage> createState() => _AudioTestPageState();
}

class _AudioTestPageState extends State<AudioTestPage> {
  List<Map<String, dynamic>> songs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final db = await DatabaseService.database;
    final result = await db.rawQuery('''
      SELECT s.id, s.title, s.path, a.name as artist 
      FROM songs s 
      JOIN artists a ON s.artist_id = a.id 
      LIMIT 10
    ''');
    
    setState(() {
      songs = result;
      isLoading = false;
    });
  }

  Future<void> _playSong(Map<String, dynamic> song) async {
    await audioHandler.playSong(
      song['path'],
      MediaItem(
        id: song['id'],
        title: song['title'] ?? 'Unknown Title',
        artist: song['artist'] ?? 'Unknown Artist',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Test'),
      ),
      body: Column(
        children: [
          // Playback controls
          StreamBuilder<PlaybackState>(
            stream: audioHandler.playbackState,
            builder: (context, snapshot) {
              return Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      StreamBuilder<MediaItem?>(
                        stream: audioHandler.mediaItem,
                        builder: (context, snapshot) {
                          final mediaItem = snapshot.data;
                          return Text(
                            mediaItem?.title ?? 'No song playing',
                            style: Theme.of(context).textTheme.titleMedium,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: audioHandler.pause,
                            icon: const Icon(Icons.pause),
                          ),
                          IconButton(
                            onPressed: audioHandler.play,
                            icon: const Icon(Icons.play_arrow),
                          ),
                          IconButton(
                            onPressed: audioHandler.stop,
                            icon: const Icon(Icons.stop),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Instructions
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Test background playback:\n1. Tap a song to play\n2. Lock phone\n3. Check notification controls',
              textAlign: TextAlign.center,
            ),
          ),
          
          // Songs list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : songs.isEmpty
                    ? const Center(
                        child: Text('No songs found. Scan music first.'),
                      )
                    : ListView.builder(
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return ListTile(
                            title: Text(song['title'] ?? 'Unknown Title'),
                            subtitle: Text(song['artist'] ?? 'Unknown Artist'),
                            trailing: const Icon(Icons.play_arrow),
                            onTap: () => _playSong(song),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}