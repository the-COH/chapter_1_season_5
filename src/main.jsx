import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter, Route, Routes } from "react-router-dom";

import { OnboardModal } from "./components";

import { GlobalContextProvider } from "./context";
import "./index.css";
import { Battle, Battleground, CreateBattle, Home, JoinBattle } from "./page";

ReactDOM.createRoot(document.getElementById("root")).render(
  <BrowserRouter>
    <GlobalContextProvider>
      <OnboardModal />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/create-battle" element={<CreateBattle />} />
        <Route path="/join-battle" element={<JoinBattle />} />
        <Route path="/battle/:tokenId" element={<Battle />} />
        <Route path="battleground" element={<Battleground />} />
      </Routes>
    </GlobalContextProvider>
  </BrowserRouter>
);
