import 'package:flutter/material.dart';
import 'package:flutter_application_1/project/anime.dart';
import 'package:flutter_application_1/project/anime_list_page.dart';
import 'package:flutter_application_1/project/anime_detail.dart';
import 'package:flutter_application_1/project/playlist_list.dart';
import 'video_widget/video_player_widget.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '管理アプリ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
    genre: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.home),
            SizedBox(width: 8),
            Text("管理ホーム"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: ListView(
          children: [
            _MainCardButton(
              icon: Icons.add,
              label: "新規登録",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AnimeListPage()),
                );
              },
            ),
            SizedBox(height: 18),
            _MainCardButton(
              icon: Icons.list,
              label: "一覧",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimeListPage1()
                  ),
                );
              },
            ),
            SizedBox(height: 18),
            _MainCardButton(
              icon: Icons.library_music,
              label: "プレイリスト",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaylistListPage()
                  ),
                );
              },
            ),
            SizedBox(height: 18),
            _MainCardButton(
              icon: Icons.play_circle_fill,
              label: "動画再生",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerWidget(videoUrl: "https://www.youtube.com/watch?v=K18cpp_-gP8")
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class _MainCardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MainCardButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              SizedBox(width: 24),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
