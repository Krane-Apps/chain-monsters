import { useDojo } from "@/dojo/useDojo";
import { useMemo } from "react";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useComponentValue } from "@dojoengine/react";
import { Entity } from "@dojoengine/recs";

export const usePlayer = ({ playerId }: { playerId: string }) => {
  console.log("usePlayer", playerId)
  const {
    setup: {
      clientModels: {
        models: { Player },
        classes: { Player: PlayerClass },
      },
    },
  } = useDojo();

  const playerKey = useMemo(
    () => getEntityIdFromKeys([BigInt(playerId)]) as Entity,
    [playerId],
  );
  console.log("playerKey", playerKey)
  const component = useComponentValue(Player, playerKey);
  console.log("component", component)
  const player = useMemo(() => {
    return component ? new PlayerClass(component) : null;
  }, [component]);

  return { player, playerKey };
};
