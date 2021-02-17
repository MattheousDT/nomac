import 'package:args/args.dart';
import 'package:dotenv/dotenv.dart' show env;
import 'package:nomac/api/lastfm_collage.dart';
import 'package:nomac/constants.dart';
import 'package:nomac/db/user.dart';
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
          type: NomacCommandType.command,
        );

  @override
  void registerArgs() {
    argParser
      ..addCommand('recent')
      ..addCommand('artists')
      ..addCommand('albums')
      ..addCommand('set')
      ..addCommand('collage')
      ..addOption('user', abbr: 'u')
      ..addOption(
        'period',
        abbr: 'p',
        allowed: ['7day', '1month', '3month', '12month'],
      );
  }

  @override
  Future cb(CommandContext context, String message) async {
    late ArgResults args;
    try {
      args = argParser.parse(getArgs(message));
    } catch (err) {
      return context.reply(content: err.toString());
    }

    final command = args.command?.name;
    String? user = args['user'];
    String? period = args['period'];
    print('command: $command\nuser: $user\nperiod: $period');

    // If username is not provided
    if (user == null) {
      // Try grabbing from the DB
      var dbUser = await NomacUser(discordId: context.author.id.toString())
          .getUserFromDb();

      // If no user exists in the DB
      if (dbUser == null) {
        return context.reply(
          content:
              'Username not provided. Try providing a username or use `!fm save <username>` to save one',
        );
      }

      user = dbUser.lastFmUsername;
    }

    var embed = EmbedBuilder()
      ..addAuthor((author) {
        author.name = getEmbedTitle();
        author.iconUrl = bot.app.iconUrl();
      })
      ..addFooter((footer) {
        footer.text = 'View full stats on last.fm';
      })
      ..color = nomacDiscordColor;

    switch (command) {
      case 'artists':
        try {
          var data = await fm.getTopArtists(user!, period ?? 'overall');

          embed
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
          var data = await fm.getTopAlbums(user!, period ?? 'overall');

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
      case 'set':
        try {
          var nomacUser = NomacUser(
              discordId: context.author.id.toString(), lastFmUsername: user);
          await nomacUser.updateLastFm();
          return context.reply(
              content: 'Your last.fm username has been set to "$user"');
        } catch (err) {
          return context.reply(
            content: 'An error occurred trying to save your username.',
          );
        }
      case 'collage':
        try {
          var img = await getLastFmCollage(user!, period ?? '7day');
          return context.channel.sendMessage(
              files: [AttachmentBuilder.bytes(img, 'collage.jpg')],
              content: '');
        } catch (err) {
          return context.reply(
            content: err,
          );
        }
      case null:
      case 'recent':
        try {
          var data = await fm.getRecent(user!);

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
                '${command} is not a valid command. Type `!help fm` for more info');
    }

    return context.channel.sendMessage(embed: embed);
  }
}
