import { useState } from "react";
import { Box, Container } from "@mui/material";
import { MonsterSelection } from "./components/monster-selection";
import { SelectedCharacter } from "./helpers/types";
import IntroScreen from "./components/intro-screen";
import { GameGrid } from "./components/game-grid";
import background from "./assets/backgrounds/game_background.png";
import "./App.css";

function App() {
  const [gameState, setGameState] = useState<string>("intro");
  const [selectedCharacters, setSelectedCharacters] = useState<
    SelectedCharacter[]
  >([]);

  const handleStart = () => {
    setGameState("selection");
  };

  const handleConfirm = (characters: SelectedCharacter[]) => {
    setSelectedCharacters(characters);
    setGameState("game"); // Set game state to "game"
  };

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
        {gameState === "intro" && <IntroScreen onStart={handleStart} />}
        {gameState === "selection" && (
          <MonsterSelection onConfirm={handleConfirm} />
        )}
        {gameState === "game" && (
          <GameGrid selectedCharacters={selectedCharacters} />
        )}
      </Container>
    </Box>
  );
}

export default App;
