// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NomacUser _$NomacUserFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['discord_id']);
  return NomacUser(
    discordId: json['discord_id'] as String,
    lastFmUsername: json['lastfm_username'] as String?,
  );
}

Map<String, dynamic> _$NomacUserToJson(NomacUser instance) => <String, dynamic>{
      'discord_id': instance.discordId,
      'lastfm_username': instance.lastFmUsername,
    };
