import "reflect-metadata";
import dotenv from "dotenv";
import { REST } from "@discordjs/rest";
import { MongoClient } from "mongodb";
import { container } from "tsyringe";
import initDependencyInjection from "./utils/dependency_injection";
import UserService from "./services/user_service";
import { Routes } from "discord-api-types";
import { Client, Intents } from "discord.js";
import { SlashCommandBuilder } from "@discordjs/builders";
dotenv.config();

const client = new Client({ intents: [Intents.FLAGS.GUILDS] });

const main = async () => {
  await initDependencyInjection();

  // const rest = new REST({ version: "9" }).setToken(process.env.BOT_TOKEN!);

  // await rest.put(Routes.applicationCommands(client.application!.id), {
  //   body: [
  //     new SlashCommandBuilder().setName()
  //   ],
  // });
};

client.once("ready", () =>
  main().finally(() => {
    container.resolve(MongoClient).close();
  })
);
