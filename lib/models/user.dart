import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../service_locator.dart';

part 'user.g.dart';

var db = di<Db>();

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
}
