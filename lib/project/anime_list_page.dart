import 'package:flutter/material.dart';
import 'package:flutter_application_1/project/anime.dart';
import 'package:flutter_application_1/project/anime_export.dart';
import 'package:flutter_application_1/project/anime_datebase.dart';
import 'dart:convert';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

String? _selectedGenre;

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

  Future<void> _addAnime() async {
    final anime = Anime(
      title: titleController.text,
      airDate: DateTime.now(),
      musicTitle: musicController.text,
      youtubeUrl: urlController.text,
      imageUrl: pickedImageController.text,
      genre: genreController.text
    );

    await AnimeDatabase.insertAnime(anime);

    setState(() {
      titleController.clear();
      musicController.clear();
      urlController.clear();
      pickedImageController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('アニメを保存しました')),
    );
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
                    DropdownButtonFormField<String>(
                      value: _selectedGenre,
                      decoration: InputDecoration(labelText: 'ジャンル'),
                      items: genreOptions
                          .map((genre) => DropdownMenuItem(value: genre, child: Text(genre)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGenre = value!;
                        });
                      },
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
