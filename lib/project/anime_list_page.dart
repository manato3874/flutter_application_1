import 'package:flutter/material.dart';
import 'package:flutter_application_1/project/anime.dart';
import 'package:flutter_application_1/project/anime_export.dart';
import 'package:flutter_application_1/project/anime_datebase.dart';
import 'package:flutter_application_1/project/modelsheet.dart'; // showGenreSelectorModalがここにある前提
import 'dart:convert';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
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
  final genreController = TextEditingController();

  String? selectedGenre;
  List<String> _genres = ['アクション', '恋愛', 'ホラー', 'コメディ'];

  Future<void> _addAnime() async {
    final anime = Anime(
      title: titleController.text,
      airDate: DateTime.now(),
      musicTitle: musicController.text,
      youtubeUrl: urlController.text,
      imageUrl: pickedImageController.text,
      genre: genreController.text,
    );

    await AnimeDatabase.insertAnime(anime);

    setState(() {
      titleController.clear();
      musicController.clear();
      urlController.clear();
      pickedImageController.clear();
      genreController.clear();
      selectedGenre = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('アニメを保存しました')),
    );
  }

  Future<void> _openGenreModal() async {
    final genre = await showGenreSelectorModal(context, _genres);
    if (genre != null && !_genres.contains(genre)) {
      setState(() {
        _genres.add(genre);
      });
    }
    setState(() {
      selectedGenre = genre;
      genreController.text = genre ?? '';
    });
  }

  Future<String?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return image.path; // ストレージ内のパスを返す
    }

    return null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("アニメ登録")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTextField(titleController, "タイトル", Icons.movie),
                    SizedBox(height: 10),
                    _buildTextField(musicController, "主題歌", Icons.music_note),
                    SizedBox(height: 10),
                    _buildTextField(urlController, "YouTube URL", Icons.link),
                    SizedBox(height: 10),
                    _buildTextField(pickedImageController, "画像URL", Icons.image),
                    SizedBox(height: 10),
                    // 選んだ画像のプレビューを表示
                    if (pickedImageController.text.isNotEmpty)
                      displayImage(pickedImageController.text),
                    SizedBox(height: 5 ,width: 5),
                    // ギャラリーから画像を選ぶボタン
                    ElevatedButton.icon(
                      icon: Icon(Icons.photo),
                      label: Text("画像を選ぶ（ストレージから）"),
                      onPressed: () async {
                        final imagePath = await pickImageFromGallery();
                        if (imagePath != null) {
                          setState(() {
                            pickedImageController.text = imagePath;
                          });
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      onPressed: _openGenreModal,
                      icon: Icon(Icons.category),
                      label: Text(selectedGenre ?? 'ジャンルを選ぶ'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      label: Text("保存する"),
                      onPressed: _addAnime,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.download),
              label: Text("JSONとしてエクスポート"),
              onPressed: exportAnimeDataAsJson,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<List<Anime>> loadAnimeList() async {
    if (kIsWeb) {
      throw UnsupportedError('Webでは別のファイルで対応してください');
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final file = io.File('${dir.path}/anime_list.json');
      if (!await file.exists()) return [];

      final jsonStr = await file.readAsString();
      final decoded = jsonDecode(jsonStr) as List;
      return decoded.map((json) => Anime.fromJson(json)).toList();
    }
  }
}
