import { Character } from "./types";
import blue_eyed_angle_walking from "../assets/characters/angles/blue_eyed_angle_walking.gif";
import blue_eyed_angle_attack from "../assets/characters/angles/blue_eyed_angle_attack.gif";
import blue_eyed_angle_idle from "../assets/characters/angles/blue_eyed_angle_idle.gif";
import blue_eyed_angle_dying from "../assets/characters/angles/blue_eyed_angle_dying.gif";

import crown_angle_walking from "../assets/characters/angles/crown_angle_walking.gif";
import crown_angle_attack from "../assets/characters/angles/crown_angle_attack.gif";
import crown_angle_idle from "../assets/characters/angles/crown_angle_idle.gif";
import crown_angle_dying from "../assets/characters/angles/crown_angle_dying.gif";

import fire_golem_walking from "../assets/characters/golem/fire_golem_walking.gif";
import fire_golem_attack from "../assets/characters/golem/fire_golem_attack.gif";
import fire_golem_idle from "../assets/characters/golem/fire_golem_idle.gif";
import fire_golem_dying from "../assets/characters/golem/fire_golem_dying.gif";

import ice_golem_walking from "../assets/characters/golem/ice_golem_walking.gif";
import ice_golem_attack from "../assets/characters/golem/ice_golem_attack.gif";
import ice_golem_idle from "../assets/characters/golem/ice_golem_idle.gif";
import ice_golem_dying from "../assets/characters/golem/ice_golem_dying.gif";

import earth_minotaur_walking from "../assets/characters/minotaur/earth_minotaur_walking.gif";
import earth_minotaur_attack from "../assets/characters/minotaur/earth_minotaur_attack.gif";
import earth_minotaur_idle from "../assets/characters/minotaur/earth_minotaur_idle.gif";
import earth_minotaur_dying from "../assets/characters/minotaur/earth_minotaur_dying.gif";

import stone_minotaur_walking from "../assets/characters/minotaur/stone_minotaur_walking.gif";
import stone_minotaur_attack from "../assets/characters/minotaur/stone_minotaur_attack.gif";
import stone_minotaur_idle from "../assets/characters/minotaur/stone_minotaur_idle.gif";
import stone_minotaur_dying from "../assets/characters/minotaur/stone_minotaur_dying.gif";

import goblin_walking from "../assets/characters/goblin/goblin_walking.gif";
import goblin_attack from "../assets/characters/goblin/goblin_attack.gif";
import goblin_idle from "../assets/characters/goblin/goblin_idle.gif";
import goblin_dying from "../assets/characters/goblin/goblin_dying.gif";

import orc_walking from "../assets/characters/goblin/orc_walking.gif";
import orc_attack from "../assets/characters/goblin/orc_attack.gif";
import orc_idle from "../assets/characters/goblin/orc_idle.gif";
import orc_dying from "../assets/characters/goblin/orc_dying.gif";

export const characters: Character[] = 
[
    { id: 1, name: 'Fire Golem', idle: fire_golem_idle, attack: fire_golem_attack, walk: fire_golem_walking, dead: fire_golem_dying },
    { id: 2, name: 'Ice Golem', idle: ice_golem_idle, attack: ice_golem_attack, walk: ice_golem_walking, dead: ice_golem_dying },
    { id: 4, name: 'Green Goblin', idle: goblin_idle, attack: goblin_attack, walk: goblin_walking, dead: goblin_dying },
    { id: 5, name: 'Green Orc', idle: orc_idle, attack: orc_attack, walk: orc_walking, dead: orc_dying },
    { id: 7, name: 'Blue Eyed Angel', idle: blue_eyed_angle_idle, attack: blue_eyed_angle_attack, walk: blue_eyed_angle_walking, dead: blue_eyed_angle_dying },
    { id: 8, name: 'Crown Angle', idle: crown_angle_idle, attack: crown_angle_attack, walk: crown_angle_walking, dead: crown_angle_dying },
    { id: 10, name: 'Earth Minotaur', idle: earth_minotaur_idle, attack: earth_minotaur_attack, walk: earth_minotaur_walking, dead: earth_minotaur_dying },
    { id: 11, name: 'Stone Minotaur', idle: stone_minotaur_idle, attack: stone_minotaur_attack, walk: stone_minotaur_walking, dead: stone_minotaur_dying },
];
