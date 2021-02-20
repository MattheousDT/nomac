import 'package:nyxx/nyxx.dart';

import '../constants.dart';
import '../models/script.dart';

class Info extends Script {
  Info()
      : super(
          authorId: '190914446774763520',
          name: 'Info',
          description: 'Gives info innit',
          example: 'bruhhhh',
          match: 'info',
          adminOnly: true,
          type: NomacCommandType.command,
        );

  @override
  Future<Message> cb(message, channel, guild, args) async {
    await message.delete();
    await channel.sendMessage(embed: _welcomeEmbed());
    await channel.sendMessage(embed: _rulesEmbed());
    await channel.sendMessage(embed: _channelsEmbed());
    return await channel.sendMessage(embed: _botEmbed());
  }

  EmbedBuilder _welcomeEmbed() {
    var embed = EmbedBuilder()
      ..imageUrl = 'https://cdn.discordapp.com/attachments/809816006771867669/811995773868441631/unknown.png'
      ..color = nomacDiscordColor;

    return embed;
  }

  EmbedBuilder _rulesEmbed() {
    var embed = EmbedBuilder()
      ..thumbnailUrl = 'https://cdn.discordapp.com/attachments/809816006771867669/811987970243559444/unknown.png'
      ..color = nomacDiscordColor
      ..title = 'What are the rules?';

    _rules.entries.forEach(
      (element) => embed.addField(
        name: element.key,
        content: element.value,
      ),
    );

    return embed;
  }

  EmbedBuilder _channelsEmbed() {
    var embed = EmbedBuilder()
      ..thumbnailUrl = 'https://cdn.discordapp.com/attachments/809816006771867669/812007872451313664/unknown.png'
      ..color = nomacDiscordColor
      ..title = 'What are all these channels?'
      ..description = _channels.entries.map((element) => '<#${element.key}>\n${element.value}').join('\n\n');

    return embed;
  }

  EmbedBuilder _botEmbed() {
    var embed = EmbedBuilder()
      ..thumbnailUrl = 'https://cdn.discordapp.com/attachments/809816006771867669/811999080208793670/main-nomac.png'
      ..color = nomacDiscordColor
      ..title = 'NOMAC - Our Discord Bot!'
      ..url = 'https://github.com/MattheousDT/nomac'
      ..description =
          'NOMAC is a custom, open-source bot created specifically for the Dream Theater Discord. It features an entire database of Dream Theater information, a last.fm command, and much more.\n\nRun the following command to get started!\n```${prefix}help```';

    return embed;
  }
}

const _rules = {
  '1. Don\'t be a dick':
      'Pretty self explanatory. This server is extremely chill so please don\'t make others feel unwelcome',
  '2. Use the channels for their intended purposes': 'Post a meme in general, I dare you 😎👍',
  '3. Don\'t only self promote': 'If you are only here for self-promotion, this will result in a ban.',
  '4. No prejudice of any kind towards any other members':
      'This means homophobia, sexism, transphobia, xenophobia etc.',
  '5. Keep it clean': 'No NSFW media in this Christian server™. There are people of all ages here',
};

const _channels = {
  // #headlines
  '289462930792120321': 'Newsflash! This is the news channel!',
  // #general
  '285057239159668736':
      'Where you can have a general discussion about Dream Theater, or don\'t. I don\'t care, I swear... 😢',
  // #music-collabs
  '441336737604829185': 'Where you can collaborate with others or just share some music you\'ve been making',
  // #meme-theater
  '285108756684079104': 'Where you can find le dankest of le may mays, like mike > mike lmao xd',
  // noipad
  '355471458505326602': 'Sherinian, Portnoy et al. shitposting',
  // no-mike
  '302896374767419392':
      'For use when you are in a voice chat but don\'t have a microphone. Ha, see what we did there. #puns',
  // machine-clatter
  '285053795946463232': 'For controlling da boi below',
};
