class Audios {
  final String id;
  final String title;
  final String url;
  final String coverUrl;
  final String duration;
  final String artist;

  Audios({
    required this.id,
    required this.title,
    required this.url,
    required this.coverUrl,
    required this.artist,
    required this.duration,
  });

  factory Audios.fromFirestore(Map<String, dynamic> json, {required String docId}) {
    return Audios(
      id: docId,
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      duration: json['duration'] ?? '00:00',
      artist: json['artist'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      "title": this.title,
      "url": this.url,
      "coverUrl": this.coverUrl,
      "duration": this.duration,
      "artist": this.artist,
    };
  }
}
