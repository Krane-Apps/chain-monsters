// Internal imports

use chain_monsters::constants::{DEFAULT_MIN_X, DEFAULT_MIN_Y, DEFAULT_MAX_X, DEFAULT_MAX_Y};

#[generate_trait]
impl Grid of GridTrait {
    #[inline(always)]
    fn position(team_id: u8, monster_id: u8) -> (u8, u8) {
        match team_id {
            0 => (0, 0),
            1 => match monster_id {
                0 => (0, 0),
                1 => (DEFAULT_MIN_X + 1, DEFAULT_MAX_Y - 0),
                2 => (DEFAULT_MIN_X + 0, DEFAULT_MAX_Y - 1),
                3 => (DEFAULT_MIN_X + 1, DEFAULT_MAX_Y - 2),
                4 => (DEFAULT_MIN_X + 0, DEFAULT_MAX_Y - 3),
                _ => (0, 0),
            },
            2 => match monster_id {
                0 => (0, 0),
                1 => (DEFAULT_MAX_X - 1, DEFAULT_MIN_Y + 0),
                2 => (DEFAULT_MAX_X - 0, DEFAULT_MIN_Y + 1),
                3 => (DEFAULT_MAX_X - 1, DEFAULT_MIN_Y + 2),
                4 => (DEFAULT_MAX_X - 0, DEFAULT_MIN_Y + 3),
                _ => (0, 0),
            },
            _ => (0, 0),
        }
    }
}
