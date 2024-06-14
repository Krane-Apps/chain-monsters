import { useDojo } from "@/dojo/useDojo";
import { usePlayer } from "@/hooks/usePlayer";
import { shortenHex } from "@dojoengine/utils";
import { useCallback, useMemo, useState } from "react";
import { Account } from "starknet";
import { Button } from "../elements/ui/button";

export const Spawn = () => {
  const [playerName, setPlayerName] = useState("Placeholder");
  const {
    account: { account },
    master,
    setup: {
      systemCalls: { spawn },
    },
  } = useDojo();

  const { player } = usePlayer({ playerId: account.address });

  const handleClick = useCallback(() => {
    spawn({ account: account as Account, name: playerName });
  }, [account]);

  const disabled = useMemo(
    () => !account || !master || account == master || !!player || !playerName,
    [account, master, player],
  );

  return (
    <div className="flex gap-2 justify-center items-center">
      <Button disabled={disabled} onClick={handleClick}>
        Spawn
      </Button>
      {!!player && <p>{player.name}</p>}
    </div>
  );
};
