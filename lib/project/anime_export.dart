import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'anime.dart';

class AnimeListPage1 extends StatefulWidget {
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage1> {
  late Box<Anime> animeBox;

  @override
  void initState() {
    super.initState();
    animeBox = Hive.box<Anime>('animeBox'); // openBoxはmainで済ませてる前提
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('保存されたアニメ一覧')),
      body: ValueListenableBuilder(
        valueListenable: animeBox.listenable(),
        builder: (context, Box<Anime> box, _) {
          if (box.isEmpty) {
            return Center(child: Text("保存されたアニメはありません"));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final anime = box.getAt(index);
              if (anime == null) return SizedBox();

              return ListTile(
                title: Text(anime.title),
                subtitle: Text(
                  '${anime.musicTitle}\n放送日: ${anime.airDate.toLocal()}',
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}