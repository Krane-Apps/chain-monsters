import { ComponentValue } from "@dojoengine/recs";
import { shortString } from "starknet";

export class Player {
  public id: string;
  public name: string;

  constructor(player: ComponentValue) {
    this.id = `0x${player.id.toString(16)}`;
    this.name = shortString.decodeShortString(`0x${player.name.toString(16)}`);
  }
}
