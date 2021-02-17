import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:nyxx/nyxx.dart';

import 'constants.dart';

final di = GetIt.instance;

/// Initialise dependency injection
Future<void> initServiceLocator() async {
  // Register Bot
  di.registerLazySingleton<Nyxx>(
    () => Nyxx(
      env['BOT_TOKEN'] ?? '',
      GatewayIntents.all,
      ignoreExceptions: isProduction,
    ),
  );

  // Register Mongo Database
  // TODO: Make database connection string an env var
  di.registerLazySingleton<Db>(() => Db('mongodb://localhost:27017/nomac'));
}
