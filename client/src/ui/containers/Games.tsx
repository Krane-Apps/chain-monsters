import { useGames } from "@/hooks/useGames";

export const Games = () => {
  const { games } = useGames();

  return (
    <div>
      <h2>Games</h2>
      {games.map((game) => (
        <div key={game.id}>
          <div>{game.id}</div>
        </div>
      ))}
    </div>
  );
};
