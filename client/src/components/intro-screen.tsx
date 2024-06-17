import { Box, Button } from "@mui/material";
import logo from "../assets/logo.png";
import { toast } from "sonner";

function IntroScreen({ onStart }: any) {
  return (
    <Box
      display="flex"
      flexDirection="column"
      alignItems="center"
      justifyContent="center"
      mt="5rem"
    >
      <img src={logo} width="600" height="300" alt="chain_monsters_logo" />
      <Button
        variant="contained"
        size="large"
        sx={{
          mt: "2rem",
          width: "200px",
          borderRadius: 100,
          bgcolor: "#FFAE02",
        }}
        onClick={onStart}
      >
        Start
      </Button>
      <Button
        variant="contained"
        size="large"
        sx={{
          mt: "2rem",
          minWidth: "200px",
          borderRadius: 100,
          bgcolor: "#FFAE02",
        }}
        onClick={() => toast.error("Coming Soon!")}
      >
        Leaderboard
      </Button>
    </Box>
  );
}

export default IntroScreen;
