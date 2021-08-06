import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../models/sunglasses/sunglasses.dart';
import '../models/user/user.dart';

class SunglassesService {
  SunglassesService(
    Db db,
  ) : _coll = db.collection('sunglasses');

  final _logger = Logger('NOMAC | SunglassesService');
  final DbCollection _coll;

  Future<bool> own(Sunglasses model) async {
    try {
      await _coll.insert(model.toJson());
      return true;
    } catch (err) {
      _logger.severe(err);
      return false;
    }
  }

  Future<int> ownedCount(String discordId) async {
    return _coll.count(where.eq('victim', discordId));
  }

  Future<int> ownageCount(String discordId) async {
    return _coll.count(where.eq('owned_by', discordId));
  }

  Future<List<NomacUser>> getTop() async {
    throw UnimplementedError();
  }
}
