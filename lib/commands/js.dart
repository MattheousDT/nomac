import 'package:nomac/service_locator.dart';
import 'package:nyxx/nyxx.dart';
import 'package:puppeteer/puppeteer.dart';

import '../constants.dart';
import '../models/script.dart';

class Js extends Script {
  Js()
      : super(
          authorId: '190914446774763520',
          name: 'JavaScript',
          description: 'Evaluate JS inside a headless chrome',
          example: '${prefix}js `console.log("bruh");`',
          icon: 'https://miro.medium.com/max/720/1*LjR0UrFB2a__5h1DWqzstA.png',
          match: '```js',
          adminOnly: true,
          type: NomacCommandType.startsWith,
        );

  // @override
  // void registerArgs() {
  //   argParser..addCommand('list');
  // }

  @override
  Future<Message> cb(message, channel, guild, args) async {
    final _browser = di<Browser>();
    final jsString = message.content.replaceFirst('```js', '').replaceAll('`', '');
    final page = await _browser.newPage();

    dynamic result;

    try {
      result = await page.evaluate('async () => {$jsString}');
    } catch (err) {
      result = err;
    }

    await page.close();

    var embed = EmbedBuilder()
      ..author = embedAuthor
      ..color = DiscordColor.yellow
      ..description = '```js\n$result\n```';

    return channel.sendMessage(embed: embed);
  }
}
