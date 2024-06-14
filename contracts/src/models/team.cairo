// Core imports

use core::zeroable::Zeroable;

// Internal imports

use chain_monsters::models::index::Team;

mod errors {
    const TEAM_NOT_EXISTS: felt252 = 'Team: does not exist';
    const TEAM_DOES_EXIST: felt252 = 'Team: does exist';
}

#[generate_trait]
impl TeamImpl of TeamTrait {
    #[inline(always)]
    fn new(game_id: u32, team_id: felt252, index: u8) -> Team {
        Team { game_id, index, id: team_id, }
    }

    #[inline(always)]
    fn nullify(ref self: Team) {
        self.id = 0;
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
}

impl ZeroableTeam of Zeroable<Team> {
    #[inline(always)]
    fn zero() -> Team {
        Team { game_id: 0, index: 0, id: 0, }
    }

    #[inline(always)]
    fn is_zero(self: Team) -> bool {
        self.id == 0
    }

    #[inline(always)]
    fn is_non_zero(self: Team) -> bool {
        !self.is_zero()
    }
}
