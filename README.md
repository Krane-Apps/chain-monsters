# Chain Monsters - Starkhack 2024

https://github.com/Krane-Apps/chain-monsters/assets/34113569/2e88c6da-7a6b-43ea-87af-eeafdf0410d4

Welcome to the Chain Monsters project, developed for Starkhack 2024. This project is a strategic game where players control monsters on a grid-based battlefield, utilizing their unique abilities to defeat opponents.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Local Environment Setup](#local-environment-setup)
- [Deploying Contracts Locally](#deploying-contracts-locally)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Overview

Chain Monsters is a strategy game built using React, Starknet, and various hooks for state and game management. Players can create accounts, spawn monsters, and engage in strategic battles on a dynamic grid.

## Features

- Account creation and management
- Monster spawning and movement
- Turn-based combat system
- Health and mana management
- Game over detection with the option to start a new game

## Installation

To get started with Chain Monsters, follow these steps:

1. Clone the repository:

   ```sh
   git clone https://github.com/yourusername/chain-monsters.git
   ```

2. Navigate to the project directory:

   ```sh
   cd client
   ```

3. Install the dependencies:

   ```sh
   yarn install && yarn run dev
   ```

## Local Environment Setup

To set up the local environment, follow these steps:

1. Install Scarb:

   ```sh
   curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh -s -- -v nightly-2024-06-08
   ```

2. Install Dojo:

   ```sh
   curl -L https://install.dojoengine.org | bash
   dojoup -v v0.7.0-alpha.5
   ```

## Deploying Contracts Locally

To deploy the contracts locally, use the following commands:

1. Navigate to the contracts folder:

   ```sh
   cd contracts
   ```

2. Start the local Starknet environment:

   ```sh
   katana --disable-fee --invoke-max-steps 10000000 --allowed-origins "*"
   ```

3. Deploy the contracts:

   ```sh
   scarb run deploy
   ```

4. Start the Torii server:

   ```sh
   torii --world 0x1fb599c78048117153dca7958babeeffe9c11a480a58c6654e7e3965320870 --allowed-origins "*"
   ```

# How to Play Game

1. **Game Setup:**

   - Each player starts with four characters, one from each clan: Goblin, Golem, Angel, and Minotaur.
   - The game grid is a 5x8 layout.
   - Characters are initially placed at the edge of the grid.

2. **Movement:**

   - Players take turns moving their characters.
   - Characters can move one block in any of the four directions (up, down, left, right) if the block is empty.

3. **Attacking:**

   - Characters can attack adjacent enemies (any of the four directions).
   - Attacking increases the character's mana.
   - The attacked enemy's health decreases.

4. **Mana and Health:**

   - Normal attack: Decreases enemy health by 25%.
   - Heavy attack (when mana is full): Decreases adjacent enemy health by 50%.

5. **Winning the Game:**
   - The last player with characters remaining on the grid wins the game.

# Blockchain Part

1. **Grid Creation:**

   - At the start of the game, the blockchain creates a grid representing all 8 monsters and their initial health and mana.
   - This grid ensures the state of each monster is transparently recorded and maintained.

2. **In-Game Assets (OPTIONAL):**

   - Monsters and special items can be tokenized as NFTs, allowing for true ownership and trading.

3. **Game Movements:**

   - Each move, attack, and game action is recorded as a transaction on the blockchain.
   - The blockchain ensures transparency and immutability of game actions and returns updated grid values to the frontend.

4. **Health Deduction:**

   - The blockchain calculates health deductions based on the type of attack (normal or heavy). If the attack is heavy (mana used), the respective monster’s mana becomes zero.
   - Damage is recorded and deducted from the target monster's health accordingly.

5. **Rewards:**

   - Players earn cryptocurrency/NFT rewards for victories and achievements, ensuring transparent and secure transactions.

6. **Leaderboard Maintenance:**
   - The blockchain updates the leaderboard based on match outcomes and total damage dealt.
