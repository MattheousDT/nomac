// ignore: import_of_legacy_library_into_null_safe
import 'package:dotenv/dotenv.dart' show env;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import '../api/lastfm_api.dart';
import '../nomac.dart';
import 'base.dart';

var fm = LastFmApi(env['LASTFM_TOKEN']!);

class LastFm extends NomacCommand {
  LastFm()
      : super(
          authorId: '190914446774763520',
          name: 'Last.fm',
          description: 'Gets you last fm info innit',
          help: 'bruhhhh',
          match: 'fm',
          thumbnail:
              'https://cdn.discordapp.com/attachments/209040403918356481/509092391467352065/t29.png',
          adminOnly: false,
        );

  @override
  Future cb(CommandContext context, String message) async {
    var args = message.split(' ');
    var method = args.length > 2 ? args[1] : 'recent';
    var user = args.length > 2 ? args.last : context.author.username;

    var embed = EmbedBuilder()
      ..addAuthor((author) {
        author.name = 'NOMAC // Last.fm';
        author.iconUrl = bot.app.iconUrl();
      })
      ..addFooter((footer) {
        footer.text = 'View full stats on last.fm';
      })
      ..color = DiscordColor.fromHexString('#ff594f')
      ..thumbnailUrl =
          'https://cdn.discordapp.com/attachments/285057239159668736/809886732887261224/A-2980211-1430953212-1138.png';

    switch (method) {
      case 'artists':
        try {
          var data = await fm.getTopArtists(user, 'overall');

          embed
            ..thumbnailUrl = data[0].imageUrl
            ..title = 'View $user\'s profile'
            ..url = 'https://last.fm/user/$user';
          data.forEach(
            (e) => embed.addField(
                field: EmbedFieldBuilder(e.name, '${e.playCount} plays')),
          );
        } catch (err) {
          return context.reply(
            content: 'An error occurred. Maybe your username is wrong?',
          );
        }
        break;
      case 'albums':
        try {
          var data = await fm.getTopAlbums(user, 'overall');

          embed
            ..thumbnailUrl = data[0].imageUrl
            ..title = 'View $user\'s profile'
            ..url = 'https://last.fm/user/$user';
          data.forEach(
            (e) => embed.addField(
                field: EmbedFieldBuilder(e.name, '${e.playCount} plays')),
          );
        } catch (err) {
          return context.reply(
            content: 'An error occurred. Maybe your username is wrong?',
          );
        }
        break;
      case 'recent':
        try {
          var data = await fm.getRecent(user);

          embed
            ..thumbnailUrl = data[0].imageUrl
            ..title = 'View $user\'s profile'
            ..url = 'https://last.fm/user/$user'
            ..addField(
                field: EmbedFieldBuilder('Current',
                    '${data[0].name} - ${data[0].artistName} [${data[0].albumName}]'))
            ..addField(
                field: EmbedFieldBuilder('Previous',
                    '${data[1].name} - ${data[1].artistName} [${data[1].albumName}]'));
        } catch (err) {
          return context.reply(
            content: 'An error occurred. Maybe your username is wrong?',
          );
        }
        break;
      default:
        return context.reply(
            content:
                '${args[1]} is not a valid method. Type `!help fm` for more info');
    }

    return context.channel.sendMessage(embed: embed);
  }
}
