// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NomacUser _$NomacUserFromJson(Map<String, dynamic> json) {
  return NomacUser(
    id: objectIdFromJson(json['_id'] as ObjectId),
    discordId: json['discord_id'] as String,
    lastfmUsername: json['lastfm_username'] as String?,
  );
}

Map<String, dynamic> _$NomacUserToJson(NomacUser instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', objectIdToJson(instance.id));
  val['discord_id'] = instance.discordId;
  writeNotNull('lastfm_username', instance.lastfmUsername);
  return val;
}
