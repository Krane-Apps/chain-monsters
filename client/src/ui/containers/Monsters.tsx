import { useDojo } from "@/dojo/useDojo";
import { useGame } from "@/hooks/useGame";
import { useMonsters } from "@/hooks/useMonsters";
import { usePlayer } from "@/hooks/usePlayer";

export const Monsters = () => {
  const {
    account: { account },
  } = useDojo();

  const { player } = usePlayer({ playerId: account?.address || "0x0" });
  const { game } = useGame({ gameId: player?.game_id || 0 });
  const { monsters } = useMonsters({ gameId: player?.game_id || 0 });

  if (!player || !game || game.isOver() || !monsters || monsters.length == 0)
    return null;

  return (
    <div className="flex flex-col items-center">
      <h2>Monsters</h2>
      {monsters.map((monster) => (
        <div key={`${monster.team_id}${monster.id}`} className="flex gap-2">
          <p>{` [Team ${monster.team_id}] ID ${monster.id} at (${monster.x},${monster.y})`}</p>
        </div>
      ))}
    </div>
  );
};
