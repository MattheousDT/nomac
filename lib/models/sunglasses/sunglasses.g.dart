// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sunglasses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sunglasses _$SunglassesFromJson(Map<String, dynamic> json) {
  return Sunglasses(
    id: objectIdFromJson(json['_id'] as ObjectId),
    victim: json['victim'] as String,
    ownedBy: json['owned_by'] as String,
    date: DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$SunglassesToJson(Sunglasses instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', objectIdToJson(instance.id));
  val['victim'] = instance.victim;
  val['owned_by'] = instance.ownedBy;
  val['date'] = instance.date.toIso8601String();
  return val;
}
