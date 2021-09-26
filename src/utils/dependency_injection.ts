import { Db, MongoClient } from "mongodb";
import pino from "pino";
import { container } from "tsyringe";

const initDependencyInjection = async () => {
  container.register<MongoClient>(MongoClient, { useValue: new MongoClient(process.env["MONGO_CONNECTION_STRING"]!) });

  const mongo = await container.resolve(MongoClient).connect();
  container.register<Db>(Db, { useValue: mongo.db() });

  container.register("pino", {
    useValue: pino({
      prettyPrint: {
        colorize: true,
      },
    }),
  });
};

export default initDependencyInjection;
