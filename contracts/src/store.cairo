//! Store struct and component management methods.

// Core imports

use core::debug::PrintTrait;

// Straknet imports

use starknet::ContractAddress;

// Dojo imports

use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// Models imports

use chain_monsters::models::game::{Game, GameTrait};
use chain_monsters::models::player::{Player, PlayerTrait};
use chain_monsters::models::team::{Team, TeamTrait};

// Errors

mod errors {
    const STORE_TEAM_NOT_FOUND: felt252 = 'Store: team not found';
}

/// Store struct.
#[derive(Copy, Drop)]
struct Store {
    world: IWorldDispatcher,
}

/// Implementation of the `StoreTrait` trait for the `Store` struct.
#[generate_trait]
impl StoreImpl of StoreTrait {
    #[inline(always)]
    fn new(world: IWorldDispatcher) -> Store {
        Store { world: world }
    }

    #[inline(always)]
    fn player(self: Store, player_id: felt252) -> Player {
        get!(self.world, player_id, (Player))
    }

    #[inline(always)]
    fn game(self: Store, game_id: u32) -> Game {
        get!(self.world, game_id, (Game))
    }

    #[inline(always)]
    fn team(self: Store, game_id: u32, team_index: u8) -> Team {
        get!(self.world, (game_id, team_index), (Team))
    }

    fn search_team(self: Store, game_id: u32, team_id: felt252, mut index: u8) -> Option<Team> {
        loop {
            if index == 0 {
                break Option::None;
            }
            let team = self.team(game_id, index);
            if team.id == team_id {
                break Option::Some(team);
            }
            index -= 1;
        }
    }

    #[inline(always)]
    fn find_team(self: Store, game_id: u32, team_id: felt252, mut index: u8) -> Team {
        let team = self.search_team(game_id, team_id, index);
        team.expect(errors::STORE_TEAM_NOT_FOUND)
    }

    fn teams(self: Store, game_id: u32, team_count: u8) -> Array<felt252> {
        let mut teams: Array<felt252> = array![];
        let mut index = team_count;
        loop {
            if index == 0 {
                break;
            }
            let team = self.team(game_id, index);
            teams.append(team.id);
            index -= 1;
        };
        teams
    }

    #[inline(always)]
    fn set_player(self: Store, player: Player) {
        set!(self.world, (player))
    }

    #[inline(always)]
    fn set_game(self: Store, game: Game) {
        set!(self.world, (game))
    }

    #[inline(always)]
    fn set_team(self: Store, team: Team) {
        set!(self.world, (team))
    }

    #[inline(always)]
    fn remove_team(self: Store, game: Game, ref team: Team) {
        team.nullify();
        self.set_team(team);
        // Skip if the last builder is removed
        let last_index = game.player_count;
        if team.index == last_index {
            return;
        }
        let mut last_team = self.team(game.id, last_index);
        last_team.index = team.index;
        self.set_team(last_team);
        self.set_team(team);
    }
}
