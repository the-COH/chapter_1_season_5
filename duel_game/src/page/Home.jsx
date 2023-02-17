import React, { useState, useEffect } from "react";
import { useGlobalContext } from "../context";
import { useNavigate } from "react-router-dom";

import { PageHOC, CustomInput, CustomButton } from "../components";

const Home = () => {
  const { contract, walletAddress, setShowAlert, gameData, setErrorMessage } =
    useGlobalContext();
  const [playerTokenId, setPlayerTokenId] = useState("");

  const navigate = useNavigate();

  const handleClick = async () => {
    navigate("/create-battle");
  };


  useEffect(() => {
    if (gameData.activeBattle) {
      navigate(`/battle/${gameData.activeBattle.name}`);
    }
  }, [gameData]);

  return (
    <div className="flex flex-col">
      <CustomButton
        title="Host Duel"
        handleClick={handleClick}
        restStyles="mt-6"
      />
    </div>
  );
};

export default PageHOC(
  Home,
  <>
    cypher skull duels<br />
  </>,
  <>
    connect your wallet with Canto to enter
  </>
);
