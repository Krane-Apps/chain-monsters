import React, {
  useState,
  useEffect,
  useMemo,
  useRef,
  useCallback,
} from "react";
import {
  Box,
  LinearProgress,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Button,
  Typography,
} from "@mui/material";
import { useMonsters } from "@/hooks/useMonsters";
import { useDojo } from "@/dojo/useDojo";
import { usePlayer } from "@/hooks/usePlayer";
import { useGame } from "@/hooks/useGame";
import { SelectedCharacter } from "@/helpers/types";
import { characters } from "@/helpers/constants";
import { Account } from "starknet";
import attackSound from "../assets/sound_effect/hammer_attack.wav";

interface GameGridProps {}

export const GameGrid: React.FC<GameGridProps> = () => {
  const initialGrid = useMemo(
    () => Array.from({ length: 5 }, () => Array(8).fill(null)),
    [],
  );
  const [grid, setGrid] = useState<(SelectedCharacter | null)[][]>(initialGrid);
  const [selectedCharacter, setSelectedCharacter] =
    useState<SelectedCharacter | null>(null);
  const [availableMoves, setAvailableMoves] = useState<number[][]>([]);
  const [enemyCells, setEnemyCells] = useState<number[][]>([]);
  const [attackingCells, setAttackingCells] = useState<{
    [key: string]: boolean;
  }>({});
  const [deadCells, setDeadCells] = useState<{ [key: string]: boolean }>({});
  const [gameOver, setGameOver] = useState(false);
  const [currentAttack, setCurrentAttack] = useState<{
    x: number;
    y: number;
  } | null>(null);
  const [winner, setWinner] = useState<string | null>(null);

  const attackAudio = useMemo(() => new Audio(attackSound), []);

  const {
    account: { account },
    master,
    setup: {
      systemCalls: { move, create: createGame },
    },
  } = useDojo();
  const { player } = usePlayer({ playerId: account?.address || "0x0" });
  const { game } = useGame({ gameId: player?.game_id || 0 });
  const { monsters } = useMonsters({ gameId: player?.game_id || 1 });

  const prevMonstersRef = useRef<any[]>([]);

  useEffect(() => {
    const prevMonsters = prevMonstersRef.current;
    const haveMonstersChanged = () => {
      if (prevMonsters.length !== monsters.length) {
        return true;
      }
      for (let i = 0; i < monsters.length; i++) {
        if (
          monsters[i]?.id !== prevMonsters[i]?.id ||
          monsters[i].x !== prevMonsters[i].x ||
          monsters[i].y !== prevMonsters[i].y ||
          monsters[i].health !== prevMonsters[i].health ||
          monsters[i].mana !== prevMonsters[i].mana
        ) {
          return true;
        }
      }
      return false;
    };
    if (monsters && monsters.length > 0 && haveMonstersChanged()) {
      refreshGrid();
    }
    prevMonstersRef.current = monsters;
  }, [monsters, initialGrid]);

  useEffect(() => {
    if (game?.over) {
      setGameOver(true);
      const team1Monsters = monsters.filter((monster) => monster.team_id === 1);
      setWinner(team1Monsters.length > 0 ? "You won!" : "AI wins!");
    }
  }, [game, monsters]);

  const refreshGrid = () => {
    const updatedGrid = initialGrid.map((row) => row.slice());
    monsters.forEach((monster: any) => {
      const char = characters.find((c) => c?.id === monster?.id);
      if (char) {
        updatedGrid[monster.y][monster.x] = { ...char, ...monster };
      }
    });
    setGrid(updatedGrid);
    prevMonstersRef.current = monsters;
  };

  const handleCharacterClick = (row: number, col: number) => {
    const character = grid[row][col];
    // Ensure only friendly monsters can be selected
    if (character && character.team_id !== 2) {
      setSelectedCharacter(character);
      const moves = [];
      const enemies = [];
      if (row > 0) {
        if (!grid[row - 1][col]) moves.push([row - 1, col]);
        if (grid[row - 1][col]?.team_id === 2) enemies.push([row - 1, col]);
      }
      if (row < 4) {
        if (!grid[row + 1][col]) moves.push([row + 1, col]);
        if (grid[row + 1][col]?.team_id === 2) enemies.push([row + 1, col]);
      }
      if (col > 0) {
        if (!grid[row][col - 1]) moves.push([row, col - 1]);
        if (grid[row][col - 1]?.team_id === 2) enemies.push([row, col - 1]);
      }
      if (col < 7) {
        if (!grid[row][col + 1]) moves.push([row, col + 1]);
        if (grid[row][col + 1]?.team_id === 2) enemies.push([row, col + 1]);
      }
      setAvailableMoves(moves);
      setEnemyCells(enemies);
    }
  };

  const handleMoveClick = (row: number, col: number) => {
    if (
      selectedCharacter &&
      (availableMoves.some((move) => move[0] === row && move[1] === col) ||
        enemyCells.some((enemy) => enemy[0] === row && enemy[1] === col))
    ) {
      const { id, x, y, damage }: any = selectedCharacter;
      if (!game) return;
      move({
        account: account as Account,
        game_id: game?.id,
        team_id: 1,
        monster_id: id,
        x: col,
        y: row,
        special: false,
      });
      if (enemyCells.some((enemy) => enemy[0] === row && enemy[1] === col)) {
        attackAudio.loop = true;
        attackAudio.play();
        const attackedMonster = grid[row][col];
        if (attackedMonster && attackedMonster.health <= damage) {
          setDeadCells((prev) => ({ ...prev, [`${row}-${col}`]: true }));
        }
        setAttackingCells((prev) => ({ ...prev, [`${x}-${y}`]: true }));
        setCurrentAttack({ x: row, y: col });
        setTimeout(() => {
          setAttackingCells((prev) => ({ ...prev, [`${x}-${y}`]: false }));
          setCurrentAttack(null);
          attackAudio.loop = false;
          attackAudio.pause();
          attackAudio.currentTime = 0;
        }, 3000);
      } else {
        const newGrid = grid.map((row) => row.slice());
        newGrid[selectedCharacter.y][selectedCharacter.x] = null;
        newGrid[row][col] = { ...selectedCharacter, x: col, y: row };
        setGrid(newGrid);
      }
      setSelectedCharacter(null);
      setAvailableMoves([]);
      setEnemyCells([]);
    }
  };

  const handleNewGame = useCallback(() => {
    const roles = [1, 1, 1, 1];
    const clans = [1, 1, 1, 1];
    createGame({ account: account as Account, roles, clans });
    setGameOver(false);
    setWinner(null);
  }, [account, createGame]);

  return (
    <Box
      display="flex"
      minHeight="100vh"
      width="100%"
      justifyContent="center"
      alignItems="center"
    >
      <Box
        sx={{
          display: "grid",
          gridTemplateColumns: "repeat(8, 1fr)",
          gap: "4px",
          mt: "13rem",
        }}
      >
        {grid.map((row, rowIndex) =>
          row.map((cell, colIndex) => (
            <Box
              key={`${rowIndex}-${colIndex}`}
              sx={{
                width: 120,
                height: 120,
                position: "relative",
                border: "1px solid black",
                borderRadius: "8px",
                backgroundColor: availableMoves.some(
                  (move) => move[0] === rowIndex && move[1] === colIndex,
                )
                  ? "green"
                  : enemyCells.some(
                        (enemy) =>
                          enemy[0] === rowIndex && enemy[1] === colIndex,
                      )
                    ? "red"
                    : "transparent",
                cursor:
                  (cell && cell.team_id !== 2) ||
                  availableMoves.some(
                    (move) => move[0] === rowIndex && move[1] === colIndex,
                  ) ||
                  enemyCells.some(
                    (enemy) => enemy[0] === rowIndex && enemy[1] === colIndex,
                  )
                    ? "pointer"
                    : "default",
                overflow: "visible",
              }}
              onClick={() =>
                cell && cell.team_id !== 2
                  ? handleCharacterClick(rowIndex, colIndex)
                  : handleMoveClick(rowIndex, colIndex)
              }
            >
              {cell && (
                <>
                  <Box
                    sx={{
                      position: "absolute",
                      top: 0,
                      left: 0,
                      width: "100%",
                      zIndex: 1,
                      textAlign: "center",
                      backgroundColor: "rgba(255, 255, 255, 0.7)",
                      padding: "2px 0",
                      mt: "-3rem",
                      borderBottom: "1px solid #ccc",
                      overflow: "visible",
                      borderRadius: "0.5rem",
                    }}
                  >
                    <Typography variant="subtitle2">
                      Team {cell.team_id}
                    </Typography>
                    <Box
                      sx={{
                        width: "80%",
                        margin: "0 auto",
                      }}
                    >
                      <LinearProgress
                        variant="determinate"
                        color="warning"
                        value={(cell.health / 100) * 100}
                        sx={{ borderRadius: "1rem", height: "8px" }}
                      />
                      <LinearProgress
                        variant="determinate"
                        value={(cell.mana / 100) * 100}
                        color="info"
                        sx={{
                          mt: "2px",
                          borderRadius: "1rem",
                          height: "8px",
                        }}
                      />
                    </Box>
                  </Box>
                  <img
                    src={
                      deadCells[`${row}-${colIndex}`] ||
                      (currentAttack &&
                        currentAttack.x === rowIndex &&
                        currentAttack.y === colIndex)
                        ? cell.dead
                        : attackingCells[`${cell.x}-${cell.y}`]
                          ? cell.attack
                          : cell.idle
                    }
                    alt={cell.name}
                    style={{
                      width: "120px",
                      height: "200px",
                      position: "absolute",
                      top: "-60px",
                      left: "-0px",
                      objectFit: "cover",
                      overflow: "visible",
                      backgroundColor: "transparent",
                      transform: cell.team_id === 2 ? "scaleX(-1)" : "none",
                      zIndex: 0,
                    }}
                  />
                </>
              )}
            </Box>
          )),
        )}
      </Box>
      <Dialog open={gameOver} onClose={() => setGameOver(false)}>
        <DialogTitle>{winner}</DialogTitle>
        <DialogContent>
          The game is over. Would you like to start a new game?
        </DialogContent>
        <DialogActions>
          <Button onClick={handleNewGame} color="primary">
            Start New Game
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};
