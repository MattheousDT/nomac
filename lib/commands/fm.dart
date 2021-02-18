import 'package:dotenv/dotenv.dart' show env;
import 'package:nomac/util/escape_markdown.dart';
import 'package:nyxx/nyxx.dart';

import '../api/lastfm_api.dart';
import '../api/lastfm_collage.dart';
import '../constants.dart';
import '../models/script.dart';
import '../models/user.dart';
import '../service_locator.dart';
import '../services/user_service.dart';

var fm = LastFmApi(env['LASTFM_TOKEN']!);
var bot = di<Nyxx>();
var userService = di<UserService>();

class LastFm extends Script {
  LastFm()
      : super(
          authorId: '190914446774763520',
          name: 'Last.fm',
          description:
              'Gets information from last.fm.\nIf no username is explicitly given, it will use the one that you set with\n`${prefix}fm set --user <username>`',
          example: '${prefix}fm artists --period 1month',
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
        defaultsTo: '7day',
      );
  }

  @override
  Future<Message> cb(context, message, args) async {
    final command = args.command?.name;
    String? user = args['user'];
    String period = args['period'];

    // If username is not provided
    if (user == null) {
      // Try grabbing from the DB
      var dbUser =
          await userService.getUserByDiscordId(context.author.id.toString());

      // If no user exists in the DB
      if (dbUser == null) {
        throw NomacException(
            'Username not provided. Try providing a username or use `${prefix}fm set --user <username>` to save one');
      }

      user = dbUser.lastFmUsername;
    }

    var embed = EmbedBuilder()
      ..addAuthor((author) {
        author.name = getEmbedTitle();
        author.iconUrl = bot.app.iconUrl();
      })
      ..color = nomacDiscordColor
      ..title = 'last.fm/user/${escapeMarkdown(user ?? '')}';

    switch (command) {
      case 'artists':
        try {
          var data = await fm.getTopArtists(user!, period);

          embed..url = 'https://last.fm/user/$user';
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
          var data = await fm.getTopAlbums(user!, period);

          embed
            ..thumbnailUrl = data[0].imageUrl
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
          await userService.updateUser(nomacUser);
          return context.reply(
              content: 'Your last.fm username has been set to "$user"');
        } catch (err) {
          throw NomacException(err.toString());
        }
      case 'collage':
        context.channel.startTypingLoop();
        try {
          var img = await getLastFmCollage(user!, period);
          context.channel.stopTypingLoop();
          return context.channel.sendMessage(
            files: [AttachmentBuilder.bytes(img, 'collage.jpg')],
            content: '',
          );
        } catch (err) {
          context.channel.stopTypingLoop();
          rethrow;
        }
      case 'recent':
        try {
          var data = await fm.getRecent(user!);

          embed
            ..thumbnailUrl = data[0].imageUrl
            ..url = 'https://last.fm/user/$user'
            ..addField(
                field: EmbedFieldBuilder(
                    data[0].nowPlaying ? 'Currently playing' : 'Most recent',
                    '${data[0].name} - ${data[0].artistName}\n*${data[0].albumName}*'))
            ..addField(
                field: EmbedFieldBuilder('Previous',
                    '${data[1].name} - ${data[1].artistName}\n*${data[1].albumName}*'));
        } catch (err) {
          throw NomacException('Maybe your username is wrong?');
        }
        break;
      default:
        throw NomacException(
            'This is not a valid command. Type `${prefix}fm --help` for a list of commands');
    }

    return context.channel.sendMessage(embed: embed);
  }
}
