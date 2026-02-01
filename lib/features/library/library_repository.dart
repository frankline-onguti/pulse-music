import '../../core/database/database_service.dart';

class LibraryRepository {
  static Future<List<Map<String, dynamic>>> fetchSongs() async {
    final db = await DatabaseService.database;

    return db.rawQuery('''
      SELECT songs.id, songs.title, artists.name AS artist, songs.path
      FROM songs
      JOIN artists ON songs.artist_id = artists.id
      ORDER BY songs.title COLLATE NOCASE
    ''');
  }
}