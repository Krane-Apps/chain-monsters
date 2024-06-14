import { ComponentValue } from "@dojoengine/recs";

export class Game {
  public id: number;
  public over: boolean;
  public players: number;
  public player_count: number;
  public nonce: number;
  public seed: string;
  public host: string;

  constructor(game: ComponentValue) {
    this.id = game.id;
    this.over = game.over;
    this.players = game.players;
    this.player_count = game.player_count;
    this.nonce = game.nonce;
    this.seed = game.seed;
    this.host = `0x${game.host.toString(16)}`;
  }
}
