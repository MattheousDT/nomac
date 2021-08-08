import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:nomac/models/sunglasses/sunglasses_top.dart';

import '../models/sunglasses/sunglasses.dart';
import '../models/user/user.dart';

class SunglassesService {
  SunglassesService(
    Db db,
  ) : _coll = db.collection('sunglasses');

  final _logger = Logger('NOMAC | SunglassesService');
  final DbCollection _coll;

  Future<bool> own(Sunglasses model) async {
    var json = model.toJson();
    json['date'] = model.date;

    try {
      await _coll.insert(json);
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

  Future<Sunglasses?> mostRecentOwned(String discordId) async {
    final pipeline = AggregationPipelineBuilder()
        .addStage(Match(where.eq('victim', discordId)))
        .addStage(Sort({'date': -1}))
        .addStage(Limit(1))
        .build();

    final res = await _coll.aggregateToStream(pipeline).toList();

    if (res.isEmpty) {
      return null;
    }
    return Sunglasses.fromJson(res.first);
  }

  Future<List<SunglassesTop>> getTop() async {
    final pipeline = AggregationPipelineBuilder()
        .addStage(Group(id: Field('victim'), fields: {'count': Sum(1)}))
        .addStage(Sort({'count': -1}))
        .addStage(Limit(10))
        .build();

    final res = await _coll.aggregateToStream(pipeline).toList();

    return res.map((e) => SunglassesTop.fromJson(e)).toList();
  }
}
