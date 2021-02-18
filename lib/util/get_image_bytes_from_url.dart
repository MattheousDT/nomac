import 'dart:typed_data';

import 'package:http/http.dart';

import '../service_locator.dart';

final _client = di<Client>();

Future<Uint8List> getImageBytesFromUrl(String url) => _client.get(url).then((x) => x.bodyBytes);
