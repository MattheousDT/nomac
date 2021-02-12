import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import 'base.dart';

class Info extends NomacCommand {
  Info()
      : super(
          authorId: 'Matt',
          name: 'Info',
          description: 'Gives info innit',
          help: 'bruhhhh',
          match: 'info',
          adminOnly: true,
        );

  @override
  Future cb(CommandContext context, String message) {
    var embed = EmbedBuilder()
      ..addField(content: 'Info command')
      ..addAuthor((author) {
        author.name = context.author.username;
        author.iconUrl = context.author.avatarURL();
      })
      ..color = DiscordColor.teal;

    return context.channel.sendMessage(embed: embed);
  }
}
