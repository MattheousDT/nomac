import 'dart:async';

import 'package:dotenv/dotenv.dart' show env, load;
import 'package:mongo_dart/mongo_dart.dart';
import 'commands/base.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import 'commands.dart';

var db = Db('mongodb://localhost:27017/nomac');
late Nyxx bot;

void main(List<String> arguments) async {
  load();

  await db.open();

  bot = Nyxx(
    env['BOT_TOKEN'] ?? '',
    GatewayIntents.all,
    ignoreExceptions: false,
  );

  var commander = Commander(bot, prefix: '!');

  commands.where((e) => e.type == NomacCommandType.command).forEach((e) {
    e.registerArgs();
    commander.registerCommand(e.match, e.run);
    print('Registered command, ${e.name}');

    e.matchAliases?.forEach(((alias) {
      e.registerArgs();
      commander.registerCommand(alias, e.run);
      print('Registered command alias, $alias');
    }));
  });

  print('Finished registering commands!');

  // This fucking sucks but too bad!
  Timer(Duration(seconds: 2), () {
    bot.setPresence(PresenceBuilder.of(
      game: Activity.of(
        'Very much in development',
      ),
    ));
  });
}
