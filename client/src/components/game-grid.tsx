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
} from "@mui/material";
import { useMonsters } from "@/hooks/useMonsters";
import { useDojo } from "@/dojo/useDojo";
import { usePlayer } from "@/hooks/usePlayer";
import { useGame } from "@/hooks/useGame";
import { SelectedCharacter } from "@/helpers/types";
import { characters } from "@/helpers/constants";
import { Account } from "starknet";

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

  const {
    account: { account },
    master,
    setup: {
      systemCalls: { move, create: createGame },
    },
  } = useDojo();
  const { player } = usePlayer({ playerId: account.address });
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
          monsters[i].id !== prevMonsters[i].id ||
          monsters[i].x !== prevMonsters[i].x ||
          monsters[i].y !== prevMonsters[i].y
        ) {
          return true;
        }
      }
      return false;
    };
    if (monsters && monsters.length > 0 && haveMonstersChanged()) {
      refreshGrid();
    }
  }, [monsters, initialGrid]);

  useEffect(() => {
    if (game?.over) {
      setGameOver(true);
    }
  }, [game]);

  const refreshGrid = () => {
    const updatedGrid = initialGrid.map((row) => row.slice());
    monsters.forEach((monster: any) => {
      const char = characters.find((c) => c.id === monster.id);
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
        game_id: game.id,
        team_id: 1,
        monster_id: id,
        x: col,
        y: row,
        special: false,
      });
      if (enemyCells.some((enemy) => enemy[0] === row && enemy[1] === col)) {
        const attackedMonster = grid[row][col];
        if (attackedMonster && attackedMonster.health === damage) {
          setDeadCells((prev) => ({ ...prev, [`${row}-${col}`]: true }));
        }
        setAttackingCells((prev) => ({ ...prev, [`${x}-${y}`]: true }));
        setTimeout(() => {
          setAttackingCells((prev) => ({ ...prev, [`${x}-${y}`]: false }));
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
                width: 100,
                height: 100,
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                justifyContent: "center",
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
              }}
              onClick={() =>
                cell && cell.team_id !== 2
                  ? handleCharacterClick(rowIndex, colIndex)
                  : handleMoveClick(rowIndex, colIndex)
              }
            >
              {cell && (
                <>
                  <Box sx={{ width: "60%", mb: -2.5 }}>
                    <LinearProgress
                      variant="determinate"
                      color="warning"
                      value={(cell.health / 100) * 100}
                      sx={{ borderRadius: "1rem" }}
                    />
                    <LinearProgress
                      variant="determinate"
                      value={(cell.mana / 100) * 100}
                      color="info"
                      sx={{
                        mt: "0.25rem",
                        borderRadius: "1rem",
                      }}
                    />
                  </Box>
                  <img
                    src={
                      deadCells[`${row}-${colIndex}`]
                        ? cell.dead
                        : attackingCells[`${cell.x}-${cell.y}`]
                          ? cell.attack
                          : cell.idle
                    }
                    alt={cell.name}
                    style={{
                      width: "100%",
                      height: "200px",
                      margin: 0,
                      marginBottom: "0px",
                      objectFit: "cover",
                      backgroundColor: "transparent",
                    }}
                  />
                </>
              )}
            </Box>
          )),
        )}
      </Box>
      <Dialog open={gameOver} onClose={() => setGameOver(false)}>
        <DialogTitle>Game Over</DialogTitle>
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
