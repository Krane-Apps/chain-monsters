import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import "./index.css";
import { setup } from "./dojo/setup.ts";
import { DojoProvider } from "./dojo/context.tsx";
import { dojoConfig } from "../dojo.config.ts";
import { Toaster } from "@/ui/elements/ui/sonner";

async function init() {
  const rootElement = document.getElementById("root");
  if (!rootElement) throw new Error("React root not found");
  const root = ReactDOM.createRoot(rootElement as HTMLElement);

  // const setupResult = await setup(dojoConfig());

  root.render(
    <React.StrictMode>
      {/* <DojoProvider value={setupResult}> */}
      <App />
      <Toaster />
      {/* </DojoProvider> */}
    </React.StrictMode>
  );
}

init();
