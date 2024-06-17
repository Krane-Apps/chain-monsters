import React, { useState } from "react";
import { Box } from "@mui/material";
import { SelectedCharacter } from "@/helpers/types";
import { toast } from "sonner";

interface GameGridProps {
  selectedCharacters: SelectedCharacter[];
}

const initialGrid = (selectedCharacters: SelectedCharacter[]) => {
  const grid = Array.from({ length: 5 }, () => Array(8).fill(null));
  selectedCharacters.forEach((character, index) => {
    grid[index][0] = character;
  });

  // Adding opposing team characters
  const opposingCharacters = selectedCharacters
    .slice(0, 4)
    .map((character, index) => ({
      ...character,
      team: "opponent",
    }));
  opposingCharacters.forEach((character, index) => {
    grid[index][7] = character;
  });

  return grid;
};

export const GameGrid: React.FC<GameGridProps> = ({ selectedCharacters }) => {
  const [grid, setGrid] = useState(initialGrid(selectedCharacters));
  const [selectedCharacter, setSelectedCharacter] =
    useState<SelectedCharacter | null>(null);
  const [availableMoves, setAvailableMoves] = useState<number[][]>([]);
  const [isMoving, setIsMoving] = useState<boolean>(false);
  const [movingCharacter, setMovingCharacter] =
    useState<SelectedCharacter | null>(null);
  const [attacking, setAttacking] = useState<boolean>(false);
  const [isPlayerTurn, setIsPlayerTurn] = useState<boolean>(true); // State to track the turn

  const handleCharacterClick = (row: number, col: number) => {
    if (isMoving || attacking) return; // Prevent new selections while moving or attacking
    const character = grid[row][col];

    // Check if it's the player's turn and the character belongs to the player
    if (isPlayerTurn && character?.team === "opponent") {
      toast.error("This is not your monster");
      return;
    } else if (!isPlayerTurn && character?.team !== "opponent") {
      toast.error("It's not your turn");
      return;
    }

    if (character) {
      setSelectedCharacter(character);
      const moves = [];
      const attacks = [];
      if (row > 0 && !grid[row - 1][col]) moves.push([row - 1, col]);
      if (row < 4 && !grid[row + 1][col]) moves.push([row + 1, col]);
      if (col > 0 && !grid[row][col - 1]) moves.push([row, col - 1]);
      if (col < 7 && !grid[row][col + 1]) moves.push([row, col + 1]);

      if (
        row > 0 &&
        grid[row - 1][col] &&
        grid[row - 1][col].team === (isPlayerTurn ? "opponent" : undefined)
      )
        attacks.push([row - 1, col]);
      if (
        row < 4 &&
        grid[row + 1][col] &&
        grid[row + 1][col].team === (isPlayerTurn ? "opponent" : undefined)
      )
        attacks.push([row + 1, col]);
      if (
        col > 0 &&
        grid[row][col - 1] &&
        grid[row][col - 1].team === (isPlayerTurn ? "opponent" : undefined)
      )
        attacks.push([row, col - 1]);
      if (
        col < 7 &&
        grid[row][col + 1] &&
        grid[row][col + 1].team === (isPlayerTurn ? "opponent" : undefined)
      )
        attacks.push([row, col + 1]);

      setAvailableMoves([
        ...moves,
        ...attacks.map((attack) => [...attack, "attack"]),
      ]);
    }
  };

  const handleMoveClick = (row: number, col: number) => {
    if (
      selectedCharacter &&
      availableMoves.some(
        (move) => move[0] === row && move[1] === col && move[2] !== "attack"
      )
    ) {
      const newGrid = grid.map((row) => row.slice());
      const [oldRow, oldCol] = grid
        .flatMap((row, r) =>
          row.map((cell, c) => (cell === selectedCharacter ? [r, c] : null))
        )
        .filter(Boolean)[0];
      setIsMoving(true);
      setMovingCharacter(selectedCharacter);

      setTimeout(() => {
        newGrid[oldRow][oldCol] = null;
        newGrid[row][col] = selectedCharacter;
        setGrid(newGrid);
        setSelectedCharacter(null);
        setAvailableMoves([]);
        setIsMoving(false);
        setMovingCharacter(null);
        setIsPlayerTurn(!isPlayerTurn); // Switch turn after move
      }, 500);
    } else if (
      selectedCharacter &&
      availableMoves.some(
        (move) => move[0] === row && move[1] === col && move[2] === "attack"
      )
    ) {
      setAttacking(true);
      const attackingCharacter = selectedCharacter;

      setTimeout(() => {
        const newGrid = grid.map((row) => row.slice());
        newGrid[row][col] = null;
        setGrid(newGrid);
        setSelectedCharacter(null);
        setAvailableMoves([]);
        setAttacking(false);
        setIsPlayerTurn(!isPlayerTurn); // Switch turn after attack
      }, 3000);

      setGrid((prevGrid) =>
        prevGrid.map((row, rIdx) =>
          row.map((cell, cIdx) => {
            if (rIdx === row && cIdx === col) {
              return null;
            }
            if (cell === attackingCharacter) {
              return {
                ...cell,
                status: "attacking",
              };
            }
            return cell;
          })
        )
      );
    }
  };

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
          mt: "14rem",
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
                alignItems: "center",
                justifyContent: "center",
                border: "1px solid black",
                borderRadius: "8px",
                backgroundColor: availableMoves.some(
                  (move) => move[0] === rowIndex && move[1] === colIndex
                )
                  ? availableMoves.some(
                      (move) =>
                        move[0] === rowIndex &&
                        move[1] === colIndex &&
                        move[2] === "attack"
                    )
                    ? "red"
                    : "green"
                  : "transparent",
                cursor:
                  cell ||
                  availableMoves.some(
                    (move) => move[0] === rowIndex && move[1] === colIndex
                  )
                    ? "pointer"
                    : "default",
                transition: isMoving ? "transform 0.5s ease-in-out" : "none",
              }}
              onClick={() =>
                cell
                  ? handleCharacterClick(rowIndex, colIndex)
                  : handleMoveClick(rowIndex, colIndex)
              }
            >
              {cell && (
                <img
                  src={
                    cell.status === "attacking"
                      ? cell.attack
                      : isMoving && movingCharacter === cell
                        ? cell.walk
                        : cell.idle
                  }
                  alt={cell.name}
                  style={{
                    width: "100%",
                    height: "160px",
                    margin: 0,
                    marginBottom: "30px",
                    objectFit: "cover",
                    backgroundColor: "transparent",
                  }}
                  onAnimationEnd={() => {
                    if (cell.status === "attacking") {
                      setGrid((prevGrid) =>
                        prevGrid.map((row, rIdx) =>
                          row.map((c, cIdx) => {
                            if (c === cell) {
                              return {
                                ...c,
                                status: "idle",
                              };
                            }
                            return c;
                          })
                        )
                      );
                    }
                  }}
                />
              )}
            </Box>
          ))
        )}
      </Box>
    </Box>
  );
};
