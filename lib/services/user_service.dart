import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../models/user/user.dart';

class UserService {
  UserService(Db db) : _coll = db.collection('users');

  final _logger = Logger('NOMAC | UserService');
  final DbCollection _coll;

  Future<NomacUser?> getUserByDiscordId(String discordId) async {
    final result = await _coll.findOne(where.eq('discord_id', discordId));

    if (result == null) {
      return null;
    }

    return NomacUser.fromJson(result);
  }

  Future<bool> createUser(NomacUser user) async {
    try {
      await _coll.insert(user.toJson());
      return true;
    } catch (err) {
      _logger.severe(err);
      return false;
    }
  }

  Future<NomacUser> updateUser(NomacUser user) async {
    var result = await _coll.findOne(where.eq('discord_id', user.discordId));

    if (result == null) {
      await createUser(user);
      result = await _coll.findOne(where.eq('discord_id', user.discordId));
    }

    user.toJson().entries.forEach((element) {
      result![element.key] = element.value;
    });

    await _coll.replaceOne(where.eq('_id', result!['_id']), result);
    return user;
  }

  Future<bool> deleteUser(NomacUser user) async {
    try {
      await _coll.remove(where.eq('discord_id', user.discordId));
      return true;
    } catch (err) {
      _logger.severe(err);
      return false;
    }
  }
}
