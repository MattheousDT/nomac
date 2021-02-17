import 'dart:async';

import 'package:args/args.dart';
import 'package:dotenv/dotenv.dart' show env;
import 'package:nyxx_commander/commander.dart';

enum NomacCommandType {
  command,
  startsWith,
  contains,
}

abstract class NomacCommand {
  final String authorId;
  final String name;
  final String description;
  final String? help;
  final String? thumbnail;
  final String match;
  final List<String>? matchAliases;
  final bool adminOnly;
  final NomacCommandType type;

  NomacCommand({
    required this.authorId,
    required this.name,
    required this.description,
    this.help,
    this.thumbnail,
    required this.match,
    this.matchAliases,
    required this.adminOnly,
    required this.type,
  });

  ArgParser argParser = ArgParser();

  List<String> getArgs(String message) => message.split(' ')..removeAt(0);

  FutureOr<void> registerArgs() => null;

  String getEmbedTitle() => 'NOMAC // $name';

  Future cb(CommandContext context, String message) {
    return context.channel.sendMessage(content: 'Base command!');
  }

  Future run(CommandContext context, String message) {
    if (adminOnly && context.author.id.toString() != env['ADMIN_ID']) {
      return context.reply(
          content: 'You are not authorised to use this command');
    }
    return cb(context, message);
  }
}
