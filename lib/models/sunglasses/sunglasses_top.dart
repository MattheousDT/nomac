import 'package:json_annotation/json_annotation.dart';

part 'sunglasses_top.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class SunglassesTop {
  @JsonKey(name: '_id')
  final String discordId;
  final int count;

  SunglassesTop({
    required this.discordId,
    required this.count,
  });

  factory SunglassesTop.fromJson(Map<String, dynamic> json) => _$SunglassesTopFromJson(json);

  Map<String, dynamic> toJson() => _$SunglassesTopToJson(this);
}
