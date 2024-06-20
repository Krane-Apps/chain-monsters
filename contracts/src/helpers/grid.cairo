// External imports

use alexandria_math::bitmap::Bitmap;

// Internal imports

use chain_monsters::constants::{DEFAULT_MIN_X, DEFAULT_MIN_Y, DEFAULT_MAX_X, DEFAULT_MAX_Y};

#[generate_trait]
impl Grid of GridTrait {
    #[inline(always)]
    fn min(a: u8, b: u8) -> u8 {
        if a < b {
            return a;
        };
        b
    }

    #[inline(always)]
    fn max(a: u8, b: u8) -> u8 {
        if a > b {
            return a;
        }
        b
    }

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

    #[inline(always)]
    fn squared_distance(from_x: u8, from_y: u8, to_x: u8, to_y: u8) -> u8 {
        let dx = if from_x > to_x {
            from_x - to_x
        } else {
            to_x - from_x
        };
        let dy = if from_y > to_y {
            from_y - to_y
        } else {
            to_y - from_y
        };
        dx * dx + dy * dy
    }

    fn next_position(from_x: u8, from_y: u8, to_x: u8, to_y: u8, positions: u64) -> (u8, u8) {
        // [Compute] All possible moves allowed in the grid by relevance
        let mut ways: Array<(u8, u8)> = array![];
        // [Compute] Coordinate differences
        let dx = if from_x > to_x {
            from_x - to_x
        } else {
            to_x - from_x
        };
        let dy = if from_y > to_y {
            from_y - to_y
        } else {
            to_y - from_y
        };
        // [Compute] Add possibilities, priority to the farest direction
        if dx > dy {
            if from_x < to_x {
                ways.append((from_x + 1, from_y));
            } else if from_x > to_x {
                ways.append((from_x - 1, from_y));
            } else {
                ways.append((from_x + 1, from_y));
                ways.append((from_x - 1, from_y));
            }
            if from_y < to_y {
                ways.append((from_x, from_y + 1));
            } else if from_y > to_y {
                ways.append((from_x, from_y - 1));
            } else {
                ways.append((from_x, from_y + 1));
                ways.append((from_x, from_y - 1));
            }
        } else {
            if from_y < to_y {
                ways.append((from_x, from_y + 1));
            } else if from_y > to_y {
                ways.append((from_x, from_y - 1));
            } else {
                ways.append((from_x, from_y + 1));
                ways.append((from_x, from_y - 1));
            }
            if from_x < to_x {
                ways.append((from_x + 1, from_y));
            } else if from_x > to_x {
                ways.append((from_x - 1, from_y));
            } else {
                ways.append((from_x + 1, from_y));
                ways.append((from_x - 1, from_y));
            }
        }

        // [Check] Check if the next position is not already taken by anything than the target
        let target_index = to_x + to_y * (DEFAULT_MAX_X + 1);
        loop {
            match ways.pop_front() {
                Option::Some((
                    x, y
                )) => {
                    let index = x + y * (DEFAULT_MAX_X + 1);
                    if !Bitmap::get_bit_at(positions, index) || index == target_index {
                        break (x, y);
                    }
                },
                Option::None => {
                    // [Check] Otherwise, don't move
                    break (from_x, from_y);
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::{Grid, DEFAULT_MIN_X, DEFAULT_MAX_X, DEFAULT_MIN_Y, DEFAULT_MAX_Y};

    #[test]
    fn test_grid_position() {
        assert_eq!(Grid::position(0, 0), (0, 0));
        assert_eq!(Grid::position(1, 0), (0, 0));
        assert_eq!(Grid::position(1, 1), (DEFAULT_MIN_X + 1, DEFAULT_MAX_Y - 0));
        assert_eq!(Grid::position(1, 2), (DEFAULT_MIN_X + 0, DEFAULT_MAX_Y - 1));
        assert_eq!(Grid::position(1, 3), (DEFAULT_MIN_X + 1, DEFAULT_MAX_Y - 2));
        assert_eq!(Grid::position(1, 4), (DEFAULT_MIN_X + 0, DEFAULT_MAX_Y - 3));
        assert_eq!(Grid::position(2, 0), (0, 0));
        assert_eq!(Grid::position(2, 1), (DEFAULT_MAX_X - 1, DEFAULT_MIN_Y + 0));
        assert_eq!(Grid::position(2, 2), (DEFAULT_MAX_X - 0, DEFAULT_MIN_Y + 1));
        assert_eq!(Grid::position(2, 3), (DEFAULT_MAX_X - 1, DEFAULT_MIN_Y + 2));
        assert_eq!(Grid::position(2, 4), (DEFAULT_MAX_X - 0, DEFAULT_MIN_Y + 3));
    }

    #[test]
    fn test_grid_squared_distance() {
        assert_eq!(Grid::squared_distance(0, 0, 0, 0), 0);
        assert_eq!(Grid::squared_distance(0, 0, 1, 1), 2);
        assert_eq!(Grid::squared_distance(0, 0, 2, 2), 8);
        assert_eq!(Grid::squared_distance(0, 0, 3, 3), 18);
        assert_eq!(Grid::squared_distance(0, 0, 4, 4), 32);
        assert_eq!(Grid::squared_distance(0, 0, 5, 5), 50);
        assert_eq!(Grid::squared_distance(0, 0, 6, 6), 72);
        assert_eq!(Grid::squared_distance(0, 0, 7, 7), 98);
        assert_eq!(Grid::squared_distance(0, 0, 8, 8), 128);
        assert_eq!(Grid::squared_distance(0, 0, 9, 9), 162);
        assert_eq!(Grid::squared_distance(0, 0, 10, 10), 200);
    }
}
