// Internal imports

use chain_monsters::elements::clans;

#[derive(Copy, Drop, Serde, Introspect)]
enum Clan {
    None,
    Goblin,
    Golem,
    Angel,
    Minotaur,
}

#[generate_trait]
impl ClanImpl of ClanTrait {
    #[inline(always)]
    fn damage(self: Clan, base: u8) -> u8 {
        match self {
            Clan::None => 0,
            Clan::Goblin => clans::goblin::ClanImpl::damage(base),
            Clan::Golem => clans::golem::ClanImpl::damage(base),
            Clan::Angel => clans::angel::ClanImpl::damage(base),
            Clan::Minotaur => clans::minotaur::ClanImpl::damage(base),
        }
    }

    #[inline(always)]
    fn defense(self: Clan, base: u8) -> u8 {
        match self {
            Clan::None => 0,
            Clan::Goblin => clans::goblin::ClanImpl::defense(base),
            Clan::Golem => clans::golem::ClanImpl::defense(base),
            Clan::Angel => clans::angel::ClanImpl::defense(base),
            Clan::Minotaur => clans::minotaur::ClanImpl::defense(base),
        }
    }

    #[inline(always)]
    fn health(self: Clan, base: u8) -> u8 {
        match self {
            Clan::None => 0,
            Clan::Goblin => clans::goblin::ClanImpl::health(base),
            Clan::Golem => clans::golem::ClanImpl::health(base),
            Clan::Angel => clans::angel::ClanImpl::health(base),
            Clan::Minotaur => clans::minotaur::ClanImpl::health(base),
        }
    }

    #[inline(always)]
    fn rate(self: Clan, base: u8) -> u8 {
        match self {
            Clan::None => 0,
            Clan::Goblin => clans::goblin::ClanImpl::rate(base),
            Clan::Golem => clans::golem::ClanImpl::rate(base),
            Clan::Angel => clans::angel::ClanImpl::rate(base),
            Clan::Minotaur => clans::minotaur::ClanImpl::rate(base),
        }
    }
}

impl IntoClanFelt252 of core::Into<Clan, felt252> {
    #[inline(always)]
    fn into(self: Clan) -> felt252 {
        match self {
            Clan::None => 'NONE',
            Clan::Goblin => 'GOBLIN',
            Clan::Golem => 'GOLEM',
            Clan::Angel => 'ANGEL',
            Clan::Minotaur => 'MINOTAUR',
        }
    }
}

impl IntoClanU8 of core::Into<Clan, u8> {
    #[inline(always)]
    fn into(self: Clan) -> u8 {
        match self {
            Clan::None => 0,
            Clan::Goblin => 1,
            Clan::Golem => 2,
            Clan::Angel => 3,
            Clan::Minotaur => 4,
        }
    }
}

impl IntoU8Clan of core::Into<u8, Clan> {
    #[inline(always)]
    fn into(self: u8) -> Clan {
        let card: felt252 = self.into();
        match card {
            0 => Clan::None,
            1 => Clan::Goblin,
            2 => Clan::Golem,
            3 => Clan::Angel,
            4 => Clan::Minotaur,
            _ => Clan::None,
        }
    }
}

impl ClanPrint of core::debug::PrintTrait<Clan> {
    #[inline(always)]
    fn print(self: Clan) {
        let felt: felt252 = self.into();
        felt.print();
    }
}
