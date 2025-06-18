// anime_list_by_playlist.dart
import 'package:flutter/material.dart';
import 'anime.dart';
import 'anime_datebase.dart';
import 'playlist.dart';
import 'dart:io' as io;

class AnimeListByPlaylistPage extends StatefulWidget {
  final Playlist playlist;

  AnimeListByPlaylistPage({required this.playlist});

  @override
  _AnimeListByPlaylistPageState createState() => _AnimeListByPlaylistPageState();
}

class _AnimeListByPlaylistPageState extends State<AnimeListByPlaylistPage> {
  List<Anime> animeList = [];

  @override
  void initState() {
    super.initState();
    fetchAnime();
  }

  Future<void> fetchAnime() async {
    final list = await AnimeDatabase.getAnimeByPlaylistId(widget.playlist.id!);
    setState(() {
      animeList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.playlist.name}')),
      body: ListView.builder(
        itemCount: animeList.length,
        itemBuilder: (context, index) {
          final anime = animeList[index];
          return ListTile(
            leading: anime.imageUrl.isNotEmpty
                ? Image.file(io.File(anime.imageUrl), width: 60, height: 60, fit: BoxFit.cover)
                : Icon(Icons.image_not_supported),
            title: Text(anime.title),
            subtitle: Text(anime.musicTitle),
          );
        },
      ),
    );
  }
}
