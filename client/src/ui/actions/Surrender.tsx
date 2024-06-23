import { useDojo } from "@/dojo/useDojo";
import { usePlayer } from "@/hooks/usePlayer";
import { useCallback, useMemo } from "react";
import { Account } from "starknet";
import { Button } from "../elements/ui/button";
import { useGame } from "@/hooks/useGame";

export const Surrender = () => {
  const {
    account: { account },
    master,
    setup: {
      systemCalls: { surrender },
    },
  } = useDojo();

  const { player } = usePlayer({ playerId: account?.address || "0x0" });
  const { game } = useGame({ gameId: player?.game_id || 0 });

  const handleClick = useCallback(() => {
    surrender({ account: account as Account });
  }, [account]);

  const disabled = useMemo(
    () => !account || !master || account == master || !player || !game,
    [account, master, player, game],
  );

  return (
    <div>
      <Button disabled={disabled} onClick={handleClick}>
        Surrender
      </Button>
    </div>
  );
};
