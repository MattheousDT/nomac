import 'commands/base.dart';
import 'commands/fm.dart';
import 'commands/info.dart';

List<NomacCommand> commands = [
  Info(),
  LastFm(),
];
