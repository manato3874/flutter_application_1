import 'package:flutter/material.dart';
import 'package:flutter_application_1/project/anime.dart';
import 'package:flutter_application_1/project/anime_export.dart';
import 'package:flutter_application_1/project/anime_datebase.dart';
import 'dart:convert';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class AnimeListPage extends StatefulWidget {
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  final titleController = TextEditingController();
  final musicController = TextEditingController();
  final urlController = TextEditingController();
  final pickedImageController = TextEditingController();

  Future<void> _addAnime() async {
    
    final anime = Anime(
      title: titleController.text,
      airDate: DateTime.now(),
      musicTitle: musicController.text,
      youtubeUrl: urlController.text,
      imageUrl: pickedImageController.text,
    );
    
    await AnimeDatabase.insertAnime(anime);
    
    setState(() {
    titleController.clear();
    musicController.clear();
    urlController.clear();
    pickedImageController.clear();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("アニメ一覧")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(controller: titleController, decoration: InputDecoration(labelText: 'タイトル')),
                TextField(controller: musicController, decoration: InputDecoration(labelText: '主題歌')),
                TextField(controller: urlController, decoration: InputDecoration(labelText: 'YouTube URL')),
                TextField(controller: pickedImageController, decoration: InputDecoration(labelText: '画像URL')),
                ElevatedButton(onPressed: _addAnime, child: Text('保存')),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: exportAnimeDataAsJson,
            child: const Text('JSONとしてエクスポート'),
          ),
        ],
      ),
    );
  }

  Future<List<Anime>> loadAnimeList() async {
    if (kIsWeb) {
      // Web環境：localStorageから読み込む
      // dart:html を使っているファイルでのみ有効
      // この部分を使いたい場合は、別ファイルに分けて dart:html をimportしてください
      throw UnsupportedError('Webでは別のファイルで対応してください');
    } else {
      // Windows環境：ローカルファイルから読み込む
      final dir = await getApplicationDocumentsDirectory();
      final file = io.File('${dir.path}/anime_list.json');
      if (!await file.exists()) return [];

      final jsonStr = await file.readAsString();
      final decoded = jsonDecode(jsonStr) as List;
      return decoded.map((json) => Anime.fromJson(json)).toList();
    }
  }

}
