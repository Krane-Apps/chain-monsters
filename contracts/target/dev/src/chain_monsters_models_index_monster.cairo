impl MonsterIntrospect<> of dojo::database::introspect::Introspect<Monster<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        Option::Some(9)
    }

    fn layout() -> dojo::database::introspect::Layout {
        dojo::database::introspect::Layout::Fixed(array![8, 8, 8, 8, 8, 8, 8, 8, 8].span())
    }

    #[inline(always)]
    fn ty() -> dojo::database::introspect::Ty {
        dojo::database::introspect::Ty::Struct(
            dojo::database::introspect::Struct {
                name: 'Monster',
                attrs: array![].span(),
                children: array![
                    dojo::database::introspect::Member {
                        name: 'game_id',
                        attrs: array!['key'].span(),
                        ty: dojo::database::introspect::Introspect::<u32>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'team_id',
                        attrs: array!['key'].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'id',
                        attrs: array!['key'].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'role',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'clan',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'health',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'damage',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'mana',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'x',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'y',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'last_x',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'last_y',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

impl MonsterModel of dojo::model::Model<Monster> {
    fn entity(
        world: dojo::world::IWorldDispatcher,
        keys: Span<felt252>,
        layout: dojo::database::introspect::Layout
    ) -> Monster {
        let values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            1679637039084806116166135357120549171906113018761479194444192849294904621356,
            keys,
            layout
        );

        // TODO: Generate method to deserialize from keys / values directly to avoid
        // serializing to intermediate array.
        let mut serialized = core::array::ArrayTrait::new();
        core::array::serialize_array_helper(keys, ref serialized);
        core::array::serialize_array_helper(values, ref serialized);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<Monster>::deserialize(ref serialized);

        if core::option::OptionTrait::<Monster>::is_none(@entity) {
            panic!(
                "Model `Monster`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<Monster>::unwrap(entity)
    }

    #[inline(always)]
    fn name() -> ByteArray {
        "Monster"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        1679637039084806116166135357120549171906113018761479194444192849294904621356
    }

    #[inline(always)]
    fn instance_selector(self: @Monster) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn keys(self: @Monster) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.game_id, ref serialized);
        core::serde::Serde::serialize(self.team_id, ref serialized);
        core::serde::Serde::serialize(self.id, ref serialized);
        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @Monster) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.role, ref serialized);
        core::serde::Serde::serialize(self.clan, ref serialized);
        core::serde::Serde::serialize(self.health, ref serialized);
        core::serde::Serde::serialize(self.damage, ref serialized);
        core::serde::Serde::serialize(self.mana, ref serialized);
        core::serde::Serde::serialize(self.x, ref serialized);
        core::serde::Serde::serialize(self.y, ref serialized);
        core::serde::Serde::serialize(self.last_x, ref serialized);
        core::serde::Serde::serialize(self.last_y, ref serialized);
        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::database::introspect::Layout {
        dojo::database::introspect::Introspect::<Monster>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @Monster) -> dojo::database::introspect::Layout {
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
trait Imonster<T> {
    fn ensure_abi(self: @T, model: Monster);
}

#[starknet::contract]
mod monster {
    use super::Monster;
    use super::Imonster;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<Monster>::selector()
        }

        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Monster>::name()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<Monster>::version()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::database::introspect::Introspect::<Monster>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<Monster>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::database::introspect::Layout {
            dojo::model::Model::<Monster>::layout()
        }

        fn schema(self: @ContractState) -> dojo::database::introspect::Ty {
            dojo::database::introspect::Introspect::<Monster>::ty()
        }
    }

    #[abi(embed_v0)]
    impl monsterImpl of Imonster<ContractState> {
        fn ensure_abi(self: @ContractState, model: Monster) {}
    }
}
