import 'package:flutter/material.dart';
import 'package:flutter_application_1/project/anime.dart';
import 'package:flutter_application_1/project/anime_list_page.dart';
import 'package:flutter_application_1/project/anime_detail.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'アニメ管理アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final anime = Anime(
    title: '鬼滅の刃',
    airDate: DateTime.now(),
    musicTitle: '紅蓮華',
    youtubeUrl: 'https://youtube.com/',
    imageUrl: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ホーム(あ)"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            TextButton(
              child: Text("アニメ追加"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimeListPage(),
                  ),
                );
              },
            ),
            TextButton(
              child: Text("一覧表"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnimeListPage1()),
                ).then((_) => loadAnimeList());
              },
            ),
          ],
        ),
      ),
    );
  }
}
