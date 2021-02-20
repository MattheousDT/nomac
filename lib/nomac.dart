import 'package:dotenv/dotenv.dart' show load;
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import 'commands.dart';
import 'constants.dart';
import 'models/script.dart';
import 'service_locator.dart';

void main(List<String> arguments) async {
  load();
  var logger = Logger('NOMAC');

  await initServiceLocator();
  await di.allReady();

  var bot = di<Nyxx>();

  var db = di<Db>();
  await db.open();

  var commander = Commander(bot, prefix: prefix);
  commands.where((e) => e.type == NomacCommandType.command).forEach((e) {
    e.registerArgs();
    commander.registerCommand(e.match, e.run);
    logger.fine('Registered command, ${e.name}');

    e.matchAliases?.forEach(((alias) {
      e.registerArgs();
      commander.registerCommand(alias, e.run);
      logger.fine('Registered command alias, $alias');
    }));
  });

  logger.finer('Finished registering commands!');

  bot.onReady.listen((event) {
    bot.setPresence(PresenceBuilder.of(
      game: Activity.of(
        'Very much in development',
      ),
    ));
  });
}
