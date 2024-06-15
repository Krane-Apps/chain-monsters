#[derive(Copy, Drop, Serde, IntrospectPacked)]
#[dojo::model]
struct Player {
    #[key]
    id: felt252,
    game_id: u32,
    name: felt252,
}

#[derive(Copy, Drop, Serde, IntrospectPacked)]
#[dojo::model]
struct Game {
    #[key]
    id: u32,
    over: bool,
    players: u8,
    player_count: u8,
    positions: u64,
    nonce: u16,
    seed: felt252,
    host: felt252,
}

#[derive(Copy, Drop, Serde, IntrospectPacked)]
#[dojo::model]
struct Team {
    #[key]
    game_id: u32,
    #[key]
    id: u8,
    player_id: felt252,
}

#[derive(Copy, Drop, Serde, IntrospectPacked)]
#[dojo::model]
struct Monster {
    #[key]
    game_id: u32,
    #[key]
    team_id: u8,
    #[key]
    id: u8,
    health: u8,
    damage: u8,
    mana: u8,
    x: u8,
    y: u8,
}

#[derive(Copy, Drop, Serde, IntrospectPacked)]
#[dojo::model]
struct MonsterPosition {
    #[key]
    game_id: u32,
    #[key]
    x: u8,
    #[key]
    y: u8,
    team_id: u8,
    monster_id: u8,
}
