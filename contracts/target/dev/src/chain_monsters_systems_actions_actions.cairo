// Starknet imports

use starknet::ContractAddress;

// Dojo imports

use dojo::world::IWorldDispatcher;

// Interfaces

#[starknet::interface]
trait IActions<TContractState> {
    fn spawn(self: @TContractState, world: IWorldDispatcher, name: felt252,);
    fn create(self: @TContractState, world: IWorldDispatcher) -> u32;
    fn join(self: @TContractState, world: IWorldDispatcher, game_id: u32);
    fn ready(self: @TContractState, world: IWorldDispatcher, game_id: u32, status: bool);
    fn transfer(self: @TContractState, world: IWorldDispatcher, game_id: u32, team_index: u8);
    fn leave(self: @TContractState, world: IWorldDispatcher, game_id: u32,);
    fn kick(self: @TContractState, world: IWorldDispatcher, game_id: u32, team_index: u8);
    fn delete(self: @TContractState, world: IWorldDispatcher, game_id: u32,);
    fn start(self: @TContractState, world: IWorldDispatcher, game_id: u32,);
}

// Contracts

#[starknet::contract]
mod actions {
    // Dojo imports

    use dojo::world;
    use dojo::world::IWorldDispatcher;
    use dojo::world::IWorldDispatcherTrait;
    use dojo::world::IDojoResourceProvider;

    // Component imports

    use chain_monsters::components::initializable::InitializableComponent;
    use chain_monsters::components::manageable::ManageableComponent;
    use chain_monsters::components::hostable::HostableComponent;

    // Local imports

    use super::IActions;

    // Components

    component!(path: InitializableComponent, storage: initializable, event: InitializableEvent);
    #[abi(embed_v0)]
    impl WorldProviderImpl =
        InitializableComponent::WorldProviderImpl<ContractState>;
    #[abi(embed_v0)]
    impl DojoInitImpl = InitializableComponent::DojoInitImpl<ContractState>;
    component!(path: ManageableComponent, storage: manageable, event: ManageableEvent);
    impl ManageableInternalImpl = ManageableComponent::InternalImpl<ContractState>;
    component!(path: HostableComponent, storage: hostable, event: HostableEvent);
    impl HostableInternalImpl = HostableComponent::InternalImpl<ContractState>;

    // Storage

    #[storage]
    struct Storage {
        #[substorage(v0)]
        initializable: InitializableComponent::Storage,
        #[substorage(v0)]
        manageable: ManageableComponent::Storage,
        #[substorage(v0)]
        hostable: HostableComponent::Storage,
    }

    // Events

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        InitializableEvent: InitializableComponent::Event,
        #[flat]
        ManageableEvent: ManageableComponent::Event,
        #[flat]
        HostableEvent: HostableComponent::Event,
    }

    // Implementations

    #[abi(embed_v0)]
    impl DojoResourceProviderImpl of IDojoResourceProvider<ContractState> {
        fn dojo_resource(self: @ContractState) -> felt252 {
            'actions'
        }
    }

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(self: @ContractState, world: IWorldDispatcher, name: felt252) {
            self.manageable._spawn(world, name);
        }

        fn create(self: @ContractState, world: IWorldDispatcher) -> u32 {
            self.hostable._create(world)
        }

        fn join(self: @ContractState, world: IWorldDispatcher, game_id: u32) {
            self.hostable._join(world, game_id)
        }

        fn ready(self: @ContractState, world: IWorldDispatcher, game_id: u32, status: bool) {
            self.hostable._ready(world, game_id, status)
        }

        fn transfer(self: @ContractState, world: IWorldDispatcher, game_id: u32, team_index: u8) {
            self.hostable._transfer(world, game_id, team_index)
        }

        fn leave(self: @ContractState, world: IWorldDispatcher, game_id: u32) {
            self.hostable._leave(world, game_id)
        }

        fn kick(self: @ContractState, world: IWorldDispatcher, game_id: u32, team_index: u8) {
            self.hostable._kick(world, game_id, team_index)
        }

        fn delete(self: @ContractState, world: IWorldDispatcher, game_id: u32) {
            self.hostable._delete(world, game_id)
        }

        fn start(self: @ContractState, world: IWorldDispatcher, game_id: u32) {
            self.hostable._start(world, game_id)
        }
    }
}
