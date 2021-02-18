import 'commands/abbreviation.dart';
import 'commands/fm.dart';
import 'commands/help.dart';
import 'commands/info.dart';
import 'models/script.dart';

// TODO: Replace with reflection
List<Script> commands = [
  Abbreviation(),
  Info(),
  Help(),
  LastFm(),
];
