// import 'dart:async';

// import 'package:args/args.dart';
// import 'package:nomac/util/is_admin.dart';
// import 'package:nyxx/nyxx.dart';

// import '../util/constants.dart';
// import '../service_locator.dart';

// enum NomacCommandType {
//   command,
//   startsWith,
//   contains,
// }

// class NomacException implements Exception {
//   final String message;
//   NomacException(this.message);
// }

// abstract class Script {
//   final String authorId;
//   final String name;
//   final String description;
//   final String example;
//   final String? icon;
//   final String match;
//   final List<String>? matchAliases;
//   final bool adminOnly;
//   final NomacCommandType type;

//   Script({
//     required this.authorId,
//     required this.name,
//     required this.description,
//     required this.example,
//     this.icon,
//     required this.match,
//     this.matchAliases,
//     required this.adminOnly,
//     required this.type,
//   });

//   Nyxx bot = di<Nyxx>();

//   Future<Message> run(Message message, TextChannel channel, Guild guild) async {
//     // If command is admin only
//     if (adminOnly) {
//       if (!await isAdmin(message.author.id, guild)) {
//         return channel.sendMessage(
//           content: 'You are not authorised to use this command',
//           replyBuilder: ReplyBuilder.fromMessage(message),
//         );
//       }
//     }

//     // Try and parse the arguments
//     late ArgResults args;
//     try {
//       args = argParser.parse(_getArgs(message.content));
//     } catch (err) {
//       return _displayError(message, channel, err.toString());
//     }

//     if (args['help']) {
//       return _displayHelp(message, channel);
//     }

//     // Else run the command
//     Message callbackResult;
//     try {
//       callbackResult = await cb(message, channel, guild, args);
//     } on NomacException catch (exception) {
//       return _displayError(
//         message,
//         channel,
//         exception.message,
//       );
//     }

//     return callbackResult;
//   }

//   ArgParser argParser = ArgParser()..addFlag('help', abbr: 'h', negatable: false);

//   FutureOr<void> setup() => {};

//   EmbedAuthorBuilder get embedAuthor => EmbedAuthorBuilder()
//     ..name = 'NOMAC // $name'
//     ..iconUrl = icon ?? bot.app.iconUrl();

//   Future<Message> cb(Message message, TextChannel channel, Guild guild, ArgResults args) {
//     return message.channel
//         .getFromCache()!
//         .sendMessage(content: 'Base command!', replyBuilder: ReplyBuilder.fromMessage(message));
//   }

//   List<String> _getArgs(String messageContent) => messageContent.split(' ')..removeAt(0);

//   Future<Message> _displayHelp(Message message, TextChannel channel) {
//     var embed = EmbedBuilder()
//       ..color = nomacDiscordColor
//       ..author = embedAuthor
//       ..addFooter((footer) {
//         footer.text = 'Usage: ${prefix}$match <command> [options]';
//       })
//       ..addField(name: 'Description', content: description);

//     if (argParser.commands.isNotEmpty) {
//       embed.addField(
//         name: 'Commands',
//         content: argParser.commands.keys.map((sub) => '`${prefix}$match ${sub} [options]`').join('\n'),
//       );
//     }

//     if (argParser.options.isNotEmpty) {
//       embed.addField(
//         name: 'Options',
//         content: argParser.usage,
//       );
//     }

//     embed.addField(name: 'Example', content: '```$example```');

//     return channel.sendMessage(embed: embed);
//   }

//   Future<Message> _displayError(Message message, TextChannel channel, String errorMessage) {
//     var embed = EmbedBuilder()
//       ..color = DiscordColor.yellow
//       ..author = embedAuthor
//       ..addFooter((footer) {
//         footer.text = 'Type `${prefix}$match --help` for help';
//       })
//       ..title = 'NOMAC encountered an error'
//       ..description = errorMessage;

//     return channel.sendMessage(
//       embed: embed,
//       replyBuilder: ReplyBuilder.fromMessage(message),
//     );
//   }
// }
