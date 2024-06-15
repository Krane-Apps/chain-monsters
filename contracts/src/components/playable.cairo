// Starknet imports

use starknet::ContractAddress;

// Component

#[starknet::component]
mod PlayableComponent {
    // Core imports

    use core::debug::PrintTrait;

    // Starknet imports

    use starknet::ContractAddress;
    use starknet::info::get_caller_address;

    // Dojo imports

    use dojo::world;
    use dojo::world::IWorldDispatcher;
    use dojo::world::IWorldDispatcherTrait;
    use dojo::world::IWorldProvider;
    use dojo::world::IDojoResourceProvider;

    // Internal imports

    use chain_monsters::constants;
    use chain_monsters::store::{Store, StoreTrait};
    use chain_monsters::models::game::{Game, GameTrait, GameAssert};
    use chain_monsters::models::player::{Player, PlayerTrait, PlayerAssert};
    use chain_monsters::models::team::{Team, TeamTrait, TeamAssert};
    use chain_monsters::models::monster::{Monster, MonsterTrait, MonsterAssert, ZeroableMonster};

    // Errors

    mod errors {
        const TEAM_NOT_FOUND: felt252 = 'Playable: team not found';
    }

    // Storage

    #[storage]
    struct Storage {}

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {}

    #[generate_trait]
    impl InternalImpl<
        TContractState, +HasComponent<TContractState>
    > of InternalTrait<TContractState> {
        fn _create(self: @ComponentState<TContractState>, world: IWorldDispatcher,) -> u32 {
            // [Setup] Datastore
            let store: Store = StoreTrait::new(world);

            // [Check] Player exists
            let caller = get_caller_address();
            let mut player = store.player(caller.into());
            player.assert_exists();

            // [Effect] Create a new Game
            let game_id = world.uuid() + 1;
            let mut game = GameTrait::new(id: game_id, host: player.id);
            player.game_id = game.id;

            // [Effect] Create a new Team and Monsters
            let team_id = game.join();
            let mut team = TeamTrait::new(game_id, team_id, player.id);
            let mut monster_id = constants::DEFAULT_MONSTER_COUNT;
            loop {
                if monster_id == 0 {
                    break;
                }
                let monster = MonsterTrait::new(game_id, team.id, monster_id);
                game.set_positions(monster.x, monster.y);
                store.set_monster(monster);
                monster_id -= 1;
            };
            game.ready(team.id, true);
            store.set_team(team);

            // [EFfect] Create the opponent Team and Monsters
            let team_id = game.join();
            let mut team = TeamTrait::new(game_id, team_id, 0);
            let mut monster_id = constants::DEFAULT_MONSTER_COUNT;
            loop {
                if monster_id == 0 {
                    break;
                }
                let monster = MonsterTrait::new(game_id, team.id, monster_id);
                game.set_positions(monster.x, monster.y);
                store.set_monster(monster);
                monster_id -= 1;
            };
            game.ready(team.id, true);
            store.set_team(team);

            // [Effect] Starts the game
            let mut teams = store.teams(game.id, game.player_count);
            game.start(ref teams);
            store.set_game(game);

            // [Effect] Update player
            store.set_player(player);

            // [Return] Game id
            game_id
        }

        fn _move(
            self: @ComponentState<TContractState>,
            world: IWorldDispatcher,
            game_id: u32,
            team_id: u8,
            monster_id: u8,
            x: u8,
            y: u8,
            special: bool
        ) {
            // [Setup] Datastore
            let store: Store = StoreTrait::new(world);

            // [Check] Player exists
            let caller = get_caller_address();
            let mut player = store.player(caller.into());
            player.assert_exists();

            // [Check] Game exists
            let mut game = store.game(game_id);
            game.assert_exists();

            // [Check] Game is not over
            game.assert_not_over();

            // [Check] Team exists and belongs to the player
            let team = store.team(game_id, team_id);
            team.assert_exists();

            // [Check] Monster exists and alive
            let mut monster = store.monster(game_id, team.id, monster_id);
            monster.assert_exists();
            monster.assert_is_alive();

            // [Effect] Perform the move
            if game.is_idle(x, y) {
                // [Effect] Move monster if spot is idle
                game.update_positions(monster.x, monster.y, x, y);
                monster.move(x, y);
            } else {
                // [Effect] Attack the target if spot is not idle
                let position = store.monster_position(game_id, x, y);
                let mut target = store
                    .monster(position.game_id, position.team_id, position.monster_id);
                monster.attack(ref target, special);
                // [Effect] Assess dead, remove from the grid
                if target.is_zero() {
                    game.unset_positions(target.x, target.y);
                }
                // [Effect] Update target
                store.set_monster(target);
            }

            // [Effect] Update monster
            store.set_monster(monster);

            // [Effect] Update game
            store.set_game(game);
        }
    }
}
