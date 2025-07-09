// playlist_list_page.dart
import 'package:flutter/material.dart';
import 'anime_datebase.dart';
import 'playlist.dart';
import 'playlist_anime.dart'; // ← 後で作成する

class PlaylistListPage extends StatefulWidget {
  @override
  _PlaylistListPageState createState() => _PlaylistListPageState();
}

class _PlaylistListPageState extends State<PlaylistListPage> {
  List<Playlist> playlists = [];
  Map<int, int> animeCountMap = {}; // playlistId → アニメ数


  @override
  void initState() {
    super.initState();
    fetchPlaylists();
  }

  Future<void> fetchPlaylists() async {
    final data = await AnimeDatabase.getAllPlaylists();
    Map<int, int> countMap = {};
    for (final playlist in data) {
      final list = await AnimeDatabase.getAnimeByPlaylistId(playlist.id!);
      countMap[playlist.id!] = list.length;
    }

    setState(() {
      playlists = data;
      animeCountMap = countMap;
    });
  }

/*
    Future<void> fetchAnime() async {
    final list = await AnimeDatabase.getAnimeByPlaylistId(widget.animeLists.id!);
    setState(() {
      animeList = list;
    });
  }
*/

  Future<void> _addPlaylistDialog() async {
    String newName = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('プレイリストを追加'),
        content: TextField(
          onChanged: (value) => newName = value,
          decoration: InputDecoration(hintText: 'プレイリスト名'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('キャンセル'),
          ),
          TextButton(
            onPressed: () async {
              if (newName.trim().isNotEmpty) {
                await AnimeDatabase.insertPlaylist(Playlist(name: newName));
                Navigator.pop(context);
                await fetchPlaylists();
              }
            },
            child: Text('追加'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text('プレイリスト')),
      body: ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child:  ListTile(
              title: Text(playlist.name),
              subtitle: Text('${animeCountMap[playlist.id] ?? 0} 件のアニメ'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AnimeListByPlaylistPage(playlist: playlist),
                  ),
                );
              },
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlaylistDialog,
        child: Icon(Icons.add),
        tooltip: 'プレイリストを追加',
      ),
    );
  }
}
