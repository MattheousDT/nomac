import 'package:dotenv/dotenv.dart' show env, load;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import 'commands.dart';
import 'constants.dart';
import 'models/script.dart';
import 'service_locator.dart';

void main(List<String> arguments) async {
  load();

  await initServiceLocator();

  var bot = di<Nyxx>();

  var db = di<Db>();
  await db.open();

  var commander = Commander(bot, prefix: prefix);
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

  bot.onReady.listen((event) {
    bot.setPresence(PresenceBuilder.of(
      game: Activity.of(
        'Very much in development',
      ),
    ));
  });
}
