// Core imports

use core::zeroable::Zeroable;

// Internal imports

use chain_monsters::helpers::grid::Grid;
use chain_monsters::constants::{
    DEFAULT_HEALTH, DEFAULT_DAMAGE, DEFAULT_MANA, DEFAULT_MANA_GAIN, DEFAULT_MAX_MANA,
    DEFAULT_MIN_X, DEFAULT_MIN_Y, DEFAULT_MAX_X, DEFAULT_MAX_Y
};
use chain_monsters::models::index::{Monster, MonsterPosition};

mod errors {
    const MONSTER_NOT_EXISTS: felt252 = 'Monster: does not exist';
    const MONSTER_DOES_EXIST: felt252 = 'Monster: does exist';
    const MONSTER_INVALID_MOVE: felt252 = 'Monster: invalid move';
    const MONSTER_NOT_ALIVE: felt252 = 'Monster: not alive';
    const MONSTER_INVALID_TEAM: felt252 = 'Monster: invalid team';
    const MONSTER_ALREADY_DEAD: felt252 = 'Monster: already dead';
}

#[generate_trait]
impl MonsterImpl of MonsterTrait {
    #[inline(always)]
    fn new(game_id: u32, team_id: u8, id: u8) -> Monster {
        let (x, y) = Grid::position(team_id, id);
        Monster {
            game_id,
            team_id,
            id,
            health: DEFAULT_HEALTH,
            damage: DEFAULT_DAMAGE,
            mana: DEFAULT_MANA,
            x,
            y
        }
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
}

impl ZeroableMonster of Zeroable<Monster> {
    #[inline(always)]
    fn zero() -> Monster {
        Monster { game_id: 0, team_id: 0, id: 0, health: 0, damage: 0, mana: 0, x: 0, y: 0 }
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
