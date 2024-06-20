// Core imports

use core::zeroable::Zeroable;

// External imports

use alexandria_math::bitmap::Bitmap;

// Internal imports

use chain_monsters::constants::DEFAULT_MAX_Y;
use chain_monsters::models::index::Team;

mod errors {
    const TEAM_NOT_EXISTS: felt252 = 'Team: does not exist';
    const TEAM_DOES_EXIST: felt252 = 'Team: does exist';
    const TEAM_NOT_OWNER: felt252 = 'Team: not owner';
}

#[generate_trait]
impl TeamImpl of TeamTrait {
    #[inline(always)]
    fn new(game_id: u32, id: u8, alive_count: u8, player_id: felt252) -> Team {
        Team { game_id, id, alive_count, player_id, }
    }

    #[inline(always)]
    fn nullify(ref self: Team) {
        self.player_id = 0;
    }
}

#[generate_trait]
impl AssertImpl of TeamAssert {
    #[inline(always)]
    fn assert_exists(self: Team) {
        assert(self.is_non_zero(), errors::TEAM_NOT_EXISTS);
    }

    #[inline(always)]
    fn assert_not_exists(self: Team) {
        assert(self.is_zero(), errors::TEAM_DOES_EXIST);
    }

    #[inline(always)]
    fn assert_is_owner(self: Team, player_id: felt252) {
        assert(self.player_id == player_id, errors::TEAM_NOT_OWNER);
    }
}

impl ZeroableTeam of Zeroable<Team> {
    #[inline(always)]
    fn zero() -> Team {
        Team { game_id: 0, id: 0, alive_count: 0, player_id: 0, }
    }

    #[inline(always)]
    fn is_zero(self: Team) -> bool {
        self.player_id == 0
    }

    #[inline(always)]
    fn is_non_zero(self: Team) -> bool {
        !self.is_zero()
    }
}
