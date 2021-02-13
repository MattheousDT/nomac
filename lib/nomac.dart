import 'dart:async';

import 'package:dotenv/dotenv.dart' show env, load;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import 'commands.dart';

late Nyxx bot;

void main(List<String> arguments) {
  load();

  bot = Nyxx(
    env['BOT_TOKEN'] ?? '',
    GatewayIntents.all,
  );

  var commander = Commander(bot, prefix: '!');

  commands.forEach((e) {
    commander.registerCommand(e.match, e.run);

    e.matchAliases
        ?.forEach(((alias) => commander.registerCommand(alias, e.run)));
  });

  print('registered commands');

  // This fucking sucks but too bad!
  Timer(Duration(seconds: 2), () {
    bot.setPresence(PresenceBuilder.of(
      game: Activity.of(
        'Very much in development',
      ),
    ));
  });
}
