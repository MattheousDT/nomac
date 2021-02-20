import 'package:intl/intl.dart';
import 'package:nyxx/nyxx.dart';

import '../constants.dart';
import '../models/album.dart';
import '../models/script.dart';
import '../service_locator.dart';
import '../services/album_service.dart';
import '../util/list_extensions.dart';

class Album extends Script {
  Album()
      : super(
          authorId: '136626214264766464',
          name: 'Album',
          description: 'Provides information for an album.',
          example: '${prefix}album Awake',
          match: 'album',
          adminOnly: false,
          type: NomacCommandType.command,
        );

  final _albumService = di<AlbumService>();

  // @override
  // void setup() {
  //   argParser..addCommand('list');
  // }

  @override
  Future<Message> cb(message, channel, guild, args) async {
    final albumName = args.arguments.join(' ');

    if (albumName.isEmpty) {
      throw NomacException('Album name not provided.');
    }

    AlbumModel result;
    try {
      var dbResult = await _albumService.getAlbumByName(albumName);
      if (dbResult == null) {
        throw NomacException('Album not found.');
      }

      result = dbResult;
    } catch (err) {
      throw NomacException('Couldn\'t fetch album from the database.');
    }

    var embed = EmbedBuilder()
      ..author = embedAuthor
      ..color = nomacDiscordColor
      ..title = result.name
      ..url = result.wikiUrl ?? result.youtubePlaylistUrl
      ..thumbnailUrl = result.imageUrl
      ..addField(name: 'Year', content: result.year, inline: true)
      ..addField(name: 'Single?', content: result.single ? 'Yes' : 'No', inline: true)
      ..addField(
        name: 'Length',
        content: DateFormat.ms().format(DateTime.fromMillisecondsSinceEpoch(result.lengthInMilliseconds)),
        inline: true,
      );

    if (result.recordedAt != null) {
      embed.addField(name: 'Recorded at', content: result.recordedAt, inline: true);
    }

    if (result.producers != null) {
      embed.addField(name: 'Produced by', content: result.producers!.join(', '), inline: true);
    }

    if (result.trivia != null && result.trivia!.isNotEmpty) {
      embed.addField(name: 'Did you know?', content: result.trivia!.random());
    }

    return channel.sendMessage(embed: embed);
  }
}
