import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Future<void> deleteOldAnimeDb() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, 'anime.db');

  final dbFile = File(path);
  if (await dbFile.exists()) {
    await dbFile.delete();
    print('✅ 古い anime.db を削除しました');
  } else {
    print('ℹ️ anime.db は存在しませんでした');
  }
}
