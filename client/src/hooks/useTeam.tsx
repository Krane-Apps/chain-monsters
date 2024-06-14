import { useDojo } from "@/dojo/useDojo";
import { useMemo } from "react";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useComponentValue } from "@dojoengine/react";
import { Entity } from "@dojoengine/recs";

export const useTeam = ({
  gameId,
  teamIndex,
}: {
  gameId: number;
  teamIndex: number;
}) => {
  const {
    setup: {
      clientModels: {
        models: { Team },
        classes: { Team: TeamClass },
      },
    },
  } = useDojo();

  const teamKey = useMemo(
    () => getEntityIdFromKeys([BigInt(gameId), BigInt(teamIndex)]) as Entity,
    [gameId, teamIndex],
  );
  const component = useComponentValue(Team, teamKey);
  const team = useMemo(() => {
    return component ? new TeamClass(component) : null;
  }, [component]);

  return { team, teamKey };
};
