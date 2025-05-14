import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_application_1/project/anime.dart';

class AnimeListPage extends StatefulWidget {
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  final titleController = TextEditingController();
  final musicController = TextEditingController();
  final urlController = TextEditingController();

  Future<void> _addAnime() async {
    final box = Hive.box<Anime>('animeBox');
    final anime = Anime(
      title: titleController.text,
      airDate: DateTime.now(),
      musicTitle: musicController.text,
      youtubeUrl: urlController.text,
    );
    await box.add(anime);
    titleController.clear();
    musicController.clear();
    urlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("アニメ一覧")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(controller: titleController, decoration: InputDecoration(labelText: 'タイトル')),
                TextField(controller: musicController, decoration: InputDecoration(labelText: '主題歌')),
                TextField(controller: urlController, decoration: InputDecoration(labelText: 'YouTube URL')),
                ElevatedButton(onPressed: _addAnime, child: Text('保存')),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Anime>('animeBox').listenable(),
              builder: (context, Box<Anime> box, _) {
                if (box.isEmpty) return Center(child: Text('アニメがありません'));
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final anime = box.getAt(index);
                    return ListTile(
                      title: Text(anime!.title),
                      subtitle: Text('${anime.musicTitle}（${anime.airDate.toLocal()}）'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => box.deleteAt(index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
