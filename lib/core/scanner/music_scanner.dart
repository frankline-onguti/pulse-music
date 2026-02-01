import 'dart:async';
import 'package:flutter/services.dart';
import 'song.dart';

class MusicScanner {
  static const _channel = MethodChannel('pulse/music_scanner');

  static Future<List<Song>> scan() async {
    final List<dynamic> result =
        await _channel.invokeMethod('scanMusic');

    return result.map((e) {
      final map = Map<String, dynamic>.from(e);
      return Song(
        id: map['id'],
        title: map['title'],
        artist: map['artist'],
        album: map['album'],
        path: map['path'],
        duration: Duration(milliseconds: map['duration']),
      );
    }).toList();
  }
}