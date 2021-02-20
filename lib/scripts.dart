import 'scripts/abbreviation.dart';
import 'scripts/album.dart';
import 'scripts/fm.dart';
import 'scripts/help.dart';
import 'scripts/info.dart';
import 'scripts/js.dart';
import 'scripts/role.dart';
import 'models/script.dart';

// TODO: Replace with reflection
final scripts = <Script>[
  // Commands
  Album()..setup(),
  Abbreviation()..setup(),
  Info()..setup(),
  Js()..setup(),
  Help()..setup(),
  LastFm()..setup(),
  Role()..setup(),
];
