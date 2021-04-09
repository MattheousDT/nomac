import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:nomac/services/sunglasses_service.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import 'constants.dart';
import 'services/lastfm_service.dart';
import 'services/user_service.dart';

final di = GetIt.instance;

/// Initialise dependency injection
Future<void> initServiceLocator() async {
  final botToken = env['BOT_TOKEN'];
  final mongoConnectionString = env['MONGO_CONNECTION_STRING'];
  final lastFmToken = env['LASTFM_TOKEN'];

  var logger = Logger('NOMAC');

  if (botToken == null) {
    logger.severe('Bot token not added to environment variables');
    exit(1);
  }

  if (mongoConnectionString == null) {
    logger.severe('Mongo connection string not added to environment variables');
    exit(1);
  }

  if (lastFmToken == null) {
    logger.severe('Last.fm token not added to environment variables');
    exit(1);
  }

  // External Dependencies
  di.registerLazySingleton<Nyxx>(
    () => Nyxx(
      botToken,
      GatewayIntents.all,
      ignoreExceptions: isProduction,
    ),
  );
  di.registerLazySingleton<Db>(() => Db(mongoConnectionString));
  di.registerLazySingleton<Client>(() => Client());
  di.registerLazySingleton<Interactions>(() => Interactions(di()));

  // Services/Connectors
  di.registerLazySingleton<UserService>(() => UserService(di()));
  di.registerLazySingleton<LastFmService>(() => LastFmService(lastFmToken, di()));
  di.registerLazySingleton<SunglassesService>(() => SunglassesService(di(), di()));
}
