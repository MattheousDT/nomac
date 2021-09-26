import { Collection, Db } from "mongodb";
import { autoInjectable, inject } from "tsyringe";
import { Logger } from "pino";
import { ISunglasses } from "../types/sunglasses_type";

@autoInjectable()
export default class SunglassesService {
  private coll: Collection;

  constructor(private db: Db, @inject("pino") private logger: Logger) {
    this.coll = db.collection("sunglasses");
  }

  own = async (victim: string, owned_by: string) => {
    const data: ISunglasses = {
      victim,
      owned_by,
      date: new Date(),
    };

    return await this.coll.insertOne({ data });
  };

  ownedCount = async (discordId: string) => {
    return await this.coll.countDocuments({
      victim: discordId,
    });
  };

  ownageCount = async (discordId: string) => {
    return await this.coll.countDocuments({
      owned_by: discordId,
    });
  };

  mostRecentOwnage = async (discordId: string) => {
    const res = this.coll.aggregate([
      {
        $match: {
          victim: discordId,
        },
      },
      {
        $sort: {
          date: -1,
        },
      },
      {
        $limit: 1,
      },
    ]);

    const arr = (await res.toArray()) as ISunglasses[];

    return arr.length > 0 ? arr[0] : null;
  };

  getTop = async () => {
    const res = this.coll.aggregate([
      {
        $group: {
          _id: "$victim",
          count: {
            $sum: 1,
          },
        },
      },
      {
        $sort: {
          count: -1,
        },
      },
      {
        $limit: 10,
      },
    ]);

    return (await res.toArray()).map((x) => ({
      discordId: x._id,
      count: x.count,
    }));
  };
}
