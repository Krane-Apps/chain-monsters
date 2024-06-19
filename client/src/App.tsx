import { useState } from "react";
import { Box, Container } from "@mui/material";
import { MonsterSelection } from "./components/monster-selection";
import { SelectedCharacter } from "./helpers/types";
import IntroScreen from "./components/intro-screen";
import { GameGrid } from "./components/game-grid";
import background from "./assets/backgrounds/game_background.png";
import "./App.css";
import { Account } from "./ui/components/Account";
import { Spawn } from "./ui/actions/Spawn";
import { Create } from "./ui/actions/Create";
import { Monsters } from "./ui/containers/Monsters";
import { Move } from "./ui/actions/Move";

function App() {
  // const [gameState, setGameState] = useState<string>("intro");
  // const [selectedCharacters, setSelectedCharacters] = useState<
  //   SelectedCharacter[]
  // >([]);

  // const handleStart = () => {
  //   setGameState("selection");
  // };

  // const handleConfirm = (characters: SelectedCharacter[]) => {
  //   setSelectedCharacters(characters);
  //   setGameState("game");
  // };

  return (
    <Box
      sx={{
        backgroundImage: `url(${background})`,
        backgroundSize: "cover",
        backgroundPosition: "center",
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
      }}
    >
      <Container>
        <h1>Chain Monsters</h1>
        <Account />
        <Spawn />
        <Create />
        <Monsters />
        <Move />
        <GameGrid />
      </Container>
    </Box>
  );
}

export default App;
