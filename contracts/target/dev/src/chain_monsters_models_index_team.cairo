impl TeamIntrospect<> of dojo::database::introspect::Introspect<Team<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(2)
    }

    fn layout() -> dojo::database::introspect::Layout {
        dojo::database::introspect::Layout::Fixed(array![8, 251].span())
    }

    #[inline(always)]
    fn ty() -> dojo::database::introspect::Ty {
        dojo::database::introspect::Ty::Struct(
            dojo::database::introspect::Struct {
                name: 'Team',
                attrs: array![].span(),
                children: array![
                    dojo::database::introspect::Member {
                        name: 'game_id',
                        attrs: array!['key'].span(),
                        ty: dojo::database::introspect::Introspect::<u32>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'id',
                        attrs: array!['key'].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'alive_count',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'player_id',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<felt252>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

impl TeamModel of dojo::model::Model<Team> {
    fn entity(
        world: dojo::world::IWorldDispatcher,
        keys: Span<felt252>,
        layout: dojo::database::introspect::Layout
    ) -> Team {
        let values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            775700195803879085284306910425214645505748686644886738874974557010493732161,
            keys,
            layout
        );

        // TODO: Generate method to deserialize from keys / values directly to avoid
        // serializing to intermediate array.
        let mut serialized = core::array::ArrayTrait::new();
        core::array::serialize_array_helper(keys, ref serialized);
        core::array::serialize_array_helper(values, ref serialized);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<Team>::deserialize(ref serialized);

        if core::option::OptionTrait::<Team>::is_none(@entity) {
            panic!(
                "Model `Team`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<Team>::unwrap(entity)
    }

    #[inline(always)]
    fn name() -> ByteArray {
        "Team"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        775700195803879085284306910425214645505748686644886738874974557010493732161
    }

    #[inline(always)]
    fn instance_selector(self: @Team) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn keys(self: @Team) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.game_id, ref serialized);
        core::serde::Serde::serialize(self.id, ref serialized);
        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @Team) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.alive_count, ref serialized);
        core::array::ArrayTrait::append(ref serialized, *self.player_id);
        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::database::introspect::Layout {
        dojo::database::introspect::Introspect::<Team>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @Team) -> dojo::database::introspect::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        let layout = Self::layout();

        match layout {
            dojo::database::introspect::Layout::Fixed(layout) => {
                let mut span_layout = layout;
                Option::Some(dojo::packing::calculate_packed_size(ref span_layout))
            },
            dojo::database::introspect::Layout::Struct(_) => Option::None,
            dojo::database::introspect::Layout::Array(_) => Option::None,
            dojo::database::introspect::Layout::Tuple(_) => Option::None,
            dojo::database::introspect::Layout::Enum(_) => Option::None,
            dojo::database::introspect::Layout::ByteArray => Option::None,
        }
    }
}

#[starknet::interface]
trait Iteam<T> {
    fn ensure_abi(self: @T, model: Team);
}

#[starknet::contract]
mod team {
    use super::Team;
    use super::Iteam;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<Team>::selector()
        }

        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Team>::name()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<Team>::version()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::database::introspect::Introspect::<Team>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<Team>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::database::introspect::Layout {
            dojo::model::Model::<Team>::layout()
        }

        fn schema(self: @ContractState) -> dojo::database::introspect::Ty {
            dojo::database::introspect::Introspect::<Team>::ty()
        }
    }

    #[abi(embed_v0)]
    impl teamImpl of Iteam<ContractState> {
        fn ensure_abi(self: @ContractState, model: Team) {}
    }
}
