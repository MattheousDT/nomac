import 'package:json_annotation/json_annotation.dart';

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
}
