import "package:nomac/models/user/user.dart";
import "package:nomac/util/escape_markdown.dart";
import "package:nyxx/nyxx.dart";
import "package:nyxx_interactions/interactions.dart";

import "../models/slash_command.dart";
import "../service_locator.dart";
import "../services/lastfm_service.dart";
import "../services/user_service.dart";
import "../util/constants.dart";

class LastFm extends NomacSlashCommand {
  final _userService = di<UserService>();
  final _lastFmService = di<LastFmService>();

  LastFm() : super("Last.fm");

  final _periodArg = CommandOptionBuilder(
    CommandOptionType.string,
    "period",
    "Timescale of the query. Defaults to week",
    choices: [
      ArgChoiceBuilder("Last week", "7day"),
      ArgChoiceBuilder("Last month", "month"),
      ArgChoiceBuilder("Last 3 months", "3month"),
      ArgChoiceBuilder("Last year", "12month"),
      ArgChoiceBuilder("All time", "overall"),
    ],
  );

  final _usernameArg = CommandOptionBuilder(
    CommandOptionType.string,
    "username",
    "Last.fm username. Defaults to the one specified in /fm set",
  );

  @override
  SlashCommandBuilder build() {
    return SlashCommandBuilder(
      "fm",
      "Get last.fm information",
      [
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          "recent",
          "Get most recently played/playing tracks",
          options: [_usernameArg],
        )..registerHandler(_recent),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          "artists",
          "Get your top artists",
          options: [_periodArg, _usernameArg],
        )..registerHandler(_artists),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          "albums",
          "Get your top albums",
          options: [_periodArg, _usernameArg],
        )..registerHandler(_albums),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          "collage",
          "Render a collage of album art based on top plays",
          options: [_periodArg, _usernameArg],
        )..registerHandler(_collage),
        CommandOptionBuilder(
          CommandOptionType.subCommand,
          "set",
          "Set your last.fm username for future usage",
          options: [
            CommandOptionBuilder(
              CommandOptionType.string,
              "username",
              "Last.fm username. Defaults to the one specified in /fm set",
              required: true,
            ),
          ],
        )..registerHandler(_set),
      ],
      guild: 285051699717210113.toSnowflake(),
    );
  }

  // @override
  // Future<void> run(InteractionEvent event) async {
  //   if (event.interaction.name == "fm") {
  //     final args = event.interaction.args;
  //     final opts = args.first.args;

  //     String? user = opts.firstWhereOrNull((x) => x.name == "user")?.value;

  //     if (user == null) {
  //       final dbUser = await _userService.getUserByDiscordId(event.interaction.author.id.toString());
  //       if (dbUser?.lastfmUsername == null) throw Error();
  //       user = dbUser!.lastfmUsername!;
  //     }

  //     String period = opts.firstWhereOrNull((x) => x.name == "period")?.value ?? "7day";

  //     final embed = EmbedBuilder()
  //       ..author = embedAuthor
  //       ..color = nomacDiscordColor
  //       ..title = "last.fm/user/${escapeMarkdown(user)}";

  //     for (var arg in args) {
  //       switch (arg.name) {
  //         case "recent":
  //           return await _recent(event, user, embed);
  //         case "artists":
  //           return await _artists(event, user, period, embed);
  //         case "albums":
  //           return await _albums(event, user, period, embed);
  //         case "set":
  //           return await _set(event, user);
  //         case "collage":
  //           return await _collage(event, user, period);
  //       }
  //     }
  //   }
  // }

  Future<void> _recent(SlashCommandInteractionEvent event) async {
    final recent = getSubCommand(event, "recent");

    String? username = getArg(recent, "username")?.value;

    if (username == null) {
      final dbUser = await _userService.getUserByDiscordId(event.interaction.memberAuthor.id.toString());
      if (dbUser?.lastfmUsername == null) {
        return await event.respond(
          MessageBuilder.content("No username provided. Add it as an argument or use /fm set to remember in future"),
        );
      } else {
        username = dbUser!.lastfmUsername!;
      }
      ;
    }

    // String period = getArg(recent, "period")?.value ?? "7day";

    try {
      var data = await _lastFmService.getRecent(username);
      final embed = EmbedBuilder()
        ..author = embedAuthor
        ..color = nomacDiscordColor
        ..title = "last.fm/user/${escapeMarkdown(username)}"
        ..addField(
            field: EmbedFieldBuilder(data[0].nowPlaying ? "Currently playing" : "Most recent",
                "${data[0].name} - ${data[0].artistName}\n*${data[0].albumName}*"))
        ..addField(
            field: EmbedFieldBuilder("Previous", "${data[1].name} - ${data[1].artistName}\n*${data[1].albumName}*"));

      await event.respond(MessageBuilder.embed(embed));
    } catch (err) {
      await event.respond(MessageBuilder.content("Maybe your username is wrong?"));
    }
  }

  Future<void> _artists(SlashCommandInteractionEvent event) async {
    final artists = getSubCommand(event, "artists");

    String? username = getArg(artists, "username")?.value;

    if (username == null) {
      final dbUser = await _userService.getUserByDiscordId(event.interaction.memberAuthor.id.toString());
      if (dbUser?.lastfmUsername == null) {
        return await event.respond(
          MessageBuilder.content("No username provided. Add it as an argument or use /fm set to remember in future"),
        );
      } else {
        username = dbUser!.lastfmUsername!;
      }
      ;
    }

    String period = getArg(artists, "period")?.value ?? "7day";

    try {
      var data = await _lastFmService.getTopArtists(username, period);

      final embed = EmbedBuilder()
        ..author = embedAuthor
        ..color = nomacDiscordColor
        ..title = "last.fm/user/${escapeMarkdown(username)}"
        ..url = "https://last.fm/user/$username";

      data.forEach(
        (e) => embed.addField(field: EmbedFieldBuilder(e.name, "${e.playCount} plays")),
      );

      await event.respond(MessageBuilder.embed(embed));
    } catch (err) {
      await event.respond(MessageBuilder.content("Maybe your username is wrong?"));
    }
  }

  Future<void> _albums(SlashCommandInteractionEvent event) async {
    final albums = getSubCommand(event, "albums");

    String? username = getArg(albums, "username")?.value;

    if (username == null) {
      final dbUser = await _userService.getUserByDiscordId(event.interaction.memberAuthor.id.toString());
      if (dbUser?.lastfmUsername == null) {
        return await event.respond(
          MessageBuilder.content("No username provided. Add it as an argument or use /fm set to remember in future"),
        );
      } else {
        username = dbUser!.lastfmUsername!;
      }
      ;
    }

    String period = getArg(albums, "period")?.value ?? "7day";

    try {
      var data = await _lastFmService.getTopAlbums(username, period);

      final embed = EmbedBuilder()
        ..author = embedAuthor
        ..color = nomacDiscordColor
        ..title = "last.fm/user/${escapeMarkdown(username)}"
        ..thumbnailUrl = data[0].imageUrl
        ..url = "https://last.fm/user/$username";

      data.forEach(
        (e) => embed.addField(field: EmbedFieldBuilder(e.name, "${e.playCount} plays")),
      );

      await event.respond(MessageBuilder.embed(embed));
    } catch (err) {
      await event.respond(MessageBuilder.content("Maybe your username is wrong?"));
    }
  }

  Future<void> _set(SlashCommandInteractionEvent event) async {
    final set = getSubCommand(event, "set");

    String? username = getArg(set, "username")?.value;

    try {
      final nomacUser = NomacUser(
        discordId: event.interaction.memberAuthor.id.toString(),
        lastfmUsername: username,
      );

      await _userService.updateUser(nomacUser);
      await event.respond(MessageBuilder.content('Your last.fm username has been set to "$username"'));
    } catch (err) {
      await event.respond(MessageBuilder.content(err.toString()));
    }
  }

  Future<void> _collage(SlashCommandInteractionEvent event) async {
    final collage = getSubCommand(event, "collage");

    await event.acknowledge();

    String? username = getArg(collage, "username")?.value;

    if (username == null) {
      final dbUser = await _userService.getUserByDiscordId(event.interaction.memberAuthor.id.toString());
      if (dbUser?.lastfmUsername == null) {
        return await event.respond(
          MessageBuilder.content("No username provided. Add it as an argument or use /fm set to remember in future"),
        );
      } else {
        username = dbUser!.lastfmUsername!;
      }
      ;
    }

    String period = getArg(collage, "period")?.value ?? "7day";

    late Uri img;

    try {
      img = await _lastFmService.getCollageUrl(username, period);

      await event.respond(MessageBuilder.content(img.toString()));
    } catch (err) {
      await event.respond(MessageBuilder.content("Maybe your username is wrong?"));
    }
  }
}
