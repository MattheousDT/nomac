import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';

import '../models/lastfm/lastfm_album.dart';
import '../models/lastfm/lastfm_artist.dart';
import '../models/lastfm/lastfm_recent.dart';

class LastFmService {
  final String token;
  final Client client;

  final _host = 'ws.audioscrobbler.com';
  final _version = '2.0';

  LastFmService(this.token, this.client);

  Future<Map<String, dynamic>> _request(String method, String user, String period) async {
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
    return client.get(uri).then((res) => json.decode(utf8.decode(res.bodyBytes)));
  }

  Future<List<LastFmArtist>> getTopArtists(String user, String period) async {
    var data = await _request('user.gettopartists', user, period);
    var artists = List.from(data['topartists']['artist']);

    var bruh = artists.map((json) => LastFmArtist.fromJson(json)).toList();

    return bruh;
  }

  Future<List<LastFmAlbum>> getTopAlbums(String user, String period) async {
    var data = await _request('user.gettopalbums', user, period);
    var albums = List.from(data['topalbums']['album']);

    var bruh = albums.map((json) => LastFmAlbum.fromJson(json)).toList();

    return bruh;
  }

  Future<List<LastFmRecent>> getRecent(String user) async {
    var data = await _request('user.getrecenttracks', user, 'all');
    var tracks = List.from(data['recenttracks']['track']);

    var bruh = tracks.map((json) => LastFmRecent.fromJson(json)).toList();

    return bruh;
  }

  Future<Uint8List> getCollage(String user, String period) async {
    var uri = Uri.https(
      'www.tapmusic.net',
      'collage.php',
      {
        'user': user,
        'type': period,
        'size': '3x3',
      },
    );
    var res = await client.get(uri);

    if (res.headers['content-type']!.startsWith('text/html')) {
      throw Exception('$user does not have any top albums');
    }

    return res.bodyBytes;
  }

  Future<Uri> getCollageUrl(String user, String period) async {
    var uri = Uri.https(
      'www.tapmusic.net',
      'collage.php',
      {
        'user': user,
        'type': period,
        'size': '3x3',
      },
    );
    return uri;
  }
}
