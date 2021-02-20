import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../util/mongo_id_parse.dart';

part 'song.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class SongModel {
  @JsonKey(name: '_id', fromJson: objectIdFromJson, toJson: objectIdToJson)
  final ObjectId? id;

  final String name;
  final String ytId;
  final String lyricsAuthor;
  final String lyricsUrl;
  final int length;
  final bool single;
  final int timesPlayed;
  final List<String>? trivia;

  SongModel({
    this.id,
    required this.name,
    required this.ytId,
    required this.lyricsAuthor,
    required this.lyricsUrl,
    required this.length,
    required this.single,
    required this.timesPlayed,
    this.trivia,
  });

  int get lengthInMilliseconds => length * 1000;

  factory SongModel.fromJson(Map<String, dynamic> json) => _$SongModelFromJson(json);

  Map<String, dynamic> toJson() => _$SongModelToJson(this);
}
