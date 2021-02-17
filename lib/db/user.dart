import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:nomac/nomac.dart';

part 'user.g.dart';

@JsonSerializable()
class NomacUser {
  @JsonKey(name: 'discord_id', required: true)
  final String discordId;
  @JsonKey(name: 'lastfm_username')
  final String? lastFmUsername;

  NomacUser({required this.discordId, this.lastFmUsername});

  factory NomacUser.fromJson(Map<String, dynamic> json) =>
      _$NomacUserFromJson(json);

  Map<String, dynamic> toJson() => _$NomacUserToJson(this);

  Future<NomacUser?> getUserFromDb() async {
    var coll = await db.collection('users');
    var json = await coll.findOne(where.eq('discord_id', discordId));

    if (json == null) {
      return null;
    }

    return NomacUser.fromJson(json);
  }

  Future<void> checkIfUserExists() async {
    var coll = await db.collection('users');
    var json = await coll.findOne(where.eq('discord_id', discordId));

    print(json);

    if (json == null) {
      await coll.insert(NomacUser(discordId: discordId).toJson());
    }
  }

  Future updateLastFm() async {
    await checkIfUserExists();

    var coll = await db.collection('users');
    var json = await coll.findOne(where.eq('discord_id', discordId));
    json['lastfm_username'] = lastFmUsername;
    return await coll.save(json);
  }
}
