import { SlashCommandBuilder } from "@discordjs/builders";
import { CommandInteraction } from "discord.js";
import abbreviations from "../utils/abbreviations";

export default new SlashCommandBuilder()
  .setName("abbr")
  .setDescription("Access our abbbreviation database")
  .addSubcommand((option) =>
    option
      .setName("get")
      .setDescription("Gets the definition of an abbreviation")
      .addStringOption((str) =>
        str.setName("abbreviation").setDescription("The abbreviation you want to find out").setRequired(true)
      )
  );

export const abbreviationGet = (interaction: CommandInteraction) => {
  const search = interaction.options.getString("abbreviation", true);

  const res = abbreviations.find((x) => x[0].includes(search));

  if (!res)
    return interaction.reply({
      content: "No abbreviations found that match",
    });

  return interaction.reply({ content: res[1] });
};
