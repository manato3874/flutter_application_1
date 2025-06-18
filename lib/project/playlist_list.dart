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

  @override
  void initState() {
    super.initState();
    fetchPlaylists();
  }

  Future<void> fetchPlaylists() async {
    final data = await AnimeDatabase.getAllPlaylists();
    setState(() {
      playlists = data;
    });
  }

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
          return ListTile(
            title: Text(playlist.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AnimeListByPlaylistPage(playlist: playlist),
                ),
              );
            },
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
