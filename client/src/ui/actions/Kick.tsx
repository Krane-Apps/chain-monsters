import { useDojo } from "@/dojo/useDojo";
import { useCallback, useMemo } from "react";
import { Account } from "starknet";
import { useGame } from "@/hooks/useGame";
import { usePlayer } from "@/hooks/usePlayer";
import { useTeam } from "@/hooks/useTeam";
import { Button } from "../elements/ui/button";

export const Kick = ({
  gameId,
  teamIndex,
}: {
  gameId: number;
  teamIndex: number;
}) => {
  const {
    account: { account },
    master,
    setup: {
      systemCalls: { kick },
    },
  } = useDojo();

  const { player } = usePlayer({ playerId: account.address });
  const { game } = useGame({ gameId });
  const { team } = useTeam({ gameId, teamIndex });

  const handleClick = useCallback(() => {
    kick({
      account: account as Account,
      game_id: gameId,
      team_index: teamIndex,
    });
  }, [account, gameId]);

  const disabled = useMemo(() => {
    return (
      !account || !master || account === master || !player || !game || !team
    );
  }, [account, master, player, game, team]);

  return (
    <div>
      <Button disabled={disabled} onClick={handleClick}>
        Kick
      </Button>
    </div>
  );
};
