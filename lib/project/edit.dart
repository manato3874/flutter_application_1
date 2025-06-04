import 'package:flutter/material.dart';
import 'anime.dart';
import 'anime_datebase.dart';

class EditAnimePage extends StatefulWidget {
  final Anime anime;

  EditAnimePage({required this.anime});

  @override
  _EditAnimePageState createState() => _EditAnimePageState();
}

class _EditAnimePageState extends State<EditAnimePage> {
  late TextEditingController titleController;
  late TextEditingController musicController;
  late TextEditingController youtubeUrlController;
  late TextEditingController imageUrlController;
  late DateTime airDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.anime.title);
    musicController = TextEditingController(text: widget.anime.musicTitle);
    youtubeUrlController = TextEditingController(text: widget.anime.youtubeUrl);
    imageUrlController = TextEditingController(text: widget.anime.imageUrl);
    airDate = widget.anime.airDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    musicController.dispose();
    youtubeUrlController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }


  Future<void> _save() async {
    final updatedAnime = Anime(
      id: widget.anime.id, // IDはそのまま
      title: titleController.text,
      airDate: airDate,
      musicTitle: musicController.text,
      youtubeUrl: youtubeUrlController.text,
      imageUrl: imageUrlController.text,
    );

    await AnimeDatabase.updateAnime(updatedAnime);
    Navigator.pop(context); // 戻る
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('アニメを編集')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: '作品名'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: musicController,
              decoration: InputDecoration(labelText: '音楽名'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: youtubeUrlController,
              decoration: InputDecoration(labelText: 'YoutubeURL'),
              keyboardType: TextInputType.text,
            ),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: '画像URL'),
              keyboardType: TextInputType.text,
            ),




            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: airDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    airDate = picked;
                  });
                }
              },
              child: Text("放送日を選択：${airDate.toLocal().toIso8601String().split("T")[0]}"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _save,
              child: Text("保存"),
            ),
          ],
        ),
      ),
    );
  }
}
