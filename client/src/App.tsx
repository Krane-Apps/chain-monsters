import { useState } from "react";
import { Box, Container } from "@mui/material";
import IntroScreen from "./components/intro-screen";
import { GameGrid } from "./components/game-grid";
import background from "./assets/backgrounds/game_background.png";
import "./App.css";
import { useGame } from "./hooks/useGame";
import { useDojo } from "./dojo/useDojo";
import { usePlayer } from "./hooks/usePlayer";
import { Create } from "@/ui/actions/Create";

function App() {
  const {
    account: { account },
    master,
    setup: {
      systemCalls: { move },
    },
  } = useDojo();
  const { player } = usePlayer({ playerId: account.address });
  const { game } = useGame({ gameId: player?.game_id || 0 });

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
        <Create />
        {game ? <GameGrid /> : <IntroScreen />}
      </Container>
    </Box>
  );
}

export default App;
