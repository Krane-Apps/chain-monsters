import { ComponentValue } from "@dojoengine/recs";

export class Team {
  public game_id: number;
  public index: number;
  public id: string;

  constructor(team: ComponentValue) {
    this.game_id = team.game_id;
    this.index = team.index;
    this.id = `0x${team.id.toString(16)}`;
  }
}
