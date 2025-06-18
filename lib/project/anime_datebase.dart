import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'anime.dart';
import 'playlist.dart';



class AnimeDatabase {
  static Database? _database;

  // データベースを初期化または取得
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB('anime.db');
    return _database!;
  }

  // 初期化処理（テーブル作成など）
  static Future<Database> initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'anime.db');

    await deleteDatabase(path); // ← 開発用なので後で消す！


    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {

        await db.execute('''
          CREATE TABLE playlists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE anime (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            musicTitle TEXT,
            youtubeUrl TEXT,
            imageUrl TEXT,
            airDate TEXT,
            genre TEXT,
            playlistId INTEGER,
            FOREIGN KEY (playlistId) REFERENCES playlists(id)
          )
        ''');
      },
    );
  }

  

  static Future<List<Anime>> getAnimeList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('anime');

    return List.generate(maps.length, (i) {
      return Anime(
        title: maps[i]['title'],
        airDate: DateTime.parse(maps[i]['airDate']),
        musicTitle: maps[i]['musicTitle'],
        youtubeUrl: maps[i]['youtubeUrl'],
        imageUrl: maps[i]['imageUrl'],
        genre: maps[i]['genre'],
      );
    });
  }

  // アニメを追加
  static Future<int> insertAnime(Anime anime) async {
    final db = await database;
    return await db.insert('anime', anime.toJson());
  }


  // 全件取得
  static Future<List<Anime>> getAllAnime() async {
    final db = await database;
    final maps = await db.query('anime');
    return maps.map((map) => Anime.fromJson(map)).toList();
  }

  // 更新
  static Future<void> updateAnime(Anime anime) async {
    final db = await database;
    await db.update(
      'anime',
      anime.toJson(),
      where: 'id = ?',
      whereArgs: [anime.id],
    );
  }

  // 削除
  static Future<void> deleteAnime(int id) async {
    final db = await database;
    await db.delete(
      'anime',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


static Future<List<Anime>> getAnimeByPlaylistId(int playlistId) async {
  final db = await database;
  final maps = await db.query(
    'anime',
    where: 'playlistId = ?',
    whereArgs: [playlistId],
  );
  return maps.map((map) => Anime.fromJson(map)).toList();
}





// プレイリスト追加
static Future<int> insertPlaylist(Playlist playlist) async {
  final db = await database;
  return await db.insert('playlists', playlist.toJson());
}

// プレイリスト削除（アニメも一緒に削除したいなら追加処理要）
static Future<void> deletePlaylist(int id) async {
  final db = await database;
  await db.delete(
    'playlists',
    where: 'id = ?',
    whereArgs: [id],
  );
}

static Future<List<Playlist>> getAllPlaylists() async {
  final db = await database;
  final result = await db.query('playlists');
  return result.map((e) => Playlist.fromJson(e)).toList();
}

}


