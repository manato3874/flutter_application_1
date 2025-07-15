import 'dart:convert';
import 'dart:io'; // Windows/Android/iOSでファイル入出力するため
import 'package:flutter/foundation.dart'; // kIsWeb判定用
import 'package:path_provider/path_provider.dart';

//import 'anime.dart';
import 'anime_datebase.dart';

Future<void> exportAnimeDataAsJson() async {
  if (kIsWeb) {
    throw UnsupportedError('Webではファイルの保存はサポートされていません。');
  }

  try {
    // データベースからアニメ一覧を取得
    final animeList = await AnimeDatabase.getAnimeList();

    // JSONに変換
    final jsonList = animeList.map((anime) => anime.toJson()).toList();
    final jsonString = jsonEncode(jsonList);

    // 書き出し先のファイルを指定
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/anime_export.json';
    final file = File(filePath);

    // ファイルへ書き出し
    await file.writeAsString(jsonString);

    print('✅ データをエクスポートしました: $filePath');
  } catch (e) {
    print('❌ エクスポート中にエラーが発生しました: $e');
  }
}
