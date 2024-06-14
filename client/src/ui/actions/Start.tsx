import { useDojo } from "@/dojo/useDojo";
import { useCallback, useMemo } from "react";
import { Account } from "starknet";
import { useGame } from "@/hooks/useGame";
import { usePlayer } from "@/hooks/usePlayer";
import { Button } from "../elements/ui/button";

export const Start = ({ gameId }: { gameId: number }) => {
  const {
    account: { account },
    master,
    setup: {
      systemCalls: { start },
    },
  } = useDojo();

  const { player } = usePlayer({ playerId: account.address });
  const { game } = useGame({ gameId });

  const handleClick = useCallback(() => {
    start({
      account: account as Account,
      game_id: gameId,
    });
  }, [account, gameId]);

  const disabled = useMemo(() => {
    return !account || !master || account === master || !player || !game;
  }, [account, master, player, game]);

  return (
    <div>
      <Button disabled={disabled} onClick={handleClick}>
        Start
      </Button>
    </div>
  );
};
