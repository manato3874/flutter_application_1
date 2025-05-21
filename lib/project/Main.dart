import 'package:flutter/material.dart';
import 'package:flutter_application_1/project/anime.dart';
import 'package:flutter_application_1/project/anime_list_page.dart';
import 'package:flutter_application_1/project/anime_detail.dart';


class Main extends StatelessWidget {
  final Anime sampleAnime = Anime(
    title: '鬼滅の刃',
    airDate: DateTime(2025, 5, 15, 22, 0),
    musicTitle: '紅蓮華',
    youtubeUrl: 'https://youtube.com/',
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
            Text("アニメタイトル: ${sampleAnime.title}"),
            Text("主題歌: ${sampleAnime.musicTitle}"),
            Text("放送日時: ${sampleAnime.airDate.toLocal()}"),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimeListPage1(),
                  )
                );
              }, 
              child: Text("アニメ一覧")),
          ],
        ),
      ),
    );
  }
}
