import 'commands/abbreviation.dart';
import 'commands/fm.dart';
import 'commands/help.dart';
import 'commands/info.dart';
import 'commands/js.dart';
import 'commands/role.dart';
import 'models/script.dart';

// TODO: Replace with reflection
final scripts = <Script>[
  // Commands
  Abbreviation()..setup(),
  Info()..setup(),
  Js()..setup(),
  Help()..setup(),
  LastFm()..setup(),
  Role()..setup(),
];
