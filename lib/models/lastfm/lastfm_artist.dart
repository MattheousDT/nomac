class LastFmArtist {
  final int rank;
  final int playCount;
  final String url;
  final String name;
  final String imageUrl;

  LastFmArtist({
    required this.rank,
    required this.playCount,
    required this.url,
    required this.name,
    required this.imageUrl,
  });

  factory LastFmArtist.fromJson(Map<String, dynamic> json) {
    return LastFmArtist(
      name: json['name'],
      rank: int.parse(json['@attr']['rank']),
      url: json['url'],
      imageUrl: List.from(json['image']).last['#text'],
      playCount: int.parse(json['playcount']),
    );
  }
}
