import { useDojo } from "@/dojo/useDojo";
import { shortenHex } from "@dojoengine/utils";
import { Button } from "../elements/ui/button";

export const Account = () => {
  const {
    account: { account, create, clear, list, select },
  } = useDojo();

  return (
    <div className="flex gap-2 justify-center items-center">
      <Button onClick={() => create()}>Deploy</Button>
      <p>{shortenHex(account.address)}</p>
    </div>
  );
};
