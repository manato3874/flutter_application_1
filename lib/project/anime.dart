class Anime {
  final int? id;
  final String title;
  final DateTime airDate;
  final String musicTitle;
  final String youtubeUrl;
  final String imageUrl;

  Anime({
    this.id,
    required this.title,
    required this.airDate,
    required this.musicTitle,
    required this.youtubeUrl,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'airDate': airDate.toIso8601String(),
      'musicTitle': musicTitle,
      'youtubeUrl': youtubeUrl,
      'imageUrl': imageUrl,
    };
  }

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'],
      title: json['title'],
      airDate: DateTime.parse(json['airDate']),
      musicTitle: json['musicTitle'],
      youtubeUrl: json['youtubeUrl'],
      imageUrl: json['imageUrl'],
    );
  }
}
