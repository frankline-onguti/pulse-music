import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), 'pulse.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    return _db!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE artists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE songs (
        id TEXT PRIMARY KEY,
        title TEXT,
        artist_id INTEGER,
        album TEXT,
        path TEXT,
        duration INTEGER,
        play_count INTEGER DEFAULT 0,
        last_played INTEGER,
        FOREIGN KEY (artist_id) REFERENCES artists(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE play_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        song_id TEXT,
        played_at INTEGER,
        FOREIGN KEY (song_id) REFERENCES songs(id)
      )
    ''');
  }
}