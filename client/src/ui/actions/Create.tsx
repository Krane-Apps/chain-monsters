import { useDojo } from "@/dojo/useDojo";
import { usePlayer } from "@/hooks/usePlayer";
import { useCallback, useMemo } from "react";
import { Account } from "starknet";
import { Button } from "../elements/ui/button";

export const Create = ({
  roles,
  clans,
}: {
  roles: number[];
  clans: number[];
}) => {
  const {
    account: { account },
    master,
    setup: {
      systemCalls: { create },
    },
  } = useDojo();

  const { player } = usePlayer({ playerId: account?.address || "0x0" });

  const handleClick = useCallback(() => {
    create({ account: account as Account, roles, clans });
  }, [account]);

  const disabled = useMemo(
    () => !account || !master || account == master || !player,
    [account, master, player],
  );

  return (
    <div>
      <Button disabled={disabled} onClick={handleClick}>
        Create
      </Button>
    </div>
  );
};
