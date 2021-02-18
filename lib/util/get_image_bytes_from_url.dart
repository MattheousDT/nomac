import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<Uint8List> getImageBytesFromUrl(String url) =>
    http.get(url).then((x) => x.bodyBytes);
