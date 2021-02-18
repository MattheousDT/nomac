import 'dart:convert';

import 'package:http/http.dart' as http;

const _host = 'ws.audioscrobbler.com';
const _version = '2.0';

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
}

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
}

class LastFmRecent {
  final String url;
  final String name;
  final String artistName;
  final String albumName;
  final String imageUrl;

  LastFmRecent({
    required this.url,
    required this.name,
    required this.artistName,
    required this.albumName,
    required this.imageUrl,
  });
}

class LastFmApi {
  final String token;

  LastFmApi(this.token);

  Future<Map<String, dynamic>> request(
      String method, String user, String period) async {
    var uri = Uri.https(
      _host,
      _version,
      {
        'format': 'json',
        'api_key': token,
        'user': user,
        'limit': '5',
        'period': period,
        'method': method,
      },
    );
    return http.get(uri).then((res) => json.decode(utf8.decode(res.bodyBytes)));
  }

  Future<List<LastFmArtist>> getTopArtists(String user, String period) async {
    var data = await request('user.gettopartists', user, period);
    var artists = List.from(data['topartists']['artist']);

    var bruh = artists
        .map((e) => LastFmArtist(
              name: e['name'],
              rank: int.parse(e['@attr']['rank']),
              url: e['url'],
              imageUrl: List.from(e['image']).last['#text'],
              playCount: int.parse(e['playcount']),
            ))
        .toList();

    return bruh;
  }

  Future<List<LastFmAlbum>> getTopAlbums(String user, String period) async {
    var data = await request('user.gettopalbums', user, period);
    var albums = List.from(data['topalbums']['album']);

    var bruh = albums
        .map((e) => LastFmAlbum(
              name: e['name'],
              artistName: e['artist']['name'],
              rank: int.parse(e['@attr']['rank']),
              url: e['url'],
              imageUrl: List.from(e['image']).last['#text'],
              playCount: int.parse(e['playcount']),
            ))
        .toList();

    return bruh;
  }

  Future<List<LastFmRecent>> getRecent(String user) async {
    var data = await request('user.getrecenttracks', user, 'all');
    var tracks = List.from(data['recenttracks']['track']);

    var bruh = tracks
        .map((e) => LastFmRecent(
              name: e['name'],
              artistName: e['artist']['#text'],
              albumName: e['album']['#text'],
              url: e['url'],
              imageUrl: List.from(e['image']).last['#text'],
            ))
        .toList();

    return bruh;
  }
}
