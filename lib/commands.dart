import 'commands/abbreviation.dart';
import 'commands/base.dart';
import 'commands/fm.dart';
import 'commands/info.dart';

List<NomacCommand> commands = [
  Abbreviation(),
  Info(),
  LastFm(),
];
