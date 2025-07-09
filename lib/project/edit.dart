import 'package:flutter/material.dart';
import 'anime.dart';
import 'anime_datebase.dart';
import 'dart:io' as io;

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
  late TextEditingController genreController;
  String currentImageUrl = '';

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.anime.title);
    musicController = TextEditingController(text: widget.anime.musicTitle);
    youtubeUrlController = TextEditingController(text: widget.anime.youtubeUrl);
    imageUrlController = TextEditingController(text: widget.anime.imageUrl);
    genreController = TextEditingController(text: widget.anime.genre);
    airDate = widget.anime.airDate;
    currentImageUrl = widget.anime.imageUrl;

    imageUrlController.addListener(() {
      setState(() {
        currentImageUrl = imageUrlController.text;
      });
    });
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
      id: widget.anime.id,
      title: titleController.text,
      airDate: airDate,
      musicTitle: musicController.text,
      youtubeUrl: youtubeUrlController.text,
      imageUrl: imageUrlController.text,
      genre:  genreController.text,
    );

    await AnimeDatabase.updateAnime(updatedAnime);
    Navigator.pop(context);
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
      child: Image.network(
        thumbnailUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Text('画像を読み込めません'),
      ),
    );
  }

  Widget _buildYoutubeThumbnailFromUrl(String youtubeUrl) {
  final videoId = extractYouTubeVideoId(youtubeUrl);
  if (videoId.isEmpty) return SizedBox();

  final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

  return Center(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 200,
          maxWidth: 300,
        ),
        child: Image.network(
          thumbnailUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Text('サムネイル読み込み失敗'),
        ),
      ),
    ),
  );
}

  Widget _buildImagePreview(String imageUrl) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 200,
            maxWidth: 300,
          ),
          child: SizedBox(
            child: displayImage(imageUrl),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('アニメを編集')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTextField(controller: titleController, label: '作品名'),
          _buildTextField(controller: musicController, label: '音楽名'),
          _buildTextField(controller: youtubeUrlController, label: 'YouTube URL'),
          _buildTextField(controller: imageUrlController, label: '画像URL'),
          _buildTextField(controller: genreController, label: 'ジャンル'),
          const SizedBox(height: 16),

          if (currentImageUrl.isNotEmpty)
            _buildImagePreview(currentImageUrl)
          else if(youtubeUrlController.text.isNotEmpty)
            _buildYoutubeThumbnailFromUrl(youtubeUrlController.text),


          /*
          const SizedBox(height: 24),
          ElevatedButton.icon(
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
            icon: Icon(Icons.date_range),
            label: Text('放送日を選択：${airDate.toLocal().toIso8601String().split("T")[0]}'),
          ),
          */
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _save,
            child: Text("保存"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
