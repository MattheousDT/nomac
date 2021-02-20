import 'package:nyxx/nyxx.dart';

import '../constants.dart';
import '../models/script.dart';

class Role extends Script {
  Role()
      : super(
          authorId: '190914446774763520',
          name: 'Role Manager',
          description: 'Adds or removes a role of your choosing',
          example: '${prefix}role --add europe',
          match: 'role',
          adminOnly: true,
          type: NomacCommandType.command,
        );

  @override
  void setup() {
    argParser..addOption('add', allowed: roles)..addOption('remove', allowed: roles)..addOption('user', abbr: 'u');
  }

  @override
  Future<Message> cb(message, channel, guild, args) async {
    String? add = args['add'];
    String? remove = args['remove'];
    String? user = args['user'];

    if (user != null) {
      if (guild.currentUserPermissions?.manageRoles == false) {
        throw NomacException('You do not have the permissions to modify another user\'s roles');
      }
    } else {
      user = message.author.id.toString();
    }

    var member = await guild
        .fetchMember(user.toSnowflake())
        .catchError((err) => throw NomacException('Could not find the specified role'));

    var role = guild.roles.findOne((item) => item.name.toLowerCase() == add || item.name.toLowerCase() == remove);

    if (role == null) {
      throw NomacException('Could not find the specified role');
    }

    if (add != null) {
      await member.addRole(role);
      return channel.sendMessage(
        content: 'Added role: ${role.name}',
        replyBuilder: ReplyBuilder.fromMessage(message),
      );
    }

    if (remove != null) {
      await member.removeRole(role);
      return channel.sendMessage(
        content: 'Removed role: ${role.name}',
        replyBuilder: ReplyBuilder.fromMessage(message),
      );
    }

    throw NomacException('This is not a valid command.');
  }
}
