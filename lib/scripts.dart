import 'package:nomac/scripts/sunglasses.dart';

import 'scripts/abbreviation.dart';
import 'scripts/fm.dart';
import 'scripts/help.dart';
import 'scripts/info.dart';
import 'scripts/role.dart';
import 'models/script.dart';

// TODO: Replace with reflection
final scripts = <Script>[
  // Commands
  Abbreviation()..setup(),
  Info()..setup(),
  Help()..setup(),
  LastFm()..setup(),
  Role()..setup(),
  Sunglasses()..setup(),
];
