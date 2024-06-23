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
              `https://sepolia.voyager.online/tx/${transaction.transaction_hash}`,
            ),
        },
      });
    } else {
      toast.error(extractedMessage(transaction.revert_reason));
    }
  };

  const spawn = async ({ account, ...props }: SystemTypes.Spawn) => {
    try {
      const { transaction_hash } = await client.actions.spawn({
        account,
        ...props,
      });

      notify(
        `Player has spawned.`,
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        }),
      );
    } catch (error: any) {
      toast.error(extractedMessage(error.message));
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
    } catch (error: any) {
      toast.error(extractedMessage(error.message));
    }
  };

  // const join = async ({ account, ...props }: SystemTypes.Join) => {
  //   try {
  //     const { transaction_hash } = await client.actions.join({
  //       account,
  //       ...props,
  //     });

  //     notify(
  //       `Game has been joined.`,
  //       await account.waitForTransaction(transaction_hash, {
  //         retryInterval: 100,
  //       }),
  //     );
  //   } catch (error) {
  //     console.error("Error joining game:", error);
  //   }
  // };

  // const ready = async ({ account, ...props }: SystemTypes.Ready) => {
  //   try {
  //     const { transaction_hash } = await client.actions.ready({
  //       account,
  //       ...props,
  //     });

  //     notify(
  //       `Player updates his status.`,
  //       await account.waitForTransaction(transaction_hash, {
  //         retryInterval: 100,
  //       }),
  //     );
  //   } catch (error) {
  //     console.error("Error setting ready status:", error);
  //   }
  // };

  // const transfer = async ({ account, ...props }: SystemTypes.Transfer) => {
  //   try {
  //     const { transaction_hash } = await client.actions.transfer({
  //       account,
  //       ...props,
  //     });

  //     notify(
  //       `Host role has been transfered.`,
  //       await account.waitForTransaction(transaction_hash, {
  //         retryInterval: 100,
  //       }),
  //     );
  //   } catch (error) {
  //     console.error("Error transferring ownership:", error);
  //   }
  // };

  // const leave = async ({ account, ...props }: SystemTypes.Leave) => {
  //   try {
  //     const { transaction_hash } = await client.actions.leave({
  //       account,
  //       ...props,
  //     });

  //     notify(
  //       `Game has been left.`,
  //       await account.waitForTransaction(transaction_hash, {
  //         retryInterval: 100,
  //       }),
  //     );
  //   } catch (error) {
  //     console.error("Error leaving game:", error);
  //   }
  // };

  // const kick = async ({ account, ...props }: SystemTypes.Kick) => {
  //   try {
  //     const { transaction_hash } = await client.actions.kick({
  //       account,
  //       ...props,
  //     });

  //     notify(
  //       `Player has been kicked.`,
  //       await account.waitForTransaction(transaction_hash, {
  //         retryInterval: 100,
  //       }),
  //     );
  //   } catch (error) {
  //     console.error("Error kicking player:", error);
  //   }
  // };

  // const remove = async ({ account, ...props }: SystemTypes.Remove) => {
  //   try {
  //     const { transaction_hash } = await client.actions.remove({
  //       account,
  //       ...props,
  //     });

  //     notify(
  //       `Game has been deleted.`,
  //       await account.waitForTransaction(transaction_hash, {
  //         retryInterval: 100,
  //       }),
  //     );
  //   } catch (error) {
  //     console.error("Error deleting game:", error);
  //   }
  // };

  // const start = async ({ account, ...props }: SystemTypes.Start) => {
  //   try {
  //     const { transaction_hash } = await client.actions.start({
  //       account,
  //       ...props,
  //     });

  //     notify(
  //       `Game has started.`,
  //       await account.waitForTransaction(transaction_hash, {
  //         retryInterval: 100,
  //       }),
  //     );
  //   } catch (error) {
  //     console.error("Error starting game:", error);
  //   }
  // };

  const move = async ({ account, ...props }: SystemTypes.Move) => {
    try {
      const { transaction_hash } = await client.actions.move({
        account,
        ...props,
      });

      notify(
        `Player action confirmed.`,
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        }),
      );
    } catch (error: any) {
      toast.error(extractedMessage(error.message));
    }
  };

  const surrender = async ({ account, ...props }: SystemTypes.Surrender) => {
    try {
      const { transaction_hash } = await client.actions.surrender({
        account,
        ...props,
      });

      notify(
        `Player has surrendered.`,
        await account.waitForTransaction(transaction_hash, {
          retryInterval: 100,
        }),
      );
    } catch (error: any) {
      toast.error(extractedMessage(error.message));
    }
  };

  return {
    spawn,
    create,
    // join,
    // ready,
    // transfer,
    // leave,
    // kick,
    // remove,
    // start,
    move,
    surrender,
  };
}
