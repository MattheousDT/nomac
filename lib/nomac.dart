// @dart=2.9
import 'dart:io';

import 'package:dotenv/dotenv.dart' show load;
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:nomac/models/slash_command.dart';
import 'package:nomac/slash_commands/fm.dart';
import 'package:nomac/slash_commands/sunglasses.dart';
import 'package:nomac/util/http_overrides.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import 'events/on_message_recieved.dart';
import 'service_locator.dart';

void main(List<String> arguments) async {
  load();
  var logger = Logger('NOMAC');
  HttpOverrides.global = NomacHttpOverrides();

  await initServiceLocator();
  await di.allReady();

  final bot = di<Nyxx>();

  final db = di<Db>();
  await db.open();

  // EXPERIMENTAL SHIT

  final interactions = di<Interactions>();
  final slashCommands = <NomacSlashCommand>[
    Sunglasses(),
    LastFm(),
  ];

  interactions.registerCommands(slashCommands.map((e) => e.create()).toList());

  // END EXPERIMENTAL SHIT

  bot.onMessageReceived.listen(await onMessageRecieved);

  bot.onReady.listen((event) {
    interactions.sync();

    bot.setPresence(PresenceBuilder.of(
      game: Activity.of(
        '!help',
      ),
    ));

    interactions.onSlashCommand.listen((event) async {
      slashCommands.forEach((element) => element.run(event));
    });

    logger.fine('NOMAC Ready!');
  });
}
