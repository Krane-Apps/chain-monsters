import { useState } from "react";
import { Box, Container } from "@mui/material";
import IntroScreen from "./components/intro-screen";
import { GameGrid } from "./components/game-grid";
import background from "./assets/backgrounds/game_background.png";
import "./App.css";
import { useGame } from "./hooks/useGame";
import { useDojo } from "./dojo/useDojo";
import { usePlayer } from "./hooks/usePlayer";
import {
  StarknetConfig,
  Connector,
  starkscan,
  jsonRpcProvider,
} from "@starknet-react/core";
import { Chain, sepolia } from "@starknet-react/chains";
import CartridgeConnector from "@cartridge/connector";

function rpc(_chain: Chain) {
  return {
    nodeUrl: import.meta.env.VITE_PUBLIC_NODE_URL,
  };
}

const connectors = [
  new CartridgeConnector(
    [
      {
        target: import.meta.env.VITE_PUBLIC_ACTIONS_CONTRACT,
        method: "spawn",
      },
      {
        target: import.meta.env.VITE_PUBLIC_ACTIONS_CONTRACT,
        method: "create",
      },
      {
        target: import.meta.env.VITE_PUBLIC_ACTIONS_CONTRACT,
        method: "move",
      },
      {
        target: import.meta.env.VITE_PUBLIC_ACTIONS_CONTRACT,
        method: "surrender",
      },
    ],
    {
      colorMode: "dark",
    },
  ) as never as Connector,
];

const GameScene = () => {
  const {
    account: { account },
  } = useDojo();
  const { player } = usePlayer({ playerId: account?.address || "0x0" });
  const { game } = useGame({ gameId: player?.game_id || 0 });
  return <Container>{game ? <GameGrid /> : <IntroScreen />}</Container>;
};

function App() {
  return (
    <StarknetConfig
      autoConnect
      chains={[sepolia]}
      connectors={connectors}
      explorer={starkscan}
      provider={jsonRpcProvider({ rpc })}
    >
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
        <GameScene />
      </Box>
    </StarknetConfig>
  );
}

export default App;
