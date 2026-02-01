import 'package:sqflite/sqflite.dart';
import '../scanner/song.dart';
import 'database_service.dart';

class SongRepository {
  static Future<void> insertSongs(List<Song> songs) async {
    final db = await DatabaseService.database;

    for (final song in songs) {
      // Insert artist if not exists
      final artistId = await _getOrCreateArtist(db, song.artist);

      await db.insert(
        'songs',
        {
          'id': song.id,
          'title': song.title,
          'artist_id': artistId,
          'album': song.album,
          'path': song.path,
          'duration': song.duration.inMilliseconds,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  static Future<int> _getOrCreateArtist(Database db, String name) async {
    final existing = await db.query(
      'artists',
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      return existing.first['id'] as int;
    }

    return await db.insert('artists', {'name': name});
  }
}