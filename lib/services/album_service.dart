import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../models/album.dart';

class AlbumService {
  final Logger _logger = Logger('NOMAC | AlbumService');

  final Db db;
  final String collectionName = 'albums';

  AlbumService(this.db);

  Future<AlbumModel?> getAlbumByName(String name) async {
    Map<String, dynamic>? result =
        await db.collection(collectionName).findOne(where.match('name', name, caseInsensitive: true));

    if (result == null) {
      return null;
    }

    return AlbumModel.fromJson(result);
  }

  Future<bool> createAlbum(AlbumModel album) async {
    try {
      await db.collection(collectionName).insert(album.toJson());
      return true;
    } catch (err) {
      _logger.severe(err);
      return false;
    }
  }

  Future<AlbumModel> updateAlbum(AlbumModel album) async {
    var coll = db.collection(collectionName);

    Map<String, dynamic> result = await coll.findOne(where.match('name', album.name, caseInsensitive: true));

    if (result == null) {
      await createAlbum(album);
      result = await coll.findOne(where.match('name', album.name, caseInsensitive: true));
    }

    album.toJson().entries.forEach((element) {
      result[element.key] = element.value;
    });

    await coll.save(result);
    return album;
  }

  Future<bool> deleteUser(AlbumModel album) async {
    try {
      await db.collection(collectionName).remove(where.match('name', album.name, caseInsensitive: true));
      return true;
    } catch (err) {
      _logger.severe(err);
      return false;
    }
  }
}
