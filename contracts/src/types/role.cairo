// Internal imports

use chain_monsters::elements::roles;

#[derive(Copy, Drop, Serde, Introspect)]
enum Role {
    None,
    Warrior,
    Assassin,
    Paladin,
}

#[generate_trait]
impl RoleImpl of RoleTrait {
    #[inline(always)]
    fn damage(self: Role) -> u8 {
        match self {
            Role::None => 0,
            Role::Warrior => roles::warrior::RoleImpl::damage(),
            Role::Assassin => roles::assassin::RoleImpl::damage(),
            Role::Paladin => roles::paladin::RoleImpl::damage(),
        }
    }

    #[inline(always)]
    fn defense(self: Role) -> u8 {
        match self {
            Role::None => 0,
            Role::Warrior => roles::warrior::RoleImpl::defense(),
            Role::Assassin => roles::assassin::RoleImpl::defense(),
            Role::Paladin => roles::paladin::RoleImpl::defense(),
        }
    }

    #[inline(always)]
    fn health(self: Role) -> u8 {
        match self {
            Role::None => 0,
            Role::Warrior => roles::warrior::RoleImpl::health(),
            Role::Assassin => roles::assassin::RoleImpl::health(),
            Role::Paladin => roles::paladin::RoleImpl::health(),
        }
    }

    #[inline(always)]
    fn rate(self: Role) -> u8 {
        match self {
            Role::None => 0,
            Role::Warrior => roles::warrior::RoleImpl::rate(),
            Role::Assassin => roles::assassin::RoleImpl::rate(),
            Role::Paladin => roles::paladin::RoleImpl::rate(),
        }
    }
}

impl IntoRoleFelt252 of core::Into<Role, felt252> {
    #[inline(always)]
    fn into(self: Role) -> felt252 {
        match self {
            Role::None => 'NONE',
            Role::Warrior => 'WARRIOR',
            Role::Assassin => 'ASSASSIN',
            Role::Paladin => 'PALADIN',
        }
    }
}

impl IntoRoleU8 of core::Into<Role, u8> {
    #[inline(always)]
    fn into(self: Role) -> u8 {
        match self {
            Role::None => 0,
            Role::Warrior => 1,
            Role::Assassin => 2,
            Role::Paladin => 3,
        }
    }
}

impl IntoU8Role of core::Into<u8, Role> {
    #[inline(always)]
    fn into(self: u8) -> Role {
        let card: felt252 = self.into();
        match card {
            0 => Role::None,
            1 => Role::Warrior,
            2 => Role::Assassin,
            3 => Role::Paladin,
            _ => Role::None,
        }
    }
}

impl RolePrint of core::debug::PrintTrait<Role> {
    #[inline(always)]
    fn print(self: Role) {
        let felt: felt252 = self.into();
        felt.print();
    }
}
