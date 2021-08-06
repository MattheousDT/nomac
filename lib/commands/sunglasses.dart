// import 'package:nomac/models/sunglasses/sunglasses.dart';
// import 'package:nyxx/nyxx.dart';
// import 'package:nyxx_interactions/interactions.dart';

// import '../models/slash_command.dart';
// import '../service_locator.dart';
// import '../services/sunglasses_service.dart';
// import '../util/is_admin.dart';

// class SunglassesCommand extends NomacSlashCommand {
//   final _sunglassesService = di<SunglassesService>();

//   SunglassesCommand() : super('Sunglasses 😎');

//   @override
//   SlashCommand create() {
//     return interactions.createCommand(
//       'sunglasses',
//       '😎',
//       [
//         CommandArg(
//           CommandArgType.subCommand,
//           'own',
//           'Le epically own someone',
//           options: [
//             CommandArg(
//               CommandArgType.user,
//               'user',
//               'Who you want to epically own',
//               required: true,
//             ),
//           ],
//         ),
//         CommandArg(
//           CommandArgType.subCommand,
//           'count',
//           'Check how many times you\'ve been le epically owned by a mod',
//         ),
//         CommandArg(
//           CommandArgType.subCommand,
//           'ownage',
//           'Check how many times you\'ve le epically owned someone else',
//         ),
//         CommandArg(
//           CommandArgType.subCommand,
//           'leaderboard',
//           'Find out who has been epically owned the most',
//         ),
//       ],
//       guild: Snowflake('512050257626923019'),
//     );
//   }

//   @override
//   Future<void> run(InteractionEvent event) async {
//     if (event.interaction.name == 'sunglasses') {
//       final args = event.interaction.args;
//       for (var arg in args) {
//         switch (arg.name) {
//           case 'own':
//             return await _own(event, Snowflake(arg.args.last.value));
//           case 'count':
//             return await _count(event);
//           case 'ownage':
//             return await _ownage(event);
//           case 'leaderboard':
//             return await _leaderboard(event);
//         }
//       }
//     }
//   }

//   Future<void> _own(InteractionEvent event, Snowflake id) async {
//     if (!await isAdmin(event.interaction.author.id, event.interaction.guild.getFromCache()!)) {
//       return event.reply(content: 'Nice try 😎', showSource: true);
//     }

//     final user = await bot.fetchUser(id);

//     await _sunglassesService.own(Sunglasses(
//       victim: id.toString(),
//       ownedBy: event.interaction.author.id.toString(),
//       date: event.receivedAt,
//     ));

//     final count = await _sunglassesService.ownedCount(id.toString());

//     await event.reply(content: '${user.mention} has now been 😎\'d **${count} times!**');
//   }

//   Future<void> _count(InteractionEvent event) async {
//     final count = await _sunglassesService.ownedCount(event.interaction.author.id.toString());

//     return event.reply(
//       content: 'You have been 😎\'d **$count times!**',
//       showSource: true,
//     );
//   }

//   Future<void> _ownage(InteractionEvent event) async {
//     final count = await _sunglassesService.ownageCount(event.interaction.author.id.toString());

//     return event.reply(
//       content: 'You have le epically owned noobs **$count times!** 😎',
//       showSource: true,
//     );
//   }

//   Future<void> _leaderboard(InteractionEvent event) async {
//     throw UnimplementedError();
//     //return event.reply(embed: embed, showSource: true);
//   }
// }
