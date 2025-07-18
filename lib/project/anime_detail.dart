import 'package:flutter/material.dart';
import 'package:flutter_application_1/project/anime_datebase.dart';
import 'anime.dart';
import 'edit.dart';
import 'playlist.dart';
//import 'dart:convert';
import 'dart:io' as io;
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
        content: Text('削除してもよろしいですか？'),
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

  void _showAddToPlaylistDialog(Anime anime) async {
    List<Playlist> playlists = await AnimeDatabase.getAllPlaylists();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('プレイリストに追加'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return ListTile(
                  title: Text(playlist.name),
                  onTap: () async {
                    // プレイリストIDをアニメに設定し、更新
                    anime.playlistId = playlist.id;
                    await AnimeDatabase.updateAnime(anime);

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${playlist.name} に追加しました')),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget displayImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(imageUrl); // URLならネット画像
    } else {
      return Image.file(
        io.File(imageUrl),
        width: 200,
        height: 200,
        fit: BoxFit.cover,
        ); // ローカルならFile
    }
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

  String extractYouTubeVideoId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return '';

    // パターン1: https://www.youtube.com/watch?v=xxxx
    if (uri.host.contains('youtube.com') && uri.queryParameters.containsKey('v')) {
      return uri.queryParameters['v'] ?? '';
    }

    // パターン2: https://youtu.be/xxxx
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
    }

    return '';
  }

    // サムネイル画像を表示するウィジェット
  Widget buildYouTubeThumbnail(String youtubeUrl) {
    final videoId = extractYouTubeVideoId(youtubeUrl);
    if (videoId.isEmpty) {
      return const Text('不正なYouTube URL');
    }

    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 140,
        height: 100,
        child: Image.network(
          thumbnailUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Text('画像を読み込めません'),
        ),
      ),
    );
  }

  Widget buildLeading(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 180,
          height: 100,
          child: displayImage(imageUrl),
        ),
      );
    } else {
      return Icon(Icons.image_not_supported, size: 60);
    }
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

      appBar: AppBar(title: Text('保存一覧')),
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
                  child: InkWell(
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
                            ListTile(
                              leading: Icon(Icons.playlist_add),
                              title: Text('プレイリストに追加'),
                              onTap: () {
                                Navigator.pop(context);
                                _showAddToPlaylistDialog(anime);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 画像 or サムネイル
                          Container(
                            width: 150,
                            height: 90,
                            child: anime.imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: AspectRatio(
                                    aspectRatio: 4/3,
                                    child: displayImage(anime.imageUrl),
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: AspectRatio(
                                    aspectRatio: 4/3,
                                    child: buildYouTubeThumbnail(anime.youtubeUrl),
                                  ),
                                ),
                          ),
                          SizedBox(width: 16),
                          // テキスト情報
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  anime.title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text('${anime.musicTitle}'),
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
                          ),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
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
            Text("追加", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

