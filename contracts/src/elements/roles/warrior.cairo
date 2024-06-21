// Core imports

use core::debug::PrintTrait;

// Internal imports

use chain_monsters::elements::roles::interface::RoleTrait;

impl RoleImpl of RoleTrait {
    #[inline(always)]
    fn damage() -> u8 {
        20
    }

    #[inline(always)]
    fn defense() -> u8 {
        10
    }

    #[inline(always)]
    fn health() -> u8 {
        100
    }

    #[inline(always)]
    fn rate() -> u8 {
        1
    }
}
