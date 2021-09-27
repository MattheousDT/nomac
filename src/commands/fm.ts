import { SlashCommandBuilder } from "@discordjs/builders";
import { CommandInteraction, MessageAttachment, MessageEmbed } from "discord.js";
import { container } from "tsyringe";
import LastFmService from "../services/lastfm_service";
import UserService from "../services/user_service";
import { escapeMarkdown } from "../utils/strings";

export default new SlashCommandBuilder()
	.setName("fm")
	.setDescription("Get last.fm information")
	.addSubcommand((option) =>
		option
			.setName("recent")
			.setDescription("Get most recently played/playing tracks")
			.addStringOption((str) =>
				str
					.setName("username")
					.setDescription("Last.fm username. Defaults to the one specified in /fm save")
			)
	)
	.addSubcommand((option) =>
		option
			.setName("artists")
			.setDescription("Get a user's top artists")
			.addStringOption((str) =>
				str
					.setName("username")
					.setDescription("Last.fm username. Defaults to the one specified in /fm save")
			)
			.addStringOption((str) =>
				str
					.setName("period")
					.setDescription("Timescale of the query. Defaults to week")
					.addChoices([
						["Last week", "7day"],
						["Last month", "month"],
						["Last 3 months", "3month"],
						["Last year", "12month"],
						["All time", "overall"],
					])
			)
	)
	.addSubcommand((option) =>
		option
			.setName("albums")
			.setDescription("Get a user's top albums")
			.addStringOption((str) =>
				str
					.setName("username")
					.setDescription("Last.fm username. Defaults to the one specified in /fm save")
			)
			.addStringOption((str) =>
				str
					.setName("period")
					.setDescription("Timescale of the query. Defaults to week")
					.addChoices([
						["Last week", "7day"],
						["Last month", "month"],
						["Last 3 months", "3month"],
						["Last year", "12month"],
						["All time", "overall"],
					])
			)
	)
	.addSubcommand((option) =>
		option
			.setName("collage")
			.setDescription("Render a collage of album art based on top plays")
			.addStringOption((str) =>
				str
					.setName("username")
					.setDescription("Last.fm username. Defaults to the one specified in /fm save")
			)
			.addStringOption((str) =>
				str
					.setName("period")
					.setDescription("Timescale of the query. Defaults to week")
					.addChoices([
						["Last week", "7day"],
						["Last month", "month"],
						["Last 3 months", "3month"],
						["Last year", "12month"],
						["All time", "overall"],
					])
			)
	)
	.addSubcommand((option) =>
		option
			.setName("save")
			.setDescription("Save your last.fm username to NOMAC for future usage")
			.addStringOption((str) =>
				str.setName("username").setDescription("Last.fm username").setRequired(true)
			)
	);

export const fmRecent = async (interaction: CommandInteraction) => {
	const user = container.resolve(UserService);
	const lastfm = container.resolve(LastFmService);

	let username = interaction.options.getString("username");

	if (!username) {
		const dbUser = await user.getUserByDiscordId(interaction.member!.user.id);

		if (!dbUser || !dbUser.lastfm_username) {
			return interaction.reply({
				content: "Username not set. Specify a username or use `/fm save` to save your username",
				ephemeral: true,
			});
		}

		username = dbUser.lastfm_username;
	}

	try {
		const res = await lastfm.getRecentTracks(username);
		const tracks = res.recenttracks.track;

		const embed = new MessageEmbed()
			.setAuthor("NOMAC // last.fm")
			.setColor("#B972DA")
			.setTitle(`last.fm/user/${escapeMarkdown(username)}`)
			.setURL(`https://last.fm/user/${escapeMarkdown(username)}`)
			.setThumbnail(tracks[0].image[2]["#text"])
			.addFields([
				{
					name: tracks[0]["@attr"]?.nowplaying ? "Currently Playing" : "Most recently played",
					value: `${tracks[0].name} - ${tracks[0].artist["#text"]}\n*${tracks[0].album["#text"]}*`,
				},
				{
					name: "Previous",
					value: `${tracks[1].name} - ${tracks[1].artist["#text"]}\n*${tracks[1].album["#text"]}*`,
				},
			]);

		return interaction.reply({ embeds: [embed] });
	} catch (error) {
		return interaction.reply({
			content: `No tracks found for ${username}`,
			ephemeral: true,
		});
	}
};

export const fmArtists = async (interaction: CommandInteraction) => {
	const user = container.resolve(UserService);
	const lastfm = container.resolve(LastFmService);

	let username = interaction.options.getString("username");
	let period = interaction.options.getString("period");

	if (!username) {
		const dbUser = await user.getUserByDiscordId(interaction.member!.user.id);

		if (!dbUser || !dbUser.lastfm_username) {
			return interaction.reply({
				content: "Username not set. Specify a username or use `/fm save` to save your username",
				ephemeral: true,
			});
		}

		username = dbUser.lastfm_username;
	}

	try {
		const res = await lastfm.getTopArtists(username, period ?? undefined);
		const artists = res.topartists.artist;

		const embed = new MessageEmbed()
			.setAuthor("NOMAC // last.fm")
			.setColor("#B972DA")
			.setTitle(`last.fm/user/${escapeMarkdown(username)}`)
			.setURL(`https://last.fm/user/${escapeMarkdown(username)}`)
			.addFields(
				artists.map((x) => ({
					name: x.name,
					value: `${x.playcount} plays`,
				}))
			);

		return interaction.reply({ embeds: [embed] });
	} catch (error) {
		return interaction.reply({
			content: `An error occured or no artists found for ${username}`,
			ephemeral: true,
		});
	}
};

export const fmAlbums = async (interaction: CommandInteraction) => {
	const user = container.resolve(UserService);
	const lastfm = container.resolve(LastFmService);

	let username = interaction.options.getString("username");
	let period = interaction.options.getString("period");

	if (!username) {
		const dbUser = await user.getUserByDiscordId(interaction.member!.user.id);

		if (!dbUser || !dbUser.lastfm_username) {
			return interaction.reply({
				content: "Username not set. Specify a username or use `/fm save` to save your username",
				ephemeral: true,
			});
		}

		username = dbUser.lastfm_username;
	}

	try {
		const res = await lastfm.getTopAlbums(username, period ?? undefined);
		const albums = res.topalbums.album;

		const embed = new MessageEmbed()
			.setAuthor("NOMAC // last.fm")
			.setColor("#B972DA")
			.setTitle(`last.fm/user/${escapeMarkdown(username)}`)
			.setURL(`https://last.fm/user/${escapeMarkdown(username)}`)
			.setThumbnail(albums[0].image[2]["#text"])
			.addFields(
				albums.map((x) => ({
					name: x.name,
					value: `${x.playcount} plays`,
				}))
			);

		return interaction.reply({ embeds: [embed] });
	} catch (error) {
		return interaction.reply({
			content: "Username not set. Specify a username or use `/fm save` to save your username",
			ephemeral: true,
		});
	}
};

export const fmCollage = async (interaction: CommandInteraction) => {
	const user = container.resolve(UserService);
	const lastfm = container.resolve(LastFmService);

	let username = interaction.options.getString("username");
	let period = interaction.options.getString("period");

	if (!username) {
		const dbUser = await user.getUserByDiscordId(interaction.member!.user.id);

		if (!dbUser || !dbUser.lastfm_username) {
			return interaction.reply({
				content: "Username not set. Specify a username or use `/fm save` to save your username",
				ephemeral: true,
			});
		}

		username = dbUser.lastfm_username;
	}

	try {
		interaction.deferReply();
		const res = await lastfm.getCollage(username, period ?? undefined);
		const file = new MessageAttachment(res);

		return interaction.editReply({ files: [file] });
	} catch (error) {
		return interaction.editReply({
			content: `An error occured or no data was found for ${username}`,
		});
	}
};

export const fmSave = async (interaction: CommandInteraction) => {
	const user = container.resolve(UserService);

	const username = interaction.options.getString("username", true);

	try {
		await user.updateUserByDiscordId(interaction.member!.user.id, {
			lastfm_username: username,
		});

		return interaction.reply({
			content: `Your username has been set to ${username}`,
			ephemeral: true,
		});
	} catch (error) {
		return interaction.reply({ content: `An error occurred`, ephemeral: true });
	}
};
