// ignore: import_of_legacy_library_into_null_safe
import 'package:dotenv/dotenv.dart' show env;
import 'package:nyxx_commander/commander.dart';

abstract class NomacCommand {
  final String authorId;
  final String name;
  final String description;
  final String help;
  final String? thumbnail;
  final String match;
  final bool adminOnly;

  NomacCommand({
    required this.authorId,
    required this.name,
    required this.description,
    required this.help,
    this.thumbnail,
    required this.match,
    required this.adminOnly,
  });

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
