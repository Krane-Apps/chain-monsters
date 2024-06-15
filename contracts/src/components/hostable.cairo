// Starknet imports

use starknet::ContractAddress;

// Component

#[starknet::component]
mod HostableComponent {
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
            let team_id = game.join();
            store.set_game(game);

            // [Effect] Create a new Team
            let team = TeamTrait::new(game_id, team_id, player.id);
            store.set_team(team);

            // [Return] Game id
            game_id
        }

        fn _join(self: @ComponentState<TContractState>, world: IWorldDispatcher, game_id: u32,) {
            // [Setup] Datastore
            let store: Store = StoreTrait::new(world);

            // [Check] Player exists
            let caller = get_caller_address();
            let mut player = store.player(caller.into());
            player.assert_exists();

            // [Check] Game exists
            let mut game = store.game(game_id);
            game.assert_exists();

            // [Check] Game has not yet started
            game.assert_not_started();

            // [Check] Team not already exists
            match store.search_team(game_id, player.id, game.player_count) {
                Option::Some(team) => {
                    team.assert_not_exists();
                    return;
                },
                Option::None => {},
            };

            // [Effect] Join the game
            let team_id = game.join();
            store.set_game(game);

            // [Effect] Create a new player
            let team = TeamTrait::new(game_id, team_id, player.id);
            store.set_team(team);
        }

        fn _ready(
            self: @ComponentState<TContractState>,
            world: IWorldDispatcher,
            game_id: u32,
            status: bool
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

            // [Check] Game has not yet started
            game.assert_not_started();

            // [Check] Team exists
            let team = store.find_team(game_id, player.id, game.player_count);
            team.assert_exists();

            // [Effect] Update the team readiness
            game.ready(team.id, status);
            store.set_game(game);
        }

        fn _transfer(
            self: @ComponentState<TContractState>,
            world: IWorldDispatcher,
            game_id: u32,
            team_index: u8
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

            // [Check] Team host exists
            let host = store.find_team(game_id, player.id, game.player_count);
            host.assert_exists();

            // [Check] Team exists
            let team = store.team(game_id, team_index);
            team.assert_exists();

            // [Check] Game has not yet started
            game.assert_not_started();

            // [Check] Team becomes the host
            game.assert_is_host(host.player_id);
            game.transfer(team.player_id);

            // [Effect] Store game
            store.set_game(game);
        }

        fn _leave(self: @ComponentState<TContractState>, world: IWorldDispatcher, game_id: u32) {
            // [Setup] Datastore
            let store: Store = StoreTrait::new(world);

            // [Check] Player exists
            let caller = get_caller_address();
            let mut player = store.player(caller.into());
            player.assert_exists();

            // [Check] Game exists
            let mut game = store.game(game_id);
            game.assert_exists();

            // [Check] Team exists
            let mut team = store.find_team(game_id, player.id, game.player_count);
            team.assert_exists();

            // [Check] Game has not yet started
            game.assert_not_started();

            // [Effect] Delete team
            let team_id = team.player_id;
            store.remove_team(game, ref team);

            // [Effect] Leave the game
            game.leave(team_id);
            store.set_game(game);
        }

        fn _kick(
            self: @ComponentState<TContractState>,
            world: IWorldDispatcher,
            game_id: u32,
            team_index: u8
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

            // [Check] Team exists
            let host = store.find_team(game_id, player.id, game.player_count);
            host.assert_exists();

            // [Check] Team is the host
            game.assert_is_host(host.player_id);

            // [Check] Game has not yet started
            game.assert_not_started();

            // [Check] Team exists
            let mut team = store.team(game_id, team_index);
            team.assert_exists();

            // [Effect] Delete team
            let team_id = team.player_id;
            store.remove_team(game, ref team);

            // [Effect] Leave the game
            game.leave(team_id);
            store.set_game(game);
        }

        fn _delete(self: @ComponentState<TContractState>, world: IWorldDispatcher, game_id: u32) {
            // [Setup] Datastore
            let store: Store = StoreTrait::new(world);

            // [Check] Player exists
            let caller = get_caller_address();
            let mut player = store.player(caller.into());
            player.assert_exists();

            // [Check] Game exists
            let mut game = store.game(game_id);
            game.assert_exists();

            // [Check] Team exists=
            let mut team = store.find_team(game_id, player.id, game.player_count);
            team.assert_exists();

            // [Effect] Remove team
            let team_id = team.player_id;
            store.remove_team(game, ref team);

            // [Effect] Delete the game
            game.delete(team_id);
            store.set_game(game);
        }

        fn _start(self: @ComponentState<TContractState>, world: IWorldDispatcher, game_id: u32) {
            // [Setup] Datastore
            let store: Store = StoreTrait::new(world);

            // [Check] Player exists
            let caller = get_caller_address();
            let mut player = store.player(caller.into());
            player.assert_exists();

            // [Check] Game exists
            let mut game = store.game(game_id);
            game.assert_exists();

            // [Check] Team exists
            let team = store.find_team(game_id, player.id, game.player_count);
            team.assert_exists();

            // [Check] Player is host
            game.assert_is_host(team.player_id);

            // [Effect] Starts the game
            let mut teams = store.teams(game.id, game.player_count);
            game.start(ref teams);

            // [Effect] Update game
            game.reset();
            store.set_game(game);
        }
    }
}
