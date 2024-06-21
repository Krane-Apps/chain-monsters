// Core imports

use core::debug::PrintTrait;

// Internal imports

use chain_monsters::elements::roles::interface::RoleTrait;

impl RoleImpl of RoleTrait {
    #[inline(always)]
    fn damage() -> u8 {
        30
    }

    #[inline(always)]
    fn defense() -> u8 {
        5
    }

    #[inline(always)]
    fn health() -> u8 {
        70
    }

    #[inline(always)]
    fn rate() -> u8 {
        1
    }
}
