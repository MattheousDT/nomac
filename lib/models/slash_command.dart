import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../service_locator.dart';

abstract class NomacSlashCommand {
  final String name;
  final bot = di<Nyxx>();
  final interactions = di<Interactions>();

  NomacSlashCommand(this.name);

  EmbedAuthorBuilder get embedAuthor => EmbedAuthorBuilder()..name = 'NOMAC // $name';

  SlashCommand create() {
    throw UnimplementedError();
  }

  Future<void> run(InteractionEvent event) async {
    throw UnimplementedError();
  }
}
