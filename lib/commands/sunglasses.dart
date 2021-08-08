import 'package:nomac/models/sunglasses/sunglasses.dart';
import 'package:nomac/util/constants.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../models/slash_command.dart';
import '../service_locator.dart';
import '../services/sunglasses_service.dart';
import '../util/is_admin.dart';

class SunglassesCommand extends NomacSlashCommand {
  final _sunglassesService = di<SunglassesService>();

  SunglassesCommand() : super('Sunglasses 😎');

  @override
  SlashCommandBuilder build() {
    return SlashCommandBuilder(
      'sunglasses',
      '😎',
      [
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'own',
          'Le epically own someone',
          options: [
            CommandOptionBuilder(
              CommandOptionType.user,
              'user',
              'Who you want to epically own',
              required: true,
            ),
          ],
        )..registerHandler(_own),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'count',
          'Check how many times someone has been le epically owned by a mod',
          options: [
            CommandOptionBuilder(
              CommandOptionType.user,
              'user',
              'Someone other than yourself',
            ),
          ],
        )..registerHandler(_count),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'ownage',
          'Check how many times someone has le epically owned someone else',
          options: [
            CommandOptionBuilder(
              CommandOptionType.user,
              'user',
              'Someone other than yourself',
            ),
          ],
        )..registerHandler(_ownage),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          'leaderboard',
          'Find out who has been epically owned the most',
        )..registerHandler(_leaderboard),
      ],
      guild: 285051699717210113.toSnowflake(),
    );
  }

  Future<void> _own(SlashCommandInteractionEvent event) async {
    if (!await isAdmin(event.interaction.memberAuthor.id, event.interaction.guild!.getFromCache()!)) {
      return event.respond(MessageBuilder.content('Nice try 😎'));
    }

    final String id = getArg(getSubCommand(event, 'own'), 'user')?.value;

    final user = await bot.fetchUser(id.toSnowflake());

    await _sunglassesService.own(Sunglasses(
      victim: id,
      ownedBy: event.interaction.memberAuthor.id.toString(),
      date: event.receivedAt,
    ));

    final count = await _sunglassesService.ownedCount(id);

    await event.respond(MessageBuilder.content('${user.mention} has now been 😎\'d **$count times!**'));
  }

  Future<void> _count(SlashCommandInteractionEvent event) async {
    final String id =
        getArg(getSubCommand(event, 'count'), 'user')?.value ?? event.interaction.memberAuthor.id.toString();

    final isMe = id == event.interaction.memberAuthor.id.toString();

    final count = await _sunglassesService.ownedCount(id);

    if (isMe) {
      return await event.respond(MessageBuilder.content('You have been 😎\'d **$count times!**'));
    } else {
      final username = (await bot.fetchUser(id.toSnowflake())).username;
      return await event.respond(MessageBuilder.content('$username has been 😎\'d **$count times!**'));
    }
  }

  Future<void> _ownage(SlashCommandInteractionEvent event) async {
    final String id =
        getArg(getSubCommand(event, 'ownage'), 'user')?.value ?? event.interaction.memberAuthor.id.toString();

    final isMe = id == event.interaction.memberAuthor.id.toString();

    final count = await _sunglassesService.ownageCount(event.interaction.memberAuthor.id.toString());

    if (isMe) {
      return await event.respond(MessageBuilder.content('You have le epically owned noobs **$count times!** 😎'));
    } else {
      final username = (await bot.fetchUser(id.toSnowflake())).username;
      return await event.respond(MessageBuilder.content('$username has le epically owned noobs **$count times!** 😎'));
    }
  }

  Future<void> _leaderboard(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final leaderboard = await _sunglassesService.getTop();

    final embed = EmbedBuilder()
      ..author = embedAuthor
      ..color = nomacDiscordColor;

    for (var element in leaderboard) {
      User? user;

      try {
        user = await bot.fetchUser(element.discordId.toSnowflake());
      } catch (err) {
        user = null;
      }
      embed.addField(
        name: '#${leaderboard.indexOf(element) + 1}',
        content: '${user != null ? user.username : element.discordId} - ${element.count}',
      );
    }

    await event.respond(MessageBuilder.embed(embed));
  }
}
