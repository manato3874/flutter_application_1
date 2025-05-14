import 'package:hive/hive.dart';

part 'anime.g.dart';

@HiveType(typeId: 0)
class Anime extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime airDate;

  @HiveField(2)
  String musicTitle;

  @HiveField(3)
  String youtubeUrl;

  Anime({
    required this.title,
    required this.airDate,
    required this.musicTitle,
    required this.youtubeUrl,
  });
}
