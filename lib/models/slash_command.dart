import "package:nyxx/nyxx.dart";
import "package:nyxx_interactions/interactions.dart";

import "../service_locator.dart";
import "../util/extensions/iterables.dart";

abstract class NomacSlashCommand {
  final String name;
  final bot = di<Nyxx>();
  final interactions = di<Interactions>();

  NomacSlashCommand(this.name);

  EmbedAuthorBuilder get embedAuthor => EmbedAuthorBuilder()..name = "NOMAC // $name";

  InteractionOption getSubCommand(SlashCommandInteractionEvent event, String name) =>
      event.interaction.options.firstWhere((element) => element.name == name);

  InteractionOption? getArg(InteractionOption option, String name) =>
      option.args.firstWhereOrNull((element) => element.name == name);

  SlashCommandBuilder build() {
    throw UnimplementedError();
  }
}
