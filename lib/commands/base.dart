import 'dart:async';

import 'package:args/args.dart';
import 'package:dotenv/dotenv.dart' show env;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import '../constants.dart';
import '../nomac.dart';

enum NomacCommandType {
  command,
  startsWith,
  contains,
}

class NomacException implements Exception {
  final String message;
  NomacException(this.message);
}

abstract class NomacCommand {
  final String authorId;
  final String name;
  final String description;
  final String example;
  final String? icon;
  final String match;
  final List<String>? matchAliases;
  final bool adminOnly;
  final NomacCommandType type;

  NomacCommand({
    required this.authorId,
    required this.name,
    required this.description,
    required this.example,
    this.icon,
    required this.match,
    this.matchAliases,
    required this.adminOnly,
    required this.type,
  });

  Future<Message> run(CommandContext context, String message) async {
    // If command is admin only
    if (adminOnly && context.author.id.toString() != env['ADMIN_ID']) {
      return context.reply(
          content: 'You are not authorised to use this command');
    }

    // Try and parse the arguments
    late ArgResults args;
    try {
      args = argParser.parse(getArgs(message));
    } catch (err) {
      return displayError(context, err.toString());
    }

    if (args['help']) {
      return displayHelp(context);
    }

    // Else run the command
    Message callbackResult;
    try {
      callbackResult = await cb(context, message, args);
    } on NomacException catch (exception) {
      return displayError(
        context,
        exception.message,
      );
    }

    return callbackResult;
  }

  ArgParser argParser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false);

  List<String> getArgs(String message) => message.split(' ')..removeAt(0);

  FutureOr<void> registerArgs() => null;

  String getEmbedTitle() => 'NOMAC // $name';

  Future<Message> cb(CommandContext context, String message, ArgResults args) {
    return context.channel.sendMessage(content: 'Base command!');
  }

  Future<Message> displayHelp(CommandContext context) {
    var embed = EmbedBuilder()
      ..color = nomacDiscordColor
      ..addAuthor((author) {
        author.name = getEmbedTitle();
        author.iconUrl = icon ?? bot.app.iconUrl();
      })
      ..addFooter((footer) {
        footer.text = 'Usage: !$match <command> [options]';
      })
      ..addField(name: 'Description', content: description);

    if (argParser.commands.isNotEmpty) {
      embed.addField(
        name: 'Commands',
        content: argParser.commands.keys
            .map((sub) => '`!$match ${sub} [options]`')
            .join('\n'),
      );
    }

    if (argParser.options.isNotEmpty) {
      embed.addField(
        name: 'Options',
        content: argParser.usage,
      );
    }

    embed.addField(name: 'Example', content: '```$example```');

    return context.channel.sendMessage(embed: embed);
  }

  Future<Message> displayError(CommandContext context, String message) {
    var embed = EmbedBuilder()
      ..color = DiscordColor.yellow
      ..addAuthor((author) {
        author.name = '⚠ NOMAC encountered an error';
        author.iconUrl = icon ?? bot.app.iconUrl();
      })
      ..addFooter((footer) {
        footer.text = 'Type `!$match --help` for help';
      })
      ..description = message;

    return context.reply(embed: embed);
  }
}
