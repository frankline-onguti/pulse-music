import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/scanner/music_scanner.dart';
import 'core/scanner/permission_service.dart';
import 'core/database/song_repository.dart';
import 'core/database/database_service.dart';

void main() {
  runApp(const ProviderScope(child: PulseApp()));
}

class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ScanTestPage(),
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
          ],
        ),
      ),
    );
  }
}