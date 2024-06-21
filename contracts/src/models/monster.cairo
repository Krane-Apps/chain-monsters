// Core imports

use core::debug::PrintTrait;
use core::zeroable::Zeroable;

// Internal imports

use chain_monsters::helpers::grid::Grid;
use chain_monsters::constants::{
    DEFAULT_HEALTH, DEFAULT_DAMAGE, DEFAULT_MANA, DEFAULT_MANA_GAIN, DEFAULT_MAX_MANA,
    DEFAULT_MIN_X, DEFAULT_MIN_Y, DEFAULT_MAX_X, DEFAULT_MAX_Y
};
use chain_monsters::models::index::{Monster, MonsterPosition};
use chain_monsters::types::role::Role;
use chain_monsters::types::clan::Clan;

mod errors {
    const MONSTER_NOT_EXISTS: felt252 = 'Monster: does not exist';
    const MONSTER_DOES_EXIST: felt252 = 'Monster: does exist';
    const MONSTER_INVALID_MOVE: felt252 = 'Monster: invalid move';
    const MONSTER_NOT_ALIVE: felt252 = 'Monster: not alive';
    const MONSTER_INVALID_TEAM: felt252 = 'Monster: invalid team';
    const MONSTER_ALREADY_DEAD: felt252 = 'Monster: already dead';
    const MONSTER_NOT_ENOUGH_MANA: felt252 = 'Monster: not enough mana';
    const MONSTER_INVALID_ROLE: felt252 = 'Monster: invalid role';
    const MONSTER_INVALID_CLAN: felt252 = 'Monster: invalid clan';
}

#[generate_trait]
impl MonsterImpl of MonsterTrait {
    #[inline(always)]
    fn new(game_id: u32, team_id: u8, id: u8, role: u8, clan: u8) -> Monster {
        // [Check] Parameters are valid
        assert(role != Role::None.into(), errors::MONSTER_INVALID_ROLE);
        assert(clan != Clan::None.into(), errors::MONSTER_INVALID_CLAN);
        // [Effect] Create monster
        let (x, y) = Grid::position(team_id, id);
        Monster {
            game_id,
            team_id,
            id,
            role,
            clan,
            health: DEFAULT_HEALTH,
            damage: DEFAULT_DAMAGE,
            mana: DEFAULT_MANA,
            x,
            y,
            last_x: x,
            last_y: y,
        }
    }

    #[inline(always)]
    fn is_full(self: Monster) -> bool {
        self.mana == DEFAULT_MAX_MANA
    }

    #[inline(always)]
    fn move(ref self: Monster, x: u8, y: u8) {
        // [Check] Move is valid
        self.assert_is_valid(x, y);
        // [Effect] Update monster position
        self.x = x;
        self.y = y;
    }

    #[inline(always)]
    fn attack(ref self: Monster, ref target: Monster, special: bool) {
        // [Check] Target is attackable
        self.asset_is_attackable(target);
        // [Effect] Attack target
        let damage = if special {
            self.assert_is_full();
            self.mana = 0;
            self.damage * 2
        } else {
            self.increase_mana();
            self.damage
        };
        target.take_damage(damage);
    }

    #[inline(always)]
    fn take_damage(ref self: Monster, damage: u8) {
        if damage > self.health {
            self.health = 0;
        } else {
            self.health -= damage;
        };
    }

    #[inline(always)]
    fn increase_mana(ref self: Monster) {
        if self.mana + DEFAULT_MANA_GAIN > DEFAULT_MAX_MANA {
            self.mana = DEFAULT_MAX_MANA;
        } else {
            self.mana += DEFAULT_MANA_GAIN;
        }
    }

    fn closest(self: Monster, ref targets: Span<Monster>) -> Monster {
        let mut closest = *targets.pop_front().unwrap();
        let mut min_distance = Grid::squared_distance(self.x, self.y, closest.x, closest.y);
        loop {
            match targets.pop_front() {
                Option::Some(target) => {
                    let distance = Grid::squared_distance(self.x, self.y, *target.x, *target.y);
                    if distance < min_distance {
                        min_distance = distance;
                        closest = *target;
                    }
                },
                Option::None => { break closest; },
            };
        }
    }

    fn next(self: Monster, target: Monster, positions: u64) -> (u8, u8) {
        Grid::next_position(self.x, self.y, target.x, target.y, positions)
    }
}

#[generate_trait]
impl AssertImpl of MonsterAssert {
    #[inline(always)]
    fn assert_exists(self: Monster) {
        assert(self.is_non_zero(), errors::MONSTER_NOT_EXISTS);
    }

    #[inline(always)]
    fn assert_not_exists(self: Monster) {
        assert(self.is_zero(), errors::MONSTER_DOES_EXIST);
    }

    #[inline(always)]
    fn assert_is_valid(self: Monster, x: u8, y: u8) {
        let bounds = x >= DEFAULT_MIN_X
            && x <= DEFAULT_MAX_X
            && y >= DEFAULT_MIN_Y
            && y <= DEFAULT_MAX_Y;
        let dy = self.x == x && (self.y + 1 == y || self.y == y + 1);
        let dx = self.y == y && (self.x + 1 == x || self.x == x + 1);
        assert(bounds && (dy || dx), errors::MONSTER_INVALID_MOVE);
    }

    #[inline(always)]
    fn assert_is_alive(self: Monster) {
        assert(self.health != 0, errors::MONSTER_NOT_ALIVE);
    }

    #[inline(always)]
    fn asset_is_attackable(self: Monster, target: Monster) {
        assert(self.team_id != target.team_id, errors::MONSTER_INVALID_TEAM);
        assert(target.health != 0, errors::MONSTER_ALREADY_DEAD);
    }

    #[inline(always)]
    fn assert_is_full(self: Monster) {
        assert(self.is_full(), errors::MONSTER_NOT_ENOUGH_MANA);
    }
}

impl ZeroableMonster of Zeroable<Monster> {
    #[inline(always)]
    fn zero() -> Monster {
        Monster {
            game_id: 0,
            team_id: 0,
            id: 0,
            role: 0,
            clan: 0,
            health: 0,
            damage: 0,
            mana: 0,
            x: 0,
            y: 0,
            last_x: 0,
            last_y: 0
        }
    }

    #[inline(always)]
    fn is_zero(self: Monster) -> bool {
        self.health == 0
    }

    #[inline(always)]
    fn is_non_zero(self: Monster) -> bool {
        !self.is_zero()
    }
}

impl MonsterIntoPosition of Into<Monster, MonsterPosition> {
    #[inline(always)]
    fn into(self: Monster) -> MonsterPosition {
        MonsterPosition {
            game_id: self.game_id, x: self.x, y: self.y, team_id: self.team_id, monster_id: self.id
        }
    }
}
