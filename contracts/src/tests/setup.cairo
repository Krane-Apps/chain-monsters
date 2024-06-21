mod setup {
    // Core imports

    use core::debug::PrintTrait;

    // Starknet imports

    use starknet::ContractAddress;
    use starknet::testing::{set_contract_address, set_caller_address};

    // Dojo imports

    use dojo::world::{IWorldDispatcherTrait, IWorldDispatcher};
    use dojo::test_utils::{spawn_test_world, deploy_contract};

    // Internal imports

    use chain_monsters::models::game::{Game, GameImpl};
    use chain_monsters::models::player::Player;
    use chain_monsters::models::team::Team;
    use chain_monsters::models::monster::{Monster, MonsterPosition};
    use chain_monsters::systems::actions::{
        actions, IActions, IActionsDispatcher, IActionsDispatcherTrait
    };

    // Constants

    fn PLAYER() -> ContractAddress {
        starknet::contract_address_const::<'PLAYER'>()
    }

    const PLAYER_NAME: felt252 = 'PLAYER';

    #[derive(Drop)]
    struct Systems {
        actions: IActionsDispatcher,
    }

    #[derive(Drop)]
    struct Context {
        player_id: felt252,
        player_name: felt252,
        game_id: u32,
    }

    #[inline(always)]
    fn spawn_game() -> (IWorldDispatcher, Systems, Context) {
        // [Setup] World
        let mut models = core::array::ArrayTrait::new();
        models.append(chain_monsters::models::index::game::TEST_CLASS_HASH);
        models.append(chain_monsters::models::index::player::TEST_CLASS_HASH);
        models.append(chain_monsters::models::index::team::TEST_CLASS_HASH);
        models.append(chain_monsters::models::index::monster::TEST_CLASS_HASH);
        let world = spawn_test_world(models);

        // [Setup] Systems
        let actions_address = deploy_contract(actions::TEST_CLASS_HASH, array![].span());
        let systems = Systems {
            actions: IActionsDispatcher { contract_address: actions_address },
        };

        // [Setup] Context
        set_contract_address(PLAYER());
        systems.actions.spawn(world, PLAYER_NAME);

        // [Setup] Game if mode is set
        let roles = 0x3213;
        let clans = 0x1234;
        let game_id = systems.actions.create(world, roles, clans);

        let context = Context {
            player_id: PLAYER().into(), player_name: PLAYER_NAME, game_id: game_id,
        };

        // [Return]
        (world, systems, context)
    }
}
