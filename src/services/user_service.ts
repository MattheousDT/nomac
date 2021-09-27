import { Collection, Db } from "mongodb";
import { autoInjectable } from "tsyringe";
import { IUser } from "../types/user_types";

@autoInjectable()
export default class UserService {
	private coll: Collection;

	constructor(private db: Db) {
		this.coll = db.collection("users");
	}

	getUserByDiscordId = async (discord_id: string): Promise<IUser> => {
		return this.coll.findOne({
			discord_id,
		}) as Promise<IUser>;
	};

	updateUserByDiscordId = async (discord_id: string, data: Partial<Omit<IUser, "discord_id">>) => {
		return this.coll.findOneAndUpdate({ discord_id }, { $set: data });
	};

	deleteUser = async (discord_id: string) => {
		return this.coll.findOneAndDelete({ discord_id });
	};
}
