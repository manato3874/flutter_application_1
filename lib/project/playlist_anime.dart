// anime_list_by_playlist.dart
import 'package:flutter/material.dart';
import 'anime.dart';
import 'edit.dart';
import 'anime_datebase.dart';
import 'playlist.dart';
import 'dart:io' as io;
import 'package:url_launcher/url_launcher.dart';

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
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 200,
          maxWidth: 300,
        ),
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
          width: 60,
          height: 60,
          child: displayImage(imageUrl),
        ),
      );
    } else {
      return Icon(Icons.image_not_supported, size: 60);
    }
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: animeList.length,
          itemBuilder: (context, index) {
            final anime = animeList[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: InkWell(
                onTap: () async {
                  final url = Uri.parse(anime.youtubeUrl);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('URLを開けませんでした')),
                    );
                  }
                },
                onLongPress: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('編集'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditAnimePage(anime: anime),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete),
                          title: Text('プレイリストから削除'),
                          onTap: () async {
                            await AnimeDatabase.removeAnimeFromPlaylist(anime.id!);
                            await fetchAnime(); 
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // 画像表示部分
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 180,
                          height: 100,
                          child: anime.imageUrl.isNotEmpty
                              ? displayImage(anime.imageUrl)
                              : buildYouTubeThumbnail(anime.youtubeUrl),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // テキスト表示部分
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(anime.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 4),
                            Text(anime.musicTitle,
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      const Icon(Icons.play_arrow_rounded, color: Colors.deepPurple),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
