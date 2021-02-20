// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) {
  return AlbumModel(
    id: objectIdFromJson(json['_id'] as ObjectId),
    name: json['name'] as String,
    ytPlaylistId: json['yt_playlist_id'] as String?,
    wikiUrl: json['wiki_url'] as String?,
    imageUrl: json['image_url'] as String,
    year: json['year'] as int,
    recordedAt: json['recorded_at'] as String?,
    producers:
        (json['producers'] as List<dynamic>?)?.map((e) => e as String).toList(),
    length: json['length'] as int,
    single: json['single'] as bool,
    songs: (json['songs'] as List<dynamic>)
        .map((e) => SongModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    trivia:
        (json['trivia'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$AlbumModelToJson(AlbumModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('_id', objectIdToJson(instance.id));
  val['name'] = instance.name;
  writeNotNull('yt_playlist_id', instance.ytPlaylistId);
  writeNotNull('wiki_url', instance.wikiUrl);
  val['image_url'] = instance.imageUrl;
  val['year'] = instance.year;
  writeNotNull('recorded_at', instance.recordedAt);
  writeNotNull('producers', instance.producers);
  val['length'] = instance.length;
  val['single'] = instance.single;
  val['songs'] = instance.songs;
  writeNotNull('trivia', instance.trivia);
  return val;
}
