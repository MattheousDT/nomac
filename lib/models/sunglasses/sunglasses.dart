import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../util/mongo_id_parse.dart';

part 'sunglasses.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class Sunglasses {
  @JsonKey(name: '_id', fromJson: objectIdFromJson, toJson: objectIdToJson)
  final ObjectId? id;

  final String victim;
  final String ownedBy;
  final DateTime date;

  Sunglasses({
    this.id,
    required this.victim,
    required this.ownedBy,
    required this.date,
  });

  factory Sunglasses.fromJson(Map<String, dynamic> json) => _$SunglassesFromJson(json);

  Map<String, dynamic> toJson() => _$SunglassesToJson(this);
}
