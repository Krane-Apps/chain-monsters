import { ComponentValue } from "@dojoengine/recs";

export class Monster {
  public game_id: number;
  public team_id: number;
  public id: number;
  public health: number;
  public damage: number;
  public mana: number;
  public x: number;
  public y: number;

  constructor(monster: ComponentValue) {
    this.game_id = monster.game_id;
    this.team_id = monster.team_id;
    this.id = monster.id;
    this.health = monster.health;
    this.damage = monster.damage;
    this.mana = monster.mana;
    this.x = monster.x;
    this.y = monster.y;
  }
}
