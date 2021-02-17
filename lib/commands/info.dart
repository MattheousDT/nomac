import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import '../constants.dart';
import 'base.dart';

class Info extends NomacCommand {
  Info()
      : super(
          authorId: '190914446774763520',
          name: 'Info',
          description: 'Gives info innit',
          help: 'bruhhhh',
          match: 'info',
          adminOnly: true,
          type: NomacCommandType.command,
        );

  @override
  Future cb(CommandContext context, String message) {
    var embed = EmbedBuilder()
      ..addField(content: 'Info command')
      ..addAuthor((author) {
        author.name = getEmbedTitle();
        author.iconUrl = context.author.avatarURL();
      })
      ..color = nomacDiscordColor;

    return context.channel.sendMessage(embed: embed);
  }
}
