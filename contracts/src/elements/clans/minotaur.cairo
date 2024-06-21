// Core imports

use core::debug::PrintTrait;

// Internal imports

use chain_monsters::elements::clans::interface::ClanTrait;

impl ClanImpl of ClanTrait {
    #[inline(always)]
    fn damage(base: u8) -> u8 {
        base * 2
    }

    #[inline(always)]
    fn defense(base: u8) -> u8 {
        base
    }

    #[inline(always)]
    fn health(base: u8) -> u8 {
        base / 2
    }

    #[inline(always)]
    fn rate(base: u8) -> u8 {
        base
    }
}
