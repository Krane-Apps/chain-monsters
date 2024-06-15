import { ComponentValue } from "@dojoengine/recs";

export class Team {
  public game_id: number;
  public id: number;
  public player_id: string;

  constructor(team: ComponentValue) {
    this.game_id = team.game_id;
    this.id = team.id;
    this.player_id = `0x${team.player_id.toString(16)}`;
  }
}
