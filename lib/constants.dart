import 'package:dotenv/dotenv.dart';
import 'package:nyxx/nyxx.dart';

const nomacColor = '#B972DA';
final nomacDiscordColor = DiscordColor.fromHexString(nomacColor);

const warningColor = '#E91E63';
final warningDiscordColor = DiscordColor.fromHexString(nomacColor);

final isProduction = bool.fromEnvironment('dart.vm.product');

final prefix = env['PREFIX']!;

const roles = [
  'europe',
  'americas',
  'asia/oce',
  'guitar',
  'bass',
  'drums',
  'keyboard',
  'vocals',
];
