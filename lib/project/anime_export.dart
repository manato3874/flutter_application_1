import 'dart:convert';
import 'dart:html' as html; // Flutter Webのみ
import 'package:hive/hive.dart';
import 'anime.dart'; // あなたのAnimeモデル

void exportAnimeDataAsJson() async {
  final box = Hive.box<Anime>('animeBox');
  final List<Map<String, dynamic>> animeList = [];

  for (var anime in box.values) {
    animeList.add({
      'title': anime.title,
      'musicTitle': anime.musicTitle,
      'youtubeUrl': anime.youtubeUrl,
      'imageUrl': anime.imageUrl,
      'airDate': anime.airDate.toIso8601String(),
    });
  }

  final jsonString = jsonEncode(animeList);
  final blob = html.Blob([jsonString], 'application/json');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', 'anime_data.json')
    ..click();
  html.Url.revokeObjectUrl(url);
}