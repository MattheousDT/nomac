// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongModel _$SongModelFromJson(Map<String, dynamic> json) {
  return SongModel(
    id: objectIdFromJson(json['_id'] as ObjectId),
    name: json['name'] as String,
    ytId: json['yt_id'] as String,
    lyricsAuthor: json['lyrics_author'] as String,
    lyricsUrl: json['lyrics_url'] as String,
    length: json['length'] as int,
    single: json['single'] as bool,
    timesPlayed: json['times_played'] as int,
    trivia:
        (json['trivia'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$SongModelToJson(SongModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', objectIdToJson(instance.id));
  val['name'] = instance.name;
  val['yt_id'] = instance.ytId;
  val['lyrics_author'] = instance.lyricsAuthor;
  val['lyrics_url'] = instance.lyricsUrl;
  val['length'] = instance.length;
  val['single'] = instance.single;
  val['times_played'] = instance.timesPlayed;
  writeNotNull('trivia', instance.trivia);
  return val;
}
