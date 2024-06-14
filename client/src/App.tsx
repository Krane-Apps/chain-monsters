import "./App.css";
import { Account } from "./ui/components/Account";
import { Spawn } from "./ui/actions/Spawn";
import { Create } from "./ui/actions/Create";
import { Games } from "./ui/containers/Games";
import { Start } from "./ui/actions/Start";

function App() {
  return (
    <div className="flex flex-col gap-4">
      <h1>Chain Monsters</h1>
      <Account />
      <Spawn />
      <Create />
      <Games />
      <Start gameId={1} />
    </div>
  );
}

export default App;
