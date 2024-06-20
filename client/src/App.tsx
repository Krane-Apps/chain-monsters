import "./App.css";
import { Account } from "./ui/components/Account";
import { Spawn } from "./ui/actions/Spawn";
import { Create } from "./ui/actions/Create";
import { Monsters } from "./ui/containers/Monsters";
import { Move } from "./ui/actions/Move";
import { Surrender } from "./ui/actions/Surrender";

function App() {
  return (
    <div className="flex flex-col gap-4">
      <h1>Chain Monsters</h1>
      <Account />
      <Spawn />
      <Create />
      <Monsters />
      <Move />
      <Surrender />
    </div>
  );
}

export default App;
