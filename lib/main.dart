import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/scanner/music_scanner.dart';
import 'core/scanner/permission_service.dart';

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
    final granted = await PermissionService.requestAudioPermission();
    if (!granted) {
      setState(() => status = 'Permission denied');
      return;
    }

    final songs = await MusicScanner.scan();
    setState(() => status = 'Found ${songs.length} songs');
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