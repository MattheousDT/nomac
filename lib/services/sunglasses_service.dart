import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../models/user.dart';
import 'user_service.dart';

class SunglassesService {
  final Logger _logger = Logger('NOMAC | Sunglasses Service');

  final Db db;
  final UserService userService;

  SunglassesService(
    this.db,
    this.userService,
  );

  Future<int> add(String id) async {
    var coll = db.collection(userService.collectionName);

    Map<String, dynamic> result = await coll.findOne(where.eq('discord_id', id));

    if (result == null) {
      await userService.createUser(NomacUser(discordId: id));
      result = await coll.findOne(where.eq('discord_id', id));
    }

    result['sunglasses_count'] = (result['sunglasses_count'] ?? 0) + 1;

    await coll.save(result);

    return result['sunglasses_count'];
  }

  Future<List<NomacUser>> getTop() async {
    final result = await db
        .collection(userService.collectionName)
        .find(where
            .sortBy(
              'sunglasses_count',
              descending: true,
            )
            .limit(10))
        .toList();

    return result.map((element) => NomacUser.fromJson(element)).where((e) => e.sunglassesCount != null).toList();
  }
}
