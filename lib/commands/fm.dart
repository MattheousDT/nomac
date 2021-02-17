import 'package:dotenv/dotenv.dart' show env;
import 'package:nyxx/nyxx.dart';

import '../api/lastfm_api.dart';
import '../api/lastfm_collage.dart';
import '../constants.dart';
import '../db/user.dart';
import '../nomac.dart';
import 'base.dart';

var fm = LastFmApi(env['LASTFM_TOKEN']!);

class LastFm extends NomacCommand {
  LastFm()
      : super(
          authorId: '190914446774763520',
          name: 'Last.fm',
          description:
              'Gets information from last.fm.\nIf no username is explicitly given, it will use the one that you set with\n`!fm set --user <username>`',
          example: '!fm artists --period 1month',
          match: 'fm',
          icon:
              'https://cdn2.iconfinder.com/data/icons/social-icon-3/512/social_style_3_lastfm-512.png',
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
        allowed: ['7day', '1month', '3month', '12month', 'overall'],
      );
  }

  @override
  Future<Message> cb(context, message, args) async {
    final command = args.command?.name;
    String? user = args['user'];
    String? period = args['period'];

    // If username is not provided
    if (user == null) {
      // Try grabbing from the DB
      var dbUser = await NomacUser(discordId: context.author.id.toString())
          .getUserFromDb();

      // If no user exists in the DB
      if (dbUser == null) {
        throw NomacException(
            'Username not provided. Try providing a username or use `!fm save <username>` to save one');
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
          throw NomacException('Maybe your username is wrong?');
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
          throw NomacException('Maybe your username is wrong?');
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
          throw NomacException('Couldn\'nt save your username');
        }
      case 'collage':
        try {
          return context.enterTypingState(() async {
            var img = await getLastFmCollage(user!, period ?? '7day');
            return context.channel.sendMessage(
              files: [AttachmentBuilder.bytes(img, 'collage.jpg')],
              content: '',
            );
          });
        } catch (err) {
          rethrow;
        }
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
          throw NomacException('Maybe your username is wrong?');
        }
        break;
      default:
        return displayHelp(context);
    }

    return context.channel.sendMessage(embed: embed);
  }
}
