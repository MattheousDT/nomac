import 'commands/abbreviation.dart';
import 'commands/fm.dart';
import 'commands/help.dart';
import 'commands/info.dart';
import 'commands/js.dart';
import 'commands/role.dart';
import 'models/script.dart';

// TODO: Replace with reflection
List<Script> commands = [
  Abbreviation(),
  Info(),
  Js(),
  Help(),
  LastFm(),
  Role(),
];
