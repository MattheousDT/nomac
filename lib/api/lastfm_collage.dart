import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<Uint8List> getLastFmCollage(String user, String period) async {
  var uri = Uri.https(
    'www.tapmusic.net',
    'collage.php',
    {
      'user': user,
      'type': period,
      'size': '3x3',
    },
  );
  var res = await http.get(uri);

  if (res.headers['content-type']!.startsWith('text/html')) {
    throw '$user does not have any top albums';
  }

  return res.bodyBytes;
}
