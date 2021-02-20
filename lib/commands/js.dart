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
          match: 'js',
          adminOnly: true,
          type: NomacCommandType.command,
        );

  // @override
  // void registerArgs() {
  //   argParser..addCommand('list');
  // }

  @override
  Future<Message> cb(context, message, args) async {
    final _browser = di<Browser>();
    final jsString = args.arguments.join(' ').replaceFirst('```js', '').replaceAll('`', '');
    final page = await _browser.newPage();

    dynamic result;

    try {
      result = await page.evaluate('() => {$jsString}');
    } catch (err) {
      result = err;
    }

    await page.close();

    return context.reply(content: '```js\n$result\n```');
  }
}
