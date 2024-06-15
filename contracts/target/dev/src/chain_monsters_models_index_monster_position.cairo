impl MonsterPositionIntrospect<> of dojo::database::introspect::Introspect<MonsterPosition<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(2)
    }

    fn layout() -> dojo::database::introspect::Layout {
        dojo::database::introspect::Layout::Fixed(array![8, 8].span())
    }

    #[inline(always)]
    fn ty() -> dojo::database::introspect::Ty {
        dojo::database::introspect::Ty::Struct(
            dojo::database::introspect::Struct {
                name: 'MonsterPosition',
                attrs: array![].span(),
                children: array![
                    dojo::database::introspect::Member {
                        name: 'game_id',
                        attrs: array!['key'].span(),
                        ty: dojo::database::introspect::Introspect::<u32>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'x',
                        attrs: array!['key'].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'y',
                        attrs: array!['key'].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'team_id',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'monster_id',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

impl MonsterPositionModel of dojo::model::Model<MonsterPosition> {
    fn entity(
        world: dojo::world::IWorldDispatcher,
        keys: Span<felt252>,
        layout: dojo::database::introspect::Layout
    ) -> MonsterPosition {
        let values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            392187848571380253511968103739358582048064862982321444795042221668756615203,
            keys,
            layout
        );

        // TODO: Generate method to deserialize from keys / values directly to avoid
        // serializing to intermediate array.
        let mut serialized = core::array::ArrayTrait::new();
        core::array::serialize_array_helper(keys, ref serialized);
        core::array::serialize_array_helper(values, ref serialized);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<MonsterPosition>::deserialize(ref serialized);

        if core::option::OptionTrait::<MonsterPosition>::is_none(@entity) {
            panic!(
                "Model `MonsterPosition`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<MonsterPosition>::unwrap(entity)
    }

    #[inline(always)]
    fn name() -> ByteArray {
        "MonsterPosition"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        392187848571380253511968103739358582048064862982321444795042221668756615203
    }

    #[inline(always)]
    fn instance_selector(self: @MonsterPosition) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn keys(self: @MonsterPosition) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.game_id, ref serialized);
        core::serde::Serde::serialize(self.x, ref serialized);
        core::serde::Serde::serialize(self.y, ref serialized);
        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @MonsterPosition) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.team_id, ref serialized);
        core::serde::Serde::serialize(self.monster_id, ref serialized);
        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::database::introspect::Layout {
        dojo::database::introspect::Introspect::<MonsterPosition>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @MonsterPosition) -> dojo::database::introspect::Layout {
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
trait Imonster_position<T> {
    fn ensure_abi(self: @T, model: MonsterPosition);
}

#[starknet::contract]
mod monster_position {
    use super::MonsterPosition;
    use super::Imonster_position;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<MonsterPosition>::selector()
        }

        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<MonsterPosition>::name()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<MonsterPosition>::version()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::database::introspect::Introspect::<MonsterPosition>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<MonsterPosition>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::database::introspect::Layout {
            dojo::model::Model::<MonsterPosition>::layout()
        }

        fn schema(self: @ContractState) -> dojo::database::introspect::Ty {
            dojo::database::introspect::Introspect::<MonsterPosition>::ty()
        }
    }

    #[abi(embed_v0)]
    impl monster_positionImpl of Imonster_position<ContractState> {
        fn ensure_abi(self: @ContractState, model: MonsterPosition) {}
    }
}
