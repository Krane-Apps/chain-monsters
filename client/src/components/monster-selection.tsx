import React, { useState } from "react";
import {
  Box,
  Typography,
  Grid,
  Card,
  CardMedia,
  CardContent,
  Button,
} from "@mui/material";
import { characters } from "@/helpers/constants";
import { Character, SelectedCharacter } from "@/helpers/types";

interface MonsterSelectionProps {
  onConfirm: (selectedCharacters: SelectedCharacter[]) => void;
}

export const MonsterSelection: React.FC<MonsterSelectionProps> = ({
  onConfirm,
}) => {
  const [selectedCharacters, setSelectedCharacters] = useState<
    SelectedCharacter[]
  >([]);
  const [hoveredCharacterId, setHoveredCharacterId] = useState<number | null>(
    null,
  );

  const handleCharacterClick = (character: Character) => {
    const isSelected = selectedCharacters.some((c) => c.id === character.id);

    if (isSelected) {
      setSelectedCharacters(
        selectedCharacters.filter((c) => c.id !== character.id),
      );
    } else {
      if (selectedCharacters.length < 4) {
        setSelectedCharacters([...selectedCharacters, character]);
      } else {
        alert("You can only select 4 characters.");
      }
    }
  };

  const handleConfirm = () => {
    if (selectedCharacters.length === 4) {
      onConfirm(selectedCharacters);
    } else {
      alert("Please select 4 characters.");
    }
  };

  return (
    <Box
      sx={{
        textAlign: "center",
        p: 2,
        backgroundImage: `url(../assets/backgrounds/selection_background.png)`,
        backgroundSize: "cover",
        backgroundPosition: "center",
        minHeight: "100vh",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
      }}
    >
      <Typography variant="h4" sx={{ mb: 2, color: "white" }}>
        Select 4 Characters
      </Typography>
      <Grid container spacing={2} justifyContent="center">
        {characters.map((character) => (
          <Grid item key={character.id} xs={12} sm={6} md={3}>
            <Card
              onClick={() => handleCharacterClick(character)}
              onMouseEnter={() => setHoveredCharacterId(character.id)}
              onMouseLeave={() => setHoveredCharacterId(null)}
              sx={{
                border: selectedCharacters.some((c) => c.id === character.id)
                  ? "6px solid red"
                  : "6px solid transparent",
                cursor: "pointer",
                transition: "border 0.3s",
                backgroundColor: "rgba(255, 255, 255, 0.1)",
                backdropFilter: "blur(10px)",
              }}
            >
              <CardMedia
                component="img"
                image={
                  hoveredCharacterId === character.id
                    ? character.attack
                    : character.walk
                }
                alt={`${character.name} ${hoveredCharacterId === character.id ? "Attacking" : "Walking"}`}
                sx={{ height: "250px", paddingTop: "2%" }}
              />
              <CardContent>
                <Typography variant="h6" sx={{ color: "white" }}>
                  {character.name}
                </Typography>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>
      <Button
        variant="contained"
        color="primary"
        sx={{ mt: 3 }}
        disabled={selectedCharacters.length !== 4}
        onClick={handleConfirm}
      >
        Confirm Selection
      </Button>
    </Box>
  );
};
