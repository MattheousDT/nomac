import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import 'base.dart';

class Abbreviation extends NomacCommand {
  Abbreviation()
      : super(
          authorId: '190914446774763520',
          name: 'Abbreviation',
          description: 'Provides the meaning of a song/album/etc. abbreviation',
          help: 'bruhhhh',
          match: 'abbrevation',
          matchAliases: ['abb', 'abbr'],
          adminOnly: false,
        );

  @override
  Future<Message> cb(CommandContext context, String message) {
    var abb = message.split(' ')[1].toLowerCase();

    if (abb == '') {
      return context.reply(
          content: 'No acronym provided. For example `!acronym sfam`');
    }

    Set<String> key;

    try {
      key = _abbreviations.keys.firstWhere((e) => e.contains(abb));
    } catch (e) {
      return context.reply(content: 'Could not find the acronym provided');
    }

    var match = _abbreviations[key];

    return context.reply(content: match);
  }
}

Map<Set<String>, String> _abbreviations = {
  // Song Abbreviations
  {'afil'}: 'A Fortune in Lies',
  {'tkh'}: 'The Killing Hand',
  {'oamot'}: 'Only a Matter of Time',
  {'pme'}: 'Pull Me Under',
  {'ttt'}: 'Take The Time',
  {'uagm'}: 'Under a Glass Moon',
  {'ltl'}: 'Learning to Live',
  {'acos'}: 'A Change of Seasons',
  {'ciaw'}: 'Caught in a Web',
  {'sdv'}: 'Space-Dye Vest',
  {'anm'}: 'A New Millenium',
  {'lits'}: 'Lines in the Sand',
  {'btl'}: 'Beyond This Life',
  {'tdoe'}: 'The Dance of Eternity',
  {'tgp'}: 'The Glass Prison',
  {'bf'}: 'Blind Faith',
  {'tgd'}: 'The Great Debate',
  {'sdoit', '6doit'}: 'Six Degrees of Inner Turbulence',
  {'tds'}: 'This Dying Soul',
  {'htf'}: 'Honer Thy Father',
  {'soc'}: 'Stream of Consciousness',
  {'itnog'}: 'In the Name of God',
  {'troae'}: 'The Root of all Evil',
  {'ss'}: 'Sacrificed Songs',
  {'8v', '8vm', '8var', 'vium'}: 'Octavarium',
  {'itpoe'}: 'In the Presence of Enemies',
  {'tden'}: 'The Dark Eternal Night',
  {'tmols', 'mols'}: 'The Ministry of Lost Souls',
  {'antr'}: 'A Nightmare to Remember',
  {'arop'}: 'A Rite of Passage',
  {'tsf'}: 'The Shattered Fortress',
  {'tbot'}: 'The Best of Times',
  {'tcot'}: 'The Count of Tuscany',
  {'otboa'}: 'On the Backs of Angels',
  {'bits'}: 'Bridges in the Sky',
  {'bai'}: 'Breaking All Illusions',
  {'tei'}: 'The Enemy Inside',
  {'str'}: 'Surrender to Reason',
  {'it'}: 'Illumination Theory',
  {'tgom'}: 'The Gift of Music',
  {'td', '3d'}: 'Three Days',
  {'anb'}: 'A New Beginning',
  {'mob'}: 'Moment of Betrayal',
  {'tptd'}: 'The Path That Divides',
  {'hoatv'}: 'Hymn of a Thousand Voices',
  {'onw'}: 'Our New World',
  {'fitl'}: 'Fall Into the Light',
  {'awe'}: 'At Wit\'s End',
  {'pbd'}: 'Pale Blue Dot',

  // Album Abbreviations
  {'wdadu'}: 'When Dream and Day Unite',
  {'iaw', 'i&w'}: 'Images and Words',
  {'acos'}: 'A Change of Seasons EP',
  {'sfam', 'm2', 'scenes'}: 'Metropolis Pt. 2: Scenes from a Memory',
  {'sdoit', '6doit'}: 'Six Degrees of Inner Turbulence',
  {'tot'}: 'Train of Thought or Trial of Tears',
  {'8v'}: 'Octavarium',
  {'sc'}: 'Systematic Chaos',
  {'bcsl', 'bcasl', 'bc&sl'}: 'Black Clouds and Silver Linings',
  {'adtoe'}: 'A Dramatic Turn of Events',
  {'dt12', 's/t'}: 'Dream Theater (self/titled, 12th album)',
  {'ta'}: 'The Astonishing',
  {'dot', 'd/t'}: 'Distance over Time',

  // Misc
  {'dt'}: 'Dream Theater',
  {'jp'}: 'John Petrucci',
  {'mm'}: 'Mike Mangini',
  {'jr'}: 'Jordan Rudess',
  {'jb', 'jlb'}: 'James LaBrie',
  {'mp'}: 'Mike Portnoy',
  {'nc'}: 'Nightmare Cinema',
  {'ds'}: 'Derek Sherinian',
  {'jm'}: 'John Myung',
  {'km'}: 'Kevin Moore',
};
