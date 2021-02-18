class LastFmRecent {
  final String url;
  final String name;
  final String artistName;
  final String albumName;
  final String imageUrl;
  final bool nowPlaying;

  LastFmRecent({
    required this.url,
    required this.name,
    required this.artistName,
    required this.albumName,
    required this.imageUrl,
    required this.nowPlaying,
  });

  factory LastFmRecent.fromJson(Map<String, dynamic> json) {
    return LastFmRecent(
      name: json['name'],
      artistName: json['artist']['#text'],
      albumName: json['album']['#text'],
      url: json['url'],
      imageUrl: List.from(json['image']).last['#text'],
      nowPlaying: json['@attr']?['nowplaying'] == 'true',
    );
  }
}
