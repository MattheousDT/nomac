import 'dart:io';

import 'package:dotenv/dotenv.dart' show load;
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:nomac/commands/abbreviation.dart';
import 'package:nomac/commands/fm.dart';
import 'package:nomac/commands/sunglasses.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';
import 'package:pubspec/pubspec.dart';

import 'service_locator.dart';
import 'util/http_overrides.dart';

void main(List<String> arguments) async {
  load();
  var logger = Logger('NOMAC');
  HttpOverrides.global = NomacHttpOverrides();

  await initServiceLocator();
  await di.allReady();

  final bot = di<Nyxx>();

  final db = di<Db>();
  await db.open();

  final interactions = di<Interactions>()
    ..registerSlashCommand(AbbreviationCommand().build())
    ..registerSlashCommand(LastFm().build())
    ..registerSlashCommand(SunglassesCommand().build());

  // bot.onMessageReceived.listen(onMessageRecieved);

  bot.onReady.listen((event) async {
    await interactions.sync();

    final pub = await PubSpec.load(Directory.current);
    bot.setPresence(PresenceBuilder.of(
      activity: ActivityBuilder.game('v${pub.version}'),
    ));

    logger.info('NOMAC Ready!');
  });
}
