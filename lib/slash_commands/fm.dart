import 'package:nomac/util/escape_markdown.dart';

import '../constants.dart';
import '../services/lastfm_service.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../models/slash_command.dart';
import '../service_locator.dart';
import '../services/user_service.dart';

class LastFm extends NomacSlashCommand {
  final _userService = di<UserService>();
  final _lastFmService = di<LastFmService>();

  LastFm() : super('Sunglasses 😎');

  final _periodArg = CommandArg(
    CommandArgType.string,
    'period',
    'Timescale of the query. Defaults to week',
    choices: [
      ArgChoice('week', '7day'),
      ArgChoice('month', 'month'),
      ArgChoice('3month', '3month'),
      ArgChoice('year', '12month'),
      ArgChoice('overall', 'overall'),
    ],
  );

  final _usernameArg = CommandArg(
    CommandArgType.user,
    'user',
    'Last.fm username. Defaults to the one specified in /fm set',
  );

  @override
  SlashCommand create() {
    return interactions.createCommand(
      'Last.fm',
      'Get last.fm information',
      [
        CommandArg(
          CommandArgType.subCommand,
          'recent',
          'Get most recently played/playing tracks',
          options: [_usernameArg],
        ),
        // CommandArg(
        //   CommandArgType.subCommand,
        //   'artists',
        //   'Get your top artists',
        //   options: [_periodArg, _usernameArg],
        // ),
        // CommandArg(
        //   CommandArgType.subCommand,
        //   'albums',
        //   'Get your top albums',
        //   options: [_periodArg, _usernameArg],
        // ),
        // CommandArg(
        //   CommandArgType.subCommand,
        //   'collage',
        //   'Render a collage of album art based on top plays',
        //   options: [_periodArg, _usernameArg],
        // ),
        // CommandArg(
        //   CommandArgType.subCommand,
        //   'set',
        //   'Set your last.fm username for future usage',
        //   options: [
        //     CommandArg(
        //       CommandArgType.user,
        //       'user',
        //       'Last.fm username. Defaults to the one specified in /fm set',
        //       required: true,
        //     ),
        //   ],
        // ),
      ],
      guild: Snowflake('512050257626923019'),
    );
  }

  @override
  Future<void> run(InteractionEvent event) async {
    if (event.interaction.name == 'fm') {
      final args = event.interaction.args;
      for (var arg in args) {
        switch (arg.name) {
          case 'recent':
            return await _recent(event, arg.args);
        }
      }
    }
  }

  Future<void> _recent(InteractionEvent event, Iterable<InteractionOption> args) async {
    late String user;

    try {
      user = args.firstWhere((x) => x.name == 'user').value;
    } catch (_) {
      final db = await _userService.getUserByDiscordId(event.interaction.author.id.toString());
      if (db?.lastfmUsername == null) throw Exception();
    }

    try {
      var data = await _lastFmService.getRecent(user);
      var embed = EmbedBuilder()
        ..author = embedAuthor
        ..color = nomacDiscordColor
        ..title = 'last.fm/user/${escapeMarkdown(user)}'
        ..thumbnailUrl = data[0].imageUrl
        ..url = 'https://last.fm/user/$user'
        ..addField(
            field: EmbedFieldBuilder(data[0].nowPlaying ? 'Currently playing' : 'Most recent',
                '${data[0].name} - ${data[0].artistName}\n*${data[0].albumName}*'))
        ..addField(
            field: EmbedFieldBuilder('Previous', '${data[1].name} - ${data[1].artistName}\n*${data[1].albumName}*'));

      await event.reply(embed: embed, showSource: true);
    } catch (err) {
      throw Exception('Maybe your username is wrong?');
    }
  }
}
