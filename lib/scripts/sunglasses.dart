import 'package:nomac/services/sunglasses_service.dart';
import 'package:nomac/services/user_service.dart';
import 'package:nomac/util/is_admin.dart';
import 'package:nyxx/nyxx.dart';

import '../constants.dart';
import '../models/script.dart';
import '../service_locator.dart';

class Sunglasses extends Script {
  Sunglasses()
      : super(
          authorId: '190914446774763520',
          name: 'Sunglasses 😎',
          description: 'Check how many times you\'ve been le epically owned by a mod',
          example: '${prefix}sunglasses count',
          match: 'sunglasses',
          adminOnly: false,
          type: NomacCommandType.command,
        );

  final _userService = di<UserService>();
  final _sunglassesService = di<SunglassesService>();

  @override
  void setup() {
    argParser..addCommand('count')..addCommand('leaderboard');
  }

  @override
  Future<Message> cb(message, channel, guild, args) async {
    final command = args.command?.name;
    final mentions = message.mentions;

    if (command != null && command == 'count') {
      final dbUser = await _userService.getUserByDiscordId(message.author.id.toString());
      final result = dbUser?.sunglassesCount ?? 0;

      return channel.sendMessage(
        content: 'You have been 😎\'d **$result times!**',
        replyBuilder: ReplyBuilder.fromMessage(message),
      );
    }

    if (command != null && command == 'leaderboard') {
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

      return channel.sendMessage(embed: embed);
    }

    if (!await isAdmin(message.author.id, guild) && mentions.isNotEmpty) {
      return channel.sendMessage(content: 'Incorrect usage or insuffient permissions');
    }

    mentions.forEach((mention) async {
      final id = mention.id.toString();
      final mentionDetails = await mention.getOrDownload();
      final count = await _sunglassesService.add(id);
      await channel.sendMessage(content: '${mentionDetails.mention} has now been 😎\'d **${count} times!**');
    });

    return message;
  }
}
