// Core imports

use core::debug::PrintTrait;

// Internal imports

use chain_monsters::elements::roles::interface::RoleTrait;

impl RoleImpl of RoleTrait {
    #[inline(always)]
    fn damage() -> u8 {
        10
    }

    #[inline(always)]
    fn defense() -> u8 {
        15
    }

    #[inline(always)]
    fn health() -> u8 {
        150
    }

    #[inline(always)]
    fn rate() -> u8 {
        1
    }
}
