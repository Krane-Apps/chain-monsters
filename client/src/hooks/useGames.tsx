import { useEffect, useState } from "react";
import { useDojo } from "@/dojo/useDojo";
import { getComponentValue, Has } from "@dojoengine/recs";
import { useEntityQuery } from "@dojoengine/react";
import { Game } from "@/dojo/game/models/game";

export const useGames = (): { games: Game[] } => {
  const [games, setGames] = useState<any>({});

  const {
    setup: {
      clientModels: {
        models: { Game },
        classes: { Game: GameClass },
      },
    },
  } = useDojo();

  const gameKeys = useEntityQuery([Has(Game)]);

  useEffect(() => {
    const components = gameKeys.map((entity) => {
      const component = getComponentValue(Game, entity);
      if (!component || component.player_count === 0) {
        return undefined;
      }
      return new GameClass(component);
    });

    const objectified = components.reduce(
      (obj: any, game: Game | undefined) => {
        if (game) {
          obj[game.id] = game;
        }
        return obj;
      },
      {},
    );

    const ordered = Object.keys(objectified)
      .sort()
      .reduce((obj: any, key: string) => {
        obj[key] = objectified[key];
        return obj;
      }, {});

    setGames(ordered);
  }, [gameKeys]);

  return { games: Object.values(games) };
};
