mod constants;
mod events;
mod store;

mod models {
    mod index;
    mod game;
    mod player;
    mod team;
    mod monster;
}

mod helpers {
    mod grid;
    mod packer;
}

mod types {
    mod role;
    mod clan;
}

mod elements {
    mod clans {
        mod interface;
        mod goblin;
        mod golem;
        mod angel;
        mod minotaur;
    }

    mod roles {
        mod interface;
        mod warrior;
        mod assassin;
        mod paladin;
    }
}

mod components {
    mod initializable;
    mod hostable;
    mod manageable;
    mod playable;
}

mod systems {
    mod actions;
}

#[cfg(test)]
mod tests {
    mod setup;
    mod move;
}

