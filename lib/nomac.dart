// @dart=2.9
import 'dart:io';

import 'package:dotenv/dotenv.dart' show load;
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:nomac/util/http_overrides.dart';
import 'package:nyxx/nyxx.dart';

import 'events/on_message_recieved.dart';
import 'service_locator.dart';

void main(List<String> arguments) async {
  load();
  var logger = Logger('NOMAC');
  HttpOverrides.global = NomacHttpOverrides();

  await initServiceLocator();
  await di.allReady();

  var bot = di<Nyxx>();

  var db = di<Db>();
  await db.open();

  bot.onMessageReceived.listen(await onMessageRecieved);

  bot.onReady.listen((event) {
    bot.setPresence(PresenceBuilder.of(
      game: Activity.of(
        '!help',
      ),
    ));
    logger.fine('NOMAC Ready!');
  });
}
