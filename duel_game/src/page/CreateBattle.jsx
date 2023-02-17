import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import styles from "../styles";
import { useGlobalContext } from "../context";

import { PageHOC, CustomButton, CustomRadio, CustomInput, GameLoad } from "../components";

const CreateBattle = () => {
  const { contract, tokenId, setTokenId, gameData } = useGlobalContext();
  const [waitBattle, setWaitBattle] = useState(false);
  const [value, setValue] = useState(0);

  const navigate = useNavigate();

  useEffect(() => {
    if (gameData?.activeBattle?.battleStatus === 1) {
      navigate(`/battle/${gameData.activeBattle.name}`);
    } else if (gameData?.activeBattle?.battleStatus === 0) {
      setWaitBattle(true);
    }
  }, [gameData]);

  const handleClick = async () => {
    if (!tokenId) return null;

    try {
      await contract.startGame(tokenId, {
        gasLimit: 2000000,
      });

      setWaitBattle(true);
    } catch (error) {
      console.log(error);
    }
  };

  return (
    <>
      {waitBattle && <GameLoad />}
      <div className="flex flex-col mb-5">
        <CustomInput
          label="Duel"
          placeholder="Enter Cypher Skull ID"
          value={tokenId}
          onChange={setTokenId}
        />

        <CustomRadio
          label="Wagered $CANTO"
          value={5}
          onChange={setValue}
        />
        <br></br>
        <CustomButton
          title="Host Duel"
          handleClick={handleClick}
          restStyles="mt-6"
        />

        <p
          className={`${styles.infoText} mt-4`}
          onClick={() => navigate("/join-battle")}
        >
          Or take on an existing duel.
        </p>
      </div>
    </>
  );
};

export default PageHOC(
  CreateBattle,
  <>
    Host <br /> a new Duel
  </>,
  <>Host a duel and wager some $CANTO, and wait for someone to take you on.</>
);
