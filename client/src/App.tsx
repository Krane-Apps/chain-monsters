import "./App.css";
import { Account } from "./ui/components/Account";
import { Spawn } from "./ui/actions/Spawn";
import { Create } from "./ui/actions/Create";
import { Monsters } from "./ui/containers/Monsters";
import { Move } from "./ui/actions/Move";
import { MonsterSelection } from "./components/monster-selection";
import { SelectedCharacter } from "./helpers/types";

function App() {
  const handleConfirm = (selectedCharacters: SelectedCharacter[]) => {
    console.log("Selected Characters:", selectedCharacters);
  };
  return (
    <div className="flex flex-col gap-4">
      <h1>Chain Monsters</h1>
      <Account />
      <Spawn />
      <Create />
      <Monsters />
      <Move />
      <MonsterSelection onConfirm={handleConfirm} />
    </div>
  );
}

export default App;
