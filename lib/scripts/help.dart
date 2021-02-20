import 'package:nyxx/nyxx.dart';

import '../scripts.dart';
import '../constants.dart';
import '../models/script.dart';

class Help extends Script {
  Help()
      : super(
          authorId: '190914446774763520',
          name: 'Help',
          description: 'Gives help innit',
          example: 'bruhhhh',
          match: 'help',
          adminOnly: false,
          type: NomacCommandType.command,
        );

  @override
  Future<Message> cb(message, channel, guild, args) {
    int current;
    try {
      current = int.parse(args.arguments.first);
    } catch (_) {
      current = 1;
    }

    var total = scripts.length;
    var pages = (total / 6).ceil();

    if (current > pages) {
      return channel.sendMessage(
        content: 'There ${pages == 1 ? 'is' : 'are'} only $pages page${pages == 1 ? '' : 's'}',
        replyBuilder: ReplyBuilder.fromMessage(message),
      );
    }

    var embed = EmbedBuilder()
      ..author = embedAuthor
      ..addFooter((footer) {
        footer.text = (current == pages
            ? 'You have reached the final page'
            : 'Page $current/$pages. Use `${prefix}help ${current + 1}` for the next page');
      })
      ..color = nomacDiscordColor;

    scripts.where((e) => !e.adminOnly).skip(current - 1).take(6).forEach(
          (e) => embed.addField(
            field: EmbedFieldBuilder(
              e.name,
              '${e.description}\n```${prefix}${e.match} --help```',
            ),
          ),
        );

    return channel.sendMessage(embed: embed);
  }
}
