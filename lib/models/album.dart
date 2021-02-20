import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../util/mongo_id_parse.dart';
import 'song.dart';

part 'album.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class AlbumModel {
  @JsonKey(name: '_id', fromJson: objectIdFromJson, toJson: objectIdToJson)
  final ObjectId? id;

  final String name;
  final String? ytPlaylistId;
  final String? wikiUrl;
  final String imageUrl;
  final int year;
  final String? recordedAt;
  final List<String>? producers;
  final int length;
  final bool single;
  final List<SongModel> songs;
  final List<String>? trivia;

  AlbumModel({
    this.id,
    required this.name,
    this.ytPlaylistId,
    this.wikiUrl,
    required this.imageUrl,
    required this.year,
    this.recordedAt,
    this.producers,
    required this.length,
    required this.single,
    required this.songs,
    this.trivia,
  });

  int get lengthInMilliseconds => length * 1000;

  String get youtubePlaylistUrl => 'https://youtube.com/playlist?list=$ytPlaylistId';

  factory AlbumModel.fromJson(Map<String, dynamic> json) => _$AlbumModelFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumModelToJson(this);
}
