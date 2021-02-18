class LastFmAlbum {
  final int rank;
  final int playCount;
  final String url;
  final String name;
  final String artistName;
  final String imageUrl;

  LastFmAlbum({
    required this.rank,
    required this.playCount,
    required this.url,
    required this.name,
    required this.artistName,
    required this.imageUrl,
  });

  factory LastFmAlbum.fromJson(Map<String, dynamic> json) {
    return LastFmAlbum(
      name: json['name'],
      artistName: json['artist']['name'],
      rank: int.parse(json['@attr']['rank']),
      url: json['url'],
      imageUrl: List.from(json['image']).last['#text'],
      playCount: int.parse(json['playcount']),
    );
  }
}
