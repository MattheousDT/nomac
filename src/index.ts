import "reflect-metadata";
import dotenv from "dotenv";
dotenv.config();

import initDependencyInjection from "./utils/dependency_injection";
import { REST } from "@discordjs/rest";
import { Routes } from "discord-api-types/v9";
import { Client, Intents } from "discord.js";
import pino from "pino";
import abbreviation, { abbreviationGet } from "./commands/abbreviation";
import fm, { fmAlbums, fmArtists, fmCollage, fmRecent, fmSave } from "./commands/fm";

const client = new Client({
  intents: [Intents.FLAGS.GUILDS],
  presence: {
    activities: [
      {
        name: "v3.0.0 BETA",
        type: "PLAYING",
      },
    ],
  },
});
const logger = pino({ name: "NOMAC | Main", prettyPrint: true });

(async () => {
  await initDependencyInjection();
  await client.login(process.env.BOT_TOKEN);

  client.once("ready", () => main());

  client.on("interactionCreate", async (interaction) => {
    if (!interaction.isCommand()) return;

    switch (interaction.commandName) {
      case "abbr":
        if (interaction.options.getSubcommand() === "get") {
          abbreviationGet(interaction);
        }
        break;
      case "fm":
        switch (interaction.options.getSubcommand()) {
          case "recent":
            fmRecent(interaction);
            break;
          case "artists":
            fmArtists(interaction);
            break;
          case "albums":
            fmAlbums(interaction);
            break;
          case "collage":
            fmCollage(interaction);
            break;
          case "save":
            fmSave(interaction);
            break;
        }
    }
  });
})();

const main = async () => {
  logger.info("NOMAC Ready!");
  const rest = new REST({ version: "9" }).setToken(process.env.BOT_TOKEN!);
  await rest.put(Routes.applicationGuildCommands(client.application!.id, "316904232949121024"), {
    body: [abbreviation, fm],
  });
};
