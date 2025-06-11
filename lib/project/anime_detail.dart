import 'package:flutter/material.dart';
import 'package:flutter_application_1/project/anime_datebase.dart';
import 'anime.dart';
import 'edit.dart';
//import 'dart:convert';
//import 'dart:io' as io;
//import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

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

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('削除の確認'),
        content: Text('このアニメを削除してもよろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              await AnimeDatabase.deleteAnime(id);
              Navigator.pop(context); // ダイアログ閉じる
              _loadAnimeList(); // リスト再読み込み
            },
            child: Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }



  Future<void> _loadAnimeList() async {
    final list = await AnimeDatabase.getAllAnime();
    setState(() {
      animeList = list;
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy年M月d日').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
  child: Icon(Icons.add),
  onPressed: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddAnimeForm(onAdd: (anime) {
          AnimeDatabase.insertAnime(anime).then((_) => _loadAnimeList());
          Navigator.pop(context); // モーダルを閉じる
        }),
      ),
    );
  },
),

      appBar: AppBar(title: Text('保存したアニメ一覧')),
      body: animeList.isEmpty
          ? Center(child: Text("データがありません"))
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: animeList.length,
              itemBuilder: (context, index) {
                final anime = animeList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        anime.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported, size: 60),
                      ),
                    ),
                    title: Text(
                      anime.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${anime.musicTitle}（${formatDate(anime.airDate)}）'),
                        Text('${anime.genre}'),
                        GestureDetector(
                          onTap: () async {
                            final url = Uri.parse(anime.youtubeUrl);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('URLを開けませんでした')),
                              );
                            }
                          },

                          child: Text(
                            anime.youtubeUrl,
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAnimePage(anime: anime),
                        ),
                      ).then((_) => _loadAnimeList());
                    },
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('削除'),
                              onTap: () {
                                Navigator.pop(context);
                                if (anime.id != null) {
                                  _showDeleteDialog(anime.id!);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('削除に失敗しました（IDが見つかりません）')),
                                  );
                                }
                              },

                            ),
                          ],
                        ),
                      );
                    },

                  ),
                );
              },
            ),
    );
  }
}


//追加フォーム
class AddAnimeForm extends StatefulWidget {
  final void Function(Anime) onAdd;
  AddAnimeForm({required this.onAdd});

  @override
  _AddAnimeFormState createState() => _AddAnimeFormState();
}

class _AddAnimeFormState extends State<AddAnimeForm> {
  final _titleController = TextEditingController();
  final _musicController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _gerneController = TextEditingController();
  DateTime _airDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("アニメ追加", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: _titleController, decoration: InputDecoration(labelText: '作品名')),
            TextField(controller: _musicController, decoration: InputDecoration(labelText: '音楽名')),
            TextField(controller: _youtubeUrlController, decoration: InputDecoration(labelText: 'YouTube URL')),
            TextField(controller: _imageUrlController, decoration: InputDecoration(labelText: '画像URL')),
            SizedBox(height: 10),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final anime = Anime(
                  id: 0, // データベースで自動生成される前提
                  title: _titleController.text,
                  musicTitle: _musicController.text,
                  youtubeUrl: _youtubeUrlController.text,
                  imageUrl: _imageUrlController.text,
                  airDate: _airDate,
                  genre: _gerneController.text
                );
                widget.onAdd(anime);
              },
              child: Text("追加する"),
            ),
          ],
        ),
      ),
    );
  }
}

