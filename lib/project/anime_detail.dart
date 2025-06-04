import 'package:flutter/material.dart';
import 'package:flutter_application_1/project/anime_datebase.dart';
import 'anime.dart';
import 'edit.dart';
import 'dart:convert';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

// JSONから読み込む非同期関数

Future<List<Anime>> loadAnimeList() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = io.File('${dir.path}/anime_list.json');
  if (!await file.exists()) return [];

  final jsonStr = await file.readAsString();
  final decoded = jsonDecode(jsonStr) as List;
  return decoded.map((json) => Anime.fromJson(json)).toList();
}


class AnimeListPage1 extends StatefulWidget {
  @override
  _AnimeListPage1State createState() => _AnimeListPage1State();
}

class _AnimeListPage1State extends State<AnimeListPage1> {
  List<Anime> animeList = [];

  @override
  void initState() {
    super.initState();
    _loadAnimeList();
  }

  // 非同期でデータを読み込む
  Future<void> _loadAnimeList() async {
    //final list = await loadAnimeList();
    final list = await AnimeDatabase.getAllAnime();
    setState(() {
      animeList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('保存したアニメ一覧')),
      body: animeList.isEmpty
          ? Center(child: Text("データがありません"))
          : ListView.builder(
              itemCount: animeList.length,
              itemBuilder: (context, index) {
                final anime = animeList[index];
                return ListTile(
                  leading: Image.network(
                    anime.imageUrl,
                    width: 50,
                    errorBuilder: (c, e, s) => Icon(Icons.image_not_supported),
                  ),
                  title: Text(anime.title),
                  subtitle: Text(
                    '${anime.musicTitle} (${anime.airDate.toLocal().toIso8601String().split("T")[0]})',
                  ),
                  trailing: Icon(Icons.play_circle_fill),
                  onTap: () {
                    // TODO: YouTubeリンク開くなど
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAnimePage(anime: anime),
                      ),
                    ).then((_) => _loadAnimeList()); 
                  },
                );
              },
            ),
    );
  }
}
