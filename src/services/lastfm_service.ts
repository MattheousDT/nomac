import fetch from "node-fetch";
import { Logger } from "pino";
import { autoInjectable, inject } from "tsyringe";
import { URLSearchParams } from "url";
import { LastFmRecentTracksResponse, LastFmTopAlbumsResponse, LastFmTopArtistsResponse } from "../types/lastfm_types";

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
    });

    return fetch(`https://ws.audioscrobbler.com/2.0?${params.toString()}`).then((x) => x.json());
  };

  getTopArtists = async (user: string, period: string) =>
    this.request<LastFmTopArtistsResponse>("user.gettopartists", user, period);

  getTopAlbums = async (user: string, period: string) =>
    this.request<LastFmTopAlbumsResponse>("user.gettopalbums", user, period);

  getRecentTracks = async (user: string, period: string) =>
    this.request<LastFmRecentTracksResponse>("user.getrecenttracks", user, "all");

  getCollage = async (user: string, period: string) => {
    const params = new URLSearchParams({
      user,
      period,
      size: "3x3",
    });

    return fetch(`https://www.tapmusic.net/collage.php?${params.toString()}`).then((x) => x.arrayBuffer());
  };
}
