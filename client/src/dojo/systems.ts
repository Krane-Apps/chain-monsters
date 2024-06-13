import type { IWorld } from "./generated/contractSystems";

import { toast } from "sonner";
import * as SystemTypes from "./generated/contractSystems";
import { ClientModels } from "./models";
import { shortenHex } from "@dojoengine/utils";

export type SystemCalls = ReturnType<typeof systems>;

export function systems({
  client,
  clientModels,
}: {
  client: IWorld;
  clientModels: ClientModels;
}) {
  const extractedMessage = (message: string) => {
    return message.match(/\('([^']+)'\)/)?.[1];
  };

  const notify = (message: string, transaction: any) => {
    if (transaction.execution_status != "REVERTED") {
      toast.success(message, {
        description: shortenHex(transaction.transaction_hash),
        action: {
          label: "View",
          onClick: () =>
            window.open(
              `https://worlds.dev/networks/slot/worlds/guild-era/txs/${transaction.transaction_hash}`,
            ),
        },
      });
    } else {
      toast.error(extractedMessage(transaction.revert_reason));
    }
  };

  const create = async ({ account, ...props }: SystemTypes.Create) => {
    try {
      const { transaction_hash } = await client.actions.create({
        account,
        ...props,
      });

      notify(
        `Game has been created.`,
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        }),
      );
    } catch (error) {
      console.error("Error creating game:", error);
    }
  };

  const start = async ({ account, ...props }: SystemTypes.Start) => {
    try {
      const { transaction_hash } = await client.actions.start({
        account,
        ...props,
      });

      notify(
        `Game has been started.`,
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        }),
      );
    } catch (error) {
      console.error("Error starting game:", error);
    }
  };

  const play = async ({ account, ...props }: SystemTypes.Play) => {
    try {
      const { transaction_hash } = await client.actions.play({
        account,
        ...props,
      });

      notify(
        `Game has been played.`,
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        }),
      );
    } catch (error) {
      console.error("Error playing game:", error);
    }
  };

  return {
    create,
    start,
    play,
  };
}
