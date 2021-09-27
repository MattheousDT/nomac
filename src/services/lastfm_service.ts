import fetch from "node-fetch";
import { Logger } from "pino";
import { autoInjectable, inject } from "tsyringe";
import { URLSearchParams } from "url";
import {
	LastFmRecentTracksResponse,
	LastFmTopAlbumsResponse,
	LastFmTopArtistsResponse,
} from "../types/lastfm_types";

@autoInjectable()
export default class LastFmService {
	constructor(@inject("pino") private logger: Logger) {}

	private request = async <T>(method: string, user: string, period = "7day"): Promise<T> => {
		const params = new URLSearchParams({
			format: "json",
			api_key: process.env.LASTFM_TOKEN!,
			user,
			period,
			method,
			limit: "5",
		});

		return fetch(`https://ws.audioscrobbler.com/2.0?${params.toString()}`).then((x) => x.json());
	};

	getTopArtists = async (user: string, period = "7day") =>
		this.request<LastFmTopArtistsResponse>("user.gettopartists", user, period);

	getTopAlbums = async (user: string, period = "7day") =>
		this.request<LastFmTopAlbumsResponse>("user.gettopalbums", user, period);

	getRecentTracks = async (user: string) =>
		this.request<LastFmRecentTracksResponse>("user.getrecenttracks", user, "all");

	getCollage = async (user: string, period = "7day") => {
		const params = new URLSearchParams({
			user,
			type: period,
			size: "3x3",
		});

		const res = await fetch(`https://www.tapmusic.net/collage.php?${params.toString()}`);

		if (!res.headers.get("content-type")?.startsWith("image")) {
			throw new Error();
		}

		return res.buffer();
	};
}
