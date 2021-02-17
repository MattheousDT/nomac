import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:nomac/services/user_service.dart';
import 'package:nyxx/nyxx.dart';

import 'constants.dart';

final di = GetIt.instance;

/// Initialise dependency injection
Future<void> initServiceLocator() async {
  final botToken = env['BOT_TOKEN'];

  if (botToken == null) {
    print('Bot token not added to environment variables');
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
  // TODO: Make database connection string an env var
  di.registerLazySingleton<Db>(() => Db('mongodb://localhost:27017/nomac'));

  // Services/Connectors
  di.registerLazySingleton<UserService>(() => UserService(di()));
}
