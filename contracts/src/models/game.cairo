// Core imports

use core::Zeroable;
use core::hash::HashStateTrait;
use core::poseidon::{PoseidonTrait, HashState};

// External imports

use alexandria_math::bitmap::Bitmap;
use origami::random::dice::{Dice, DiceTrait};

// Internal imports

use chain_monsters::models::index::Game;

// Constants

const DEFAULT_PLAYER_COUNT: u8 = 2;

mod errors {
    const GAME_NOT_HOST: felt252 = 'Game: user is not the host';
    const GAME_IS_HOST: felt252 = 'Game: user is the host';
    const GAME_TOO_MANY_PLAYERS: felt252 = 'Game: too many players';
    const GAME_TOO_FEW_PLAYERS: felt252 = 'Game: too few players';
    const GAME_IS_FULL: felt252 = 'Game: is full';
    const GAME_NOT_FULL: felt252 = 'Game: not full';
    const GAME_IS_EMPTY: felt252 = 'Game: is empty';
    const GAME_NOT_ONLY_ONE: felt252 = 'Game: not only one';
    const GAME_IS_OVER: felt252 = 'Game: is over';
    const GAME_NOT_OVER: felt252 = 'Game: not over';
    const GAME_NOT_STARTED: felt252 = 'Game: not started';
    const GAME_HAS_STARTED: felt252 = 'Game: has started';
    const GAME_NOT_EXISTS: felt252 = 'Game: does not exist';
    const GAME_DOES_EXIST: felt252 = 'Game: does exist';
    const GAME_INVALID_HOST: felt252 = 'Game: invalid host';
    const GAME_PLAYER_ALREADY_PLAYED: felt252 = 'Game: player already played';
    const GAME_PLAYERS_NOT_READY: felt252 = 'Game: players not ready';
    const GAME_PLAYER_ALREADY_DONE: felt252 = 'Game: player already done';
}

#[generate_trait]
impl GameImpl of GameTrait {
    #[inline(always)]
    fn new(id: u32, host: felt252) -> Game {
        // [Check] Host is valid
        assert(host != 0, errors::GAME_INVALID_HOST);

        // [Return] Default game
        Game { id, over: false, players: 0, player_count: 0, nonce: 0, seed: 0, host, }
    }

    #[inline(always)]
    fn readiness(self: Game) -> bool {
        let readiness = Bitmap::set_bit_at(0, self.player_count, true) - 1;
        self.players == readiness
    }

    #[inline(always)]
    fn is_ready(self: Game, player_index: u8) -> bool {
        Bitmap::get_bit_at(self.players, player_index - 1)
    }

    #[inline(always)]
    fn reseed(ref self: Game) {
        let state: HashState = PoseidonTrait::new();
        let state = state.update(self.seed);
        let state = state.update(self.nonce.into());
        self.seed = state.finalize();
    }

    #[inline(always)]
    fn join(ref self: Game) -> u8 {
        self.assert_exists();
        self.assert_not_over();
        self.assert_not_started();
        self.assert_not_full();
        self.player_count += 1;
        self.player_count
    }

    #[inline(always)]
    fn leave(ref self: Game, team_id: felt252) {
        self.assert_exists();
        self.assert_not_over();
        self.assert_not_started();
        self.assert_not_empty();
        self.assert_not_host(team_id);
        self.player_count -= 1;
    }

    #[inline(always)]
    fn reset(ref self: Game) {
        self.players = 0;
    }

    #[inline(always)]
    fn ready(ref self: Game, player_index: u8, status: bool) {
        self.players = Bitmap::set_bit_at(self.players, player_index - 1, status);
    }

    #[inline(always)]
    fn kick(ref self: Game, team_id: felt252) -> u32 {
        self.assert_exists();
        self.assert_not_over();
        self.assert_not_started();
        self.assert_not_empty();
        self.assert_not_host(team_id);
        self.player_count -= 1;
        self.player_count.into()
    }

    #[inline(always)]
    fn delete(ref self: Game, team_id: felt252) -> u32 {
        self.assert_exists();
        self.assert_not_over();
        self.assert_not_started();
        self.assert_only_one();
        self.assert_is_host(team_id);
        self.nullify();
        self.player_count.into()
    }

    #[inline(always)]
    fn transfer(ref self: Game, host: felt252) {
        assert(host != 0, errors::GAME_INVALID_HOST);
        self.assert_not_host(host);
        self.host = host;
    }

    fn start(ref self: Game, ref teams: Array<felt252>) {
        // [Check] Game is valid
        self.assert_exists();
        self.assert_not_over();
        self.assert_not_started();
        self.assert_can_start();

        // [Effect] Compute seed
        let mut state = PoseidonTrait::new();
        state = state.update(self.id.into());
        loop {
            match teams.pop_front() {
                Option::Some(team) => { state = state.update(team); },
                Option::None => { break; },
            };
        };
        self.seed = state.finalize();
    }

    #[inline(always)]
    fn increment(ref self: Game) {
        // [Check] Game is not over
        if self.over {
            return;
        }
        // [Effect] Increment the nonce
        self.nonce += 1;
    }

    #[inline(always)]
    fn nullify(ref self: Game) {
        self.host = 0;
        self.over = false;
        self.seed = 0;
        self.player_count = 0;
        self.nonce = 0;
    }
}

#[generate_trait]
impl AssertImpl of GameAssert {
    #[inline(always)]
    fn assert_is_host(self: Game, team_id: felt252) {
        assert(self.host == team_id, errors::GAME_NOT_HOST);
    }

    #[inline(always)]
    fn assert_not_host(self: Game, team_id: felt252) {
        assert(self.host != team_id, errors::GAME_IS_HOST);
    }

    #[inline(always)]
    fn assert_is_over(self: Game) {
        assert(self.over, errors::GAME_NOT_OVER);
    }

    #[inline(always)]
    fn assert_not_over(self: Game) {
        assert(!self.over, errors::GAME_IS_OVER);
    }

    #[inline(always)]
    fn assert_has_started(self: Game) {
        assert(self.seed != 0, errors::GAME_NOT_STARTED);
    }

    #[inline(always)]
    fn assert_not_started(self: Game) {
        assert(self.seed == 0, errors::GAME_HAS_STARTED);
    }

    #[inline(always)]
    fn assert_exists(self: Game) {
        assert(self.is_non_zero(), errors::GAME_NOT_EXISTS);
    }

    #[inline(always)]
    fn assert_not_exists(self: Game) {
        assert(self.is_zero(), errors::GAME_DOES_EXIST);
    }

    #[inline(always)]
    fn assert_is_full(self: Game) {
        assert(DEFAULT_PLAYER_COUNT == self.player_count.into(), errors::GAME_NOT_FULL);
    }

    #[inline(always)]
    fn assert_not_full(self: Game) {
        assert(DEFAULT_PLAYER_COUNT != self.player_count.into(), errors::GAME_IS_FULL);
    }

    #[inline(always)]
    fn assert_not_empty(self: Game) {
        assert(0 != self.player_count.into(), errors::GAME_IS_EMPTY);
    }

    #[inline(always)]
    fn assert_only_one(self: Game) {
        assert(1 == self.player_count.into(), errors::GAME_NOT_ONLY_ONE);
    }

    #[inline(always)]
    fn assert_not_done(self: Game, player_index: u8) {
        assert(
            !Bitmap::get_bit_at(self.players, player_index - 1), errors::GAME_PLAYER_ALREADY_DONE
        );
    }

    #[inline(always)]
    fn assert_not_played(self: Game, player_index: u8) {
        assert(!self.is_ready(player_index), errors::GAME_PLAYER_ALREADY_PLAYED);
    }

    #[inline(always)]
    fn assert_can_start(self: Game) {
        assert(self.player_count == DEFAULT_PLAYER_COUNT, errors::GAME_TOO_FEW_PLAYERS);
        assert(self.readiness(), errors::GAME_PLAYERS_NOT_READY);
    }
}

impl ZeroableGame of core::Zeroable<Game> {
    #[inline(always)]
    fn zero() -> Game {
        Game { id: 0, over: false, players: 0, player_count: 0, nonce: 0, seed: 0, host: 0, }
    }

    #[inline(always)]
    fn is_zero(self: Game) -> bool {
        0 == self.host
    }

    #[inline(always)]
    fn is_non_zero(self: Game) -> bool {
        !self.is_zero()
    }
}

#[cfg(test)]
mod tests {
    // Core imports

    use core::debug::PrintTrait;

    // Local imports

    use super::{Game, GameTrait, ZeroableGame, DEFAULT_PLAYER_COUNT};

    // Constants

    const ID: u32 = 0;
    const PRICE: u256 = 1_000_000_000_000_000_000;
    const PENALTY: u64 = 60;
    const SEED: felt252 = 'SEED';
    const PLAYER_COUNT: u8 = 2;
    const HOST: felt252 = 'HOST';
    const PLAYER: felt252 = 'PLAYER';
    const TIME: u64 = 1337;
    const ROUND_COUNT: u32 = 100;

    #[test]
    #[available_gas(100_000)]
    fn test_game_new() {
        let game = GameTrait::new(ID, HOST);
        assert(game.host == HOST, 'Game: wrong account');
        assert(game.id == ID, 'Game: wrong id');
        assert(game.over == false, 'Game: wrong over');
        assert(game.seed == 0, 'Game: wrong seed');
        assert(game.player_count == 0, 'Game: wrong player_count');
        assert(game.nonce == 0, 'Game: wrong nonce');
    }

    #[test]
    #[available_gas(100_000)]
    fn test_game_join() {
        let mut game = GameTrait::new(ID, HOST);
        game.join();
        game.join();
        assert(game.player_count == 2, 'Game: wrong count');
    }

    #[test]
    #[available_gas(100_000)]
    #[should_panic(expected: ('Game: does not exist',))]
    fn test_game_join_revert_does_not_exist() {
        let mut game: Game = core::Zeroable::zero();
        game.join();
    }

    #[test]
    #[available_gas(100_000)]
    #[should_panic(expected: ('Game: is over',))]
    fn test_game_join_revert_is_over() {
        let mut game = GameTrait::new(ID, HOST);
        game.over = true;
        game.join();
    }

    #[test]
    #[available_gas(100_000)]
    #[should_panic(expected: ('Game: has started',))]
    fn test_game_join_revert_has_started() {
        let mut game = GameTrait::new(ID, HOST);
        game.seed = 1;
        game.join();
    }

    #[test]
    #[available_gas(150_000)]
    #[should_panic(expected: ('Game: is full',))]
    fn test_game_join_revert_no_remaining_slots() {
        let mut game = GameTrait::new(ID, HOST);
        let mut index = DEFAULT_PLAYER_COUNT + 1;
        loop {
            if index == 0 {
                break;
            }
            index -= 1;
            game.join();
        }
    }

    #[test]
    #[available_gas(100_000)]
    fn test_game_leave() {
        let mut game = GameTrait::new(ID, HOST);
        game.join();
        game.leave(PLAYER);
        assert(game.player_count == 0, 'Game: wrong count');
    }

    #[test]
    #[available_gas(100_000)]
    #[should_panic(expected: ('Game: user is the host',))]
    fn test_game_leave_host_revert_host() {
        let mut game = GameTrait::new(ID, HOST);
        game.join();
        game.leave(HOST);
        assert(game.over, 'Game: wrong status');
    }

    #[test]
    #[available_gas(100_000)]
    #[should_panic(expected: ('Game: is empty',))]
    fn test_game_leave_revert_does_not_exist() {
        let mut game = GameTrait::new(ID, HOST);
        game.join();
        game.player_count = 0;
        game.leave(PLAYER);
    }

    #[test]
    #[available_gas(100_000)]
    #[should_panic(expected: ('Game: is over',))]
    fn test_game_leave_revert_over() {
        let mut game = GameTrait::new(ID, HOST);
        game.join();
        game.over = true;
        game.leave(PLAYER);
    }

    #[test]
    #[available_gas(100_000)]
    #[should_panic(expected: ('Game: has started',))]
    fn test_game_leave_revert_has_started() {
        let mut game = GameTrait::new(ID, HOST);
        game.seed = 1;
        game.join();
        game.leave(PLAYER);
    }

    #[test]
    #[available_gas(100_000)]
    #[should_panic(expected: ('Game: is empty',))]
    fn test_game_leave_revert_is_empty() {
        let mut game = GameTrait::new(ID, HOST);
        game.join();
        game.leave(PLAYER);
        game.leave(PLAYER);
    }

    #[test]
    #[available_gas(200_000)]
    fn test_game_delete_host() {
        let mut game = GameTrait::new(ID, HOST);
        game.join();
        game.delete(HOST);
        assert(game.is_zero(), 'Game: not zero');
    }

    #[test]
    fn test_game_start() {
        let mut game = GameTrait::new(ID, HOST);
        let mut index = PLAYER_COUNT;
        loop {
            if index == 0 {
                break;
            }
            game.join();
            game.ready(index, true);
            index -= 1;
        };
        let mut teams = array![HOST, PLAYER];
        game.start(ref teams);
        assert(game.seed != 0, 'Game: wrong seed');
    }

    #[test]
    #[available_gas(200_000)]
    #[should_panic(expected: ('Game: too few players',))]
    fn test_game_start_revert_too_few_players() {
        let mut game = GameTrait::new(ID, HOST);
        game.player_count = 0;
        let mut players = array![HOST, PLAYER];
        game.start(ref players);
    }

    #[test]
    #[available_gas(200_000)]
    #[should_panic(expected: ('Game: is over',))]
    fn test_game_start_revert_is_over() {
        let mut game = GameTrait::new(ID, HOST);
        game.over = true;
        let mut players = array![HOST, PLAYER];
        game.start(ref players);
    }

    #[test]
    #[available_gas(200_000)]
    #[should_panic(expected: ('Game: has started',))]
    fn test_game_start_revert_has_started() {
        let mut game = GameTrait::new(ID, HOST);
        game.seed = 1;
        let mut players = array![HOST, PLAYER];
        game.start(ref players);
    }
}
