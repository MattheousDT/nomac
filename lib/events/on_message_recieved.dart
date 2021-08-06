// import 'package:logging/logging.dart';
// import 'package:nyxx/nyxx.dart';

// import '../util/constants.dart';
// import '../models/script.dart';
// import '../scripts.dart';

// var _logger = Logger('NOMAC');

// Future onMessageRecieved(MessageReceivedEvent event) async {
//   final message = event.message.content;
//   final guild = event.message is GuildMessage ? (event.message as GuildMessage).guild.getFromCache()! : null;
//   final channel = event.message.channel.getFromCache()!;

//   if (guild == null) {
//     return _logger.severe('Failed to fetch guild');
//   }

//   // Command
//   if (message.startsWith(prefix)) {
//     final input = message.substring(1).split(' ')[0];
//     Script command;
//     try {
//       command = scripts.firstWhere((element) => element.match == input && element.type == NomacCommandType.command);
//     } catch (err) {
//       return _logger.warning('${event.message.author.username} entered an invalid command: !$input');
//     }

//     _logger.info('${event.message.author.username} running command script: ${command.name}');
//     return command.run(event.message, channel, guild);
//   }

//   // Starts with
//   Script? startsWith;
//   try {
//     startsWith = scripts
//         .firstWhere((element) => element.type == NomacCommandType.startsWith && message.startsWith(element.match));
//   } catch (err) {
//     startsWith = null;
//   }

//   if (startsWith != null) {
//     _logger.info('${event.message.author.username} running startsWith script: ${startsWith.name}');
//     return startsWith.run(event.message, channel, guild);
//   }

//   // Contains
//   Script? contains;
//   try {
//     contains =
//         scripts.firstWhere((element) => element.type == NomacCommandType.contains && message.contains(element.match));
//   } catch (err) {
//     contains = null;
//   }

//   if (contains != null) {
//     _logger.info('${event.message.author.username} running contains script: ${contains.name}');
//     return contains.run(event.message, channel, guild);
//   }

//   return null;
// }
