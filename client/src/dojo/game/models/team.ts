import { ComponentValue } from "@dojoengine/recs";

export class Team {
  public game_id: number;
  public id: number;
  public alive_count: number;
  public player_id: string;

  constructor(team: ComponentValue) {
    this.game_id = team.game_id;
    this.id = team.id;
    this.alive_count = team.alive_count;
    this.player_id = `0x${team.player_id.toString(16)}`;
  }
}
