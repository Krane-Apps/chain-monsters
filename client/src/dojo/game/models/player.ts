import { ComponentValue } from "@dojoengine/recs";
import { shortString } from "starknet";

export class Player {
  public id: string;
  public game_id: number;
  public name: string;

  constructor(player: ComponentValue) {
    this.id = `0x${player.id.toString(16)}`;
    this.game_id = player.game_id;
    this.name = shortString.decodeShortString(`0x${player.name.toString(16)}`);
  }
}
