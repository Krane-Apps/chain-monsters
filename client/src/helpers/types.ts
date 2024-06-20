export type Character = {
    id: number;
    name: string;
    idle: string;
    attack: string;
    walk: string;
    dead: string;
  };
  
export type Clan = 'golem' | 'goblin' | 'angel' | 'minotaur';
  
export type Characters = {
    [key in Clan]: Character[];
};

export type SelectedCharacter = {
    clan: Clan;
} & Character;