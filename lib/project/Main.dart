import 'package:flutter/material.dart';
import 'package:flutter_application_1/project/anime.dart';
import 'package:flutter_application_1/project/anime_list_page.dart';
import 'package:flutter_application_1/project/anime_detail.dart';
import 'package:flutter_application_1/project/modelsheet.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'アニメ管理アプリ',
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
            Text("アニメ管理ホーム"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimeButton(
                icon: Icons.add,
                label: "アニメを追加",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnimeListPage()),
                  );
                },
              ),
              SizedBox(height: 20),
              AnimeButton(
                icon: Icons.list,
                label: "アニメ一覧を見る",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnimeListPage1()
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  AnimeButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(label, style: TextStyle(fontSize: 18)),
        ),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
