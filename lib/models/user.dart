import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../util/mongo_id_parse.dart';

part 'user.g.dart';

@JsonSerializable(includeIfNull: false)
class NomacUser {
  @JsonKey(name: '_id', fromJson: objectIdFromJson, toJson: objectIdToJson)
  final ObjectId? id;

  @JsonKey(name: 'discord_id', required: true)
  final String discordId;

  @JsonKey(name: 'lastfm_username')
  final String? lastFmUsername;

  NomacUser({this.id, required this.discordId, this.lastFmUsername});

  factory NomacUser.fromJson(Map<String, dynamic> json) => _$NomacUserFromJson(json);

  Map<String, dynamic> toJson() => _$NomacUserToJson(this);
}
