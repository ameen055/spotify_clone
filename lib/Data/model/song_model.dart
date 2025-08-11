class Song {
  final String title;
  final String url;

  Song({required this.title, required this.url});

  factory Song.fromFirestore(Map<String, dynamic> json) {
    return Song(
      title: json['title'] ?? 'Untitled',
      url: json['url'],
    );
  }
}
