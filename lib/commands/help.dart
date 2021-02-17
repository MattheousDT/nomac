import 'package:nyxx/nyxx.dart';

import '../commands.dart';
import '../constants.dart';
import '../models/script.dart';
import '../service_locator.dart';

var bot = di<Nyxx>();

class Help extends Script {
  Help()
      : super(
          authorId: '190914446774763520',
          name: 'Help',
          description: 'Gives help innit',
          example: 'bruhhhh',
          match: 'help',
          adminOnly: true,
          type: NomacCommandType.command,
        );

  @override
  Future<Message> cb(context, message, args) {
    int current;
    try {
      current = int.parse(args.arguments.first);
    } catch (_) {
      current = 1;
    }

    var total = commands.length;
    var pages = (total / 6).ceil();

    if (current > pages) {
      return context.reply(
          content:
              'There ${pages == 1 ? 'is' : 'are'} only $pages page${pages == 1 ? '' : 's'}');
    }

    var embed = EmbedBuilder()
      ..addAuthor((author) {
        author.name = getEmbedTitle();
        author.iconUrl = bot.app.iconUrl();
      })
      ..addFooter((footer) {
        footer.text = (current == pages
            ? 'You have reached the final page'
            : 'Page $current/$pages. Use `!help ${current + 1}` for the next page');
      })
      ..color = nomacDiscordColor;

    commands.where((e) => !e.adminOnly).skip(current - 1).take(6).forEach(
          (e) => embed.addField(
            field: EmbedFieldBuilder(
              e.name,
              '${e.description}\n```!${e.match} --help```',
            ),
          ),
        );

    return context.channel.sendMessage(embed: embed);
  }
}
