// Core imports

use core::debug::PrintTrait;

// Starknet imports

use starknet::testing::{set_contract_address, set_transaction_hash};

// Dojo imports

use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// Internal imports

use chain_monsters::constants;
use chain_monsters::store::{Store, StoreTrait};
use chain_monsters::models::game::{Game, GameTrait};
use chain_monsters::models::player::{Player, PlayerTrait};
use chain_monsters::models::team::{Team, TeamTrait};
use chain_monsters::models::monster::{Monster, MonsterTrait};
use chain_monsters::systems::actions::IActionsDispatcherTrait;

// Test imports

use chain_monsters::tests::setup::{setup, setup::{Systems, PLAYER}};

#[test]
fn test_actions_spawn() {
    // [Setup]
    let (world, _, context) = setup::spawn_game();
    let store = StoreTrait::new(world);

    // [Assert]
    let game = store.game(context.game_id);
    assert(game.id == context.game_id, 'Game: id');
    assert(game.player_count == 2, 'Game: player_count');
    assert(game.positions == 0x281428140, 'Game: positions');
}

#[test]
fn test_actions_move_attack() {
    // [Setup]
    let (world, systems, context) = setup::spawn_game();
    let store = StoreTrait::new(world);

    // [Moves]
    let game = store.game(context.game_id);
    let player = store.player(PLAYER().into());
    let team = store.find_team(game.id, player.id, game.player_count);
    let monster_id = 3;
    systems.actions.move(world, context.game_id, team.id, monster_id, 2, 2, false);
    systems.actions.move(world, context.game_id, team.id, monster_id, 3, 2, false);
    systems.actions.move(world, context.game_id, team.id, monster_id, 4, 2, false);

    // [Assert] Target
    let monster = store.monster(game.id, team.id, monster_id);
    assert(monster.x == 4, 'Monster: x');
    assert(monster.y == 2, 'Monster: y');
// // [Assert] Target
// let position = store.monster_position(game.id, 6, 2);
// let monster = store.monster(position.game_id, position.team_id, position.monster_id);
// assert(monster.health < constants::DEFAULT_HEALTH, 'Monster: health');
}

#[test]
#[should_panic(expected: ('Monster: invalid team', 'ENTRYPOINT_FAILED',))]
fn test_actions_move_revert_invalid_team() {
    // [Setup]
    let (world, systems, context) = setup::spawn_game();
    let store = StoreTrait::new(world);

    // [Moves]
    let game = store.game(context.game_id);
    let player = store.player(PLAYER().into());
    let team = store.find_team(game.id, player.id, game.player_count);
    let monster_id = 3;
    systems.actions.move(world, context.game_id, team.id, monster_id, 0, 2, false);
    systems.actions.move(world, context.game_id, team.id, monster_id, 0, 1, false);
}

