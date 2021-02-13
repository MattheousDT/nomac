import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import '../commands.dart';
import '../nomac.dart';
import 'base.dart';

class Help extends NomacCommand {
  Help()
      : super(
          authorId: '190914446774763520',
          name: 'Help',
          description: 'Gives help innit',
          help: 'bruhhhh',
          match: 'help',
          adminOnly: true,
        );

  @override
  Future cb(CommandContext context, String message) {
    var args = message.split(' ');

    var current = args.last != '' ? int.tryParse(args.last) ?? 1 : 1;
    print(current);

    var total = commands.length;
    var pages = (total / 6).ceil();

    if (current > pages) {
      return context.reply(
          content:
              'There ${pages == 1 ? 'is' : 'are'} only $pages page${pages == 1 ? '' : 's'}');
    }

    var embed = EmbedBuilder()
      ..addAuthor((author) {
        author.name = 'NOMAC // Help';
        author.iconUrl = bot.app.iconUrl();
      })
      ..addFooter((footer) {
        footer.text = current == pages
            ? 'You have reached the final page'
            : 'Page $current/$pages. Use `!help ${current + 1}` for the next page';
      })
      ..color = DiscordColor.fromHexString('#ff594f');

    commands.skip(current - 1).take(6).forEach(
          (e) => embed.addField(
            field: EmbedFieldBuilder(
              e.name,
              e.description + '\n `!${e.match}`',
            ),
          ),
        );

    return context.channel.sendMessage(embed: embed);
  }
}
