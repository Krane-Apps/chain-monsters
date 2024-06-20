import { useState, useCallback, useMemo } from "react";
import { Box, Button, TextField } from "@mui/material";
import logo from "../assets/logo.png";
import { toast } from "sonner";
import { useDojo } from "@/dojo/useDojo";
import { shortenHex } from "@dojoengine/utils";
import { usePlayer } from "@/hooks/usePlayer";
import { Account } from "starknet";
import { useGame } from "@/hooks/useGame";

const IntroScreen = () => {
  const [playerName, setPlayerName] = useState("");
  const {
    account: { account, create },
    master,
    setup: {
      systemCalls: { spawn: spawnPlayer, create: createGame },
    },
  } = useDojo();
  const { player } = usePlayer({ playerId: account.address });
  const { game } = useGame({ gameId: player?.game_id || 0 });
  console.log("account ===", account, "master ==", master);
  const spawnDisabled = useMemo(
    () =>
      !account ||
      !master ||
      account == master ||
      !!player ||
      !playerName.trim(),
    [account, master, player, playerName],
  );

  const disabled = useMemo(
    () => !account || !master || account == master || !player,
    [account, master, player],
  );

  const handleSpawnClick = useCallback(() => {
    spawnPlayer({ account: account as Account, name: playerName });
  }, [account, playerName]);

  const handleStart = useCallback(() => {
    createGame({ account: account as Account });
  }, [account]);

  return (
    <Box
      display="flex"
      flexDirection="column"
      alignItems="center"
      justifyContent="center"
      mt="2rem"
    >
      <img src={logo} width="600" height="300" alt="chain_monsters_logo" />
      <Box
        className="flex gap-2 justify-center items-center"
        sx={{ mt: "2rem" }}
      >
        <Button
          variant="contained"
          size="large"
          sx={{
            mt: "1rem",
            minWidth: "200px",
            borderRadius: 100,
            bgcolor: "#FFAE02",
          }}
          onClick={() => create()}
        >
          Create Account {shortenHex(account.address)}
        </Button>
      </Box>
      <Box
        display="flex"
        flexDirection="row"
        alignItems="center"
        justifyContent="center"
        sx={{ mt: "2rem" }}
        gap={2}
      >
        <TextField
          variant="standard"
          label="Enter Player Name"
          value={playerName}
          onChange={(e) => setPlayerName(e.target.value)}
          sx={{ minWidth: "200px" }}
        />
        <Button
          variant="contained"
          size="large"
          sx={{
            minWidth: "200px",
            borderRadius: 100,
            bgcolor: "#FFAE02",
          }}
          onClick={handleSpawnClick}
          disabled={spawnDisabled}
        >
          Create Player
        </Button>
      </Box>
      <Button
        variant="contained"
        size="large"
        sx={{
          mt: "1rem",
          width: "200px",
          borderRadius: 100,
          bgcolor: "#FFAE02",
        }}
        onClick={handleStart}
        // disabled={disabled}
      >
        Start Game
      </Button>
      <Button
        variant="contained"
        size="large"
        sx={{
          mt: "1rem",
          minWidth: "200px",
          borderRadius: 100,
          bgcolor: "#FFAE02",
        }}
        onClick={() => toast.error("Coming Soon!")}
      >
        View Leaderboard
      </Button>
    </Box>
  );
};

export default IntroScreen;
