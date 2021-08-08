import 'package:nyxx/nyxx.dart';

Future<bool> isAdmin(Snowflake id, Guild guild) async {
  final perms = await guild.fetchMember(id).then((value) => value.effectivePermissions);
  return (perms.administrator || perms.manageRoles);
}
