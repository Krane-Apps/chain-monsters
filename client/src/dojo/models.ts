import { Game } from "./game/models/game";
import { Player } from "./game/models/player";
import { Team } from "./game/models/team";
import { Monster } from "./game/models/monster";
import { ContractComponents } from "./generated/contractModels";
import { overridableComponent } from "@dojoengine/recs";

export type ClientModels = ReturnType<typeof models>;

export function models({
  contractModels,
}: {
  contractModels: ContractComponents;
}) {
  return {
    models: {
      ...contractModels,
    },
    classes: {
      Player,
      Game,
      Team,
      Monster,
    },
  };
}
