import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../constants.dart';
import '../models/slash_command.dart';
import '../service_locator.dart';
import '../services/sunglasses_service.dart';
import '../services/user_service.dart';
import '../util/is_admin.dart';

class Sunglasses extends NomacSlashCommand {
  final _userService = di<UserService>();
  final _sunglassesService = di<SunglassesService>();

  Sunglasses() : super('Sunglasses 😎');

  @override
  SlashCommand create() {
    return interactions.createCommand(
      'sunglasses',
      '😎',
      [
        CommandArg(
          CommandArgType.subCommand,
          'own',
          'Le epically own someone',
          options: [
            CommandArg(
              CommandArgType.user,
              'user',
              'Who you want to epically own',
              required: true,
            ),
          ],
        ),
        CommandArg(
          CommandArgType.subCommand,
          'count',
          'Check how many times you\'ve been le epically owned by a mod',
        ),
        CommandArg(
          CommandArgType.subCommand,
          'leaderboard',
          'Find out who has been epically owned the most',
        ),
      ],
      guild: Snowflake('512050257626923019'),
    );
  }

  @override
  Future<void> run(InteractionEvent event) async {
    if (event.interaction.name == 'sunglasses') {
      final args = event.interaction.args;
      for (var arg in args) {
        switch (arg.name) {
          case 'own':
            return await _own(event, Snowflake(arg.args.last.value));
          case 'count':
            return await _count(event);
          case 'leaderboard':
            return await _leaderboard(event);
        }
      }
    }
  }

  Future<void> _own(InteractionEvent event, Snowflake id) async {
    if (!await isAdmin(event.interaction.author.id, event.interaction.guild.getFromCache()!)) {
      return event.reply(content: 'Nice try 😎', showSource: true);
    }

    final user = await bot.fetchUser(id);
    final count = await _sunglassesService.add(id.toString());
    await event.reply(content: '${user.mention} has now been 😎\'d **${count} times!**');
  }

  Future<void> _count(InteractionEvent event) async {
    final dbUser = await _userService.getUserByDiscordId(event.interaction.author.id.toString());
    final result = dbUser?.sunglassesCount ?? 0;

    return event.reply(
      content: 'You have been 😎\'d **$result times!**',
      showSource: true,
    );
  }

  Future<void> _leaderboard(InteractionEvent event) async {
    final leaderboard = await _sunglassesService.getTop();
    var embed = EmbedBuilder()
      ..author = embedAuthor
      ..color = nomacDiscordColor;

    for (var element in leaderboard) {
      var user = await bot.fetchUser(element.discordId.toSnowflake());
      embed.addField(
        name: '#${leaderboard.indexOf(element) + 1}',
        content: '${user.username} - ${element.sunglassesCount}',
      );
    }

    return event.reply(embed: embed, showSource: true);
  }
}
