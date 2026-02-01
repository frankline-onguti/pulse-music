import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';
import 'core/scanner/music_scanner.dart';
import 'core/scanner/permission_service.dart';
import 'core/database/song_repository.dart';
import 'core/database/database_service.dart';
import 'core/audio/audio_handler.dart';
import 'pages/audio_test_page.dart';
import 'features/library/library_page.dart';

late final PulseAudioHandler audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  audioHandler = await AudioService.init(
    builder: () => PulseAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.pulse.music',
      androidNotificationChannelName: 'Pulse Playback',
      androidNotificationOngoing: true,
    ),
  );

  runApp(const ProviderScope(child: PulseApp()));
}

class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LibraryPage(),
    );
  }
}

class ScanTestPage extends StatefulWidget {
  const ScanTestPage({super.key});

  @override
  State<ScanTestPage> createState() => _ScanTestPageState();
}

class _ScanTestPageState extends State<ScanTestPage> {
  String status = 'Idle';

  Future<void> scan() async {
    setState(() => status = 'Requesting permissions...');
    
    final granted = await PermissionService.requestAudioPermission();
    if (!granted) {
      setState(() => status = 'Permission denied');
      return;
    }

    setState(() => status = 'Scanning music files...');
    final songs = await MusicScanner.scan();
    
    setState(() => status = 'Saving ${songs.length} songs to database...');
    await SongRepository.insertSongs(songs);

    setState(() => status = 'Saved ${songs.length} songs to database');
    
    // Verify data
    await _verifyData();
  }

  Future<void> _verifyData() async {
    final db = await DatabaseService.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM songs');
    final count = result.first['count'];
    // Database verification - this will be replaced with proper logging later
    debugPrint('Database verification: $count songs stored');
  }

  void _goToAudioTest() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AudioTestPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(status),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: scan,
              child: const Text('Scan Music'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _goToAudioTest,
              child: const Text('Test Audio Playback'),
            ),
          ],
        ),
      ),
    );
  }
}