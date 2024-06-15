import { useDojo } from "@/dojo/useDojo";
import { usePlayer } from "@/hooks/usePlayer";
import { useCallback, useMemo } from "react";
import { Account } from "starknet";
import { Button } from "../elements/ui/button";
import { useGame } from "@/hooks/useGame";

export const Move = () => {
  const {
    account: { account },
    master,
    setup: {
      systemCalls: { move },
    },
  } = useDojo();

  const { player } = usePlayer({ playerId: account.address });
  const { game } = useGame({ gameId: player?.game_id || 0 });

  const handleClick = useCallback(() => {
    if (!game) return;
    move({
      account: account as Account,
      game_id: game.id,
      team_id: 1,
      monster_id: 3,
      x: 2,
      y: 2,
      special: false,
    });
  }, [account]);

  const disabled = useMemo(
    () => !account || !master || account == master || !player || !game,
    [account, master, player, game],
  );

  return (
    <div className="flex gap-2 justify-center items-center">
      <Button disabled={disabled} onClick={handleClick}>
        Move
      </Button>
    </div>
  );
};
