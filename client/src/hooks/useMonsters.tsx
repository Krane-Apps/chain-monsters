import { useEffect, useState } from "react";
import { useDojo } from "@/dojo/useDojo";
import { getComponentValue, Has, HasValue, NotValue } from "@dojoengine/recs";
import { useEntityQuery } from "@dojoengine/react";
import { Monster } from "@/dojo/game/models/monster";

export const useMonsters = ({
  gameId,
}: {
  gameId: number;
}): { monsters: Monster[] } => {
  const [monsters, setMonsters] = useState<any>({});

  const {
    setup: {
      clientModels: {
        models: { Monster },
        classes: { Monster: MonsterClass },
      },
    },
  } = useDojo();

  const monsterKeys = useEntityQuery([
    Has(Monster),
    HasValue(Monster, { game_id: gameId }),
    NotValue(Monster, { health: 0 }),
  ]);

  useEffect(() => {
    const components = monsterKeys.map((entity) => {
      const component = getComponentValue(Monster, entity);
      if (!component || component.health === 0) {
        return undefined;
      }
      return new MonsterClass(component);
    });

    setMonsters(components);
  }, [monsterKeys]);

  return { monsters: Object.values(monsters) };
};
