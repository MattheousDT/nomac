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
  void registerArgs() {
    argParser..addOption('add', allowed: roles)..addOption('remove', allowed: roles)..addOption('user', abbr: 'u');
  }

  @override
  Future<Message> cb(context, message, args) async {
    String? add = args['add'];
    String? remove = args['remove'];
    String? user = args['user'];

    if (user != null) {
      if (context.guild?.currentUserPermissions?.manageRoles == false) {
        throw NomacException('You do not have the permissions to modify another user\'s roles');
      }
    } else {
      user = context.author.id.toString();
    }

    var member = await context.guild
        ?.fetchMember(user.toSnowflake())
        .catchError((err) => throw NomacException('Could not find the specified role'));

    var role =
        context.guild?.roles.findOne((item) => item.name.toLowerCase() == add || item.name.toLowerCase() == remove);

    if (member == null) {
      throw NomacException('Could not find the specified member');
    }

    if (role == null) {
      throw NomacException('Could not find the specified role');
    }

    if (add != null) {
      await member.addRole(role);
      return context.reply(content: 'Added role: ${role.name}');
    }

    if (remove != null) {
      await member.removeRole(role);
      return context.reply(content: 'Removed role: ${role.name}');
    }

    throw NomacException('This is not a valid command.');
  }
}
