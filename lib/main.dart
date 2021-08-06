import "dart:io";

import "package:dotenv/dotenv.dart" show load;
import "package:logging/logging.dart";
import "package:mongo_dart/mongo_dart.dart";
import "package:nomac/commands/abbreviation.dart";
import 'package:nomac/commands/fm.dart';
import "package:nyxx/nyxx.dart";
import "package:nyxx_interactions/interactions.dart";

import "service_locator.dart";
import "util/http_overrides.dart";

void main(List<String> arguments) async {
  load();
  var logger = Logger("NOMAC");
  HttpOverrides.global = NomacHttpOverrides();

  await initServiceLocator();
  await di.allReady();

  final bot = di<Nyxx>();

  final db = di<Db>();
  await db.open();

  // EXPERIMENTAL SHIT

  final interactions = di<Interactions>()
    ..registerSlashCommand(AbbreviationCommand().build())
    ..registerSlashCommand(LastFm().build())
    ..syncOnReady();

  // final slashCommands = <NomacSlashCommand>[
  //   AbbreviationCommand(),
  // ];

  // END EXPERIMENTAL SHIT

  // bot.onMessageReceived.listen(onMessageRecieved);

  bot.onReady.listen((event) async {
    bot.setPresence(PresenceBuilder.of(activity: ActivityBuilder.game("v2 beta")));
    logger.fine("NOMAC Ready!");
  });
}
