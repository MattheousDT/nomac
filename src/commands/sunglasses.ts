import { SlashCommandBuilder } from "@discordjs/builders";
import { CommandInteraction, MessageEmbed } from "discord.js";
import pino from "pino";
import { container } from "tsyringe";
import { client } from "..";
import SunglassesService from "../services/sunglasses_service";

export default new SlashCommandBuilder()
	.setName("sunglasses")
	.setDescription("😎")
	.addSubcommand((option) =>
		option
			.setName("own")
			.setDescription("Le epically own someone")
			.addUserOption((user) =>
				user.setName("user").setDescription("Who you want to epically own").setRequired(true)
			)
	)
	.addSubcommand((option) =>
		option
			.setName("count")
			.setDescription("Check how many times someone has been le epically owned by a mod")
			.addUserOption((user) => user.setName("user").setDescription("Someone other than yourself"))
	)
	.addSubcommand((option) =>
		option
			.setName("ownage")
			.setDescription("Check how many times someone has le epically owned someone else")
			.addUserOption((user) => user.setName("user").setDescription("Someone other than yourself"))
	)
	.addSubcommand((option) =>
		option.setName("leaderboard").setDescription("Find out who has been epically owned the most")
	);

export const sunglassesOwn = async (interaction: CommandInteraction) => {
	const sunglasses = container.resolve(SunglassesService);

	const user = interaction.options.getUser("user", true);

	// TODO: Fix permissions checking. This doesn't work
	// if (!((interaction.member!.permissions as string & 0x8) == 0x8)) {
	if (true) {
		return interaction.reply({ content: "Nice try 😎", ephemeral: true });
	}

	try {
		await sunglasses.own(user.id, interaction.user.id);
		const count = await sunglasses.ownedCount(user.id);

		return interaction.reply({
			content: `${user.username} has been le epically owned ${count} times`,
		});
	} catch (error) {
		return interaction.reply({
			content: `An unknown error occurred`,
			ephemeral: true,
		});
	}
};

export const sunglassesCount = async (interaction: CommandInteraction) => {
	const sunglasses = container.resolve(SunglassesService);

	const user = interaction.options.getUser("user") ?? interaction.user;

	try {
		const res = await sunglasses.ownedCount(user.id);

		return interaction.reply({
			content: `${user.username} has been le epically owned ${res} times`,
		});
	} catch (error) {
		return interaction.reply({
			content: `An unknown error occurred`,
			ephemeral: true,
		});
	}
};

export const sunglassesOwnage = async (interaction: CommandInteraction) => {
	const sunglasses = container.resolve(SunglassesService);

	const user = interaction.options.getUser("user") ?? interaction.user;

	try {
		const res = await sunglasses.ownageCount(user.id);

		return interaction.reply({
			content: `${user.username} has epically owned n00bs ${res} times`,
		});
	} catch (error) {
		return interaction.reply({
			content: `An unknown error occurred`,
			ephemeral: true,
		});
	}
};

export const sunglassesLeaderboard = async (interaction: CommandInteraction) => {
	const sunglasses = container.resolve(SunglassesService);

	try {
		const res = await sunglasses.getTop();

		const names = [];
		for await (const item of res) {
			const user = await client.users.fetch(item.discordId).catch(() => null);

			names.push(user?.username ?? "[Unknown User]");
		}

		const embed = new MessageEmbed()
			.setColor("#B972DA")
			.setTitle(`😎 Leaderboard`)
			.addFields(
				names.map((e, i) => ({
					name: `#${i + 1}`,
					value: `${e} - ${res[i].count}`,
				}))
			);

		return interaction.reply({ embeds: [embed] });
	} catch (error) {
		pino({ prettyPrint: true }).error(error as any);
		return interaction.reply({
			content: `An unknown error occurred`,
			ephemeral: true,
		});
	}
};
