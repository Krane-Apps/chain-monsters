#[derive(Copy, Drop, Serde, IntrospectPacked)]
#[dojo::model]
struct Player {
    #[key]
    id: felt252,
    game_id: u32,
    achievements: u64,
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
    index: u8,
    id: felt252,
}
