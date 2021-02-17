import 'package:mongo_dart/mongo_dart.dart';
import 'package:nomac/models/user.dart';

class UserService {
  final Db db;
  final String collectionName = 'users';

  UserService(this.db);

  Future<NomacUser?> getUserByDiscordId(String discordId) async {
    Map<String, dynamic>? result = await db
        .collection(collectionName)
        .findOne(where.eq('discord_id', discordId));

    if (result == null) {
      return null;
    }

    return NomacUser.fromJson(result);
  }

  Future<NomacUser> createUser(NomacUser user) async {
    return db
        .collection(collectionName)
        .insert(user.toJson())
        .then((json) => NomacUser.fromJson(json));
  }

  Future<NomacUser> updateUser(NomacUser user) async {
    var coll = db.collection(collectionName);

    Map<String, dynamic>? result =
        await coll.findOne(where.eq('discord_id', user.discordId));

    user.toJson().entries.forEach((element) {
      result[element.key] = element.value;
    });

    await coll.save(result);
    return user;
  }

  Future<bool> deleteUser(NomacUser user) async {
    try {
      await db
          .collection(collectionName)
          .remove(where.eq('discord_id', user.discordId));
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
