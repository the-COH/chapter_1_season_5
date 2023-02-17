import React, { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";

import {
  player01 as player01Icon,
  player02 as player02Icon
} from "../assets";
import { Alert, Card, GameInfo, PlayerInfo } from "../components";
import { useGlobalContext } from "../context";
import styles from "../styles";

const Battle = () => {
  const {
    contract,
    gameData,
    walletAddress,
    showAlert,
    setShowAlert,
    battleGround,
    setErrorMessage,
    player1Ref,
    player2Ref,
  } = useGlobalContext();
  const [player1, setPlayer1] = useState({});
  const [player2, setPlayer2] = useState({});

  const { tokenId } = useParams();
  const navigate = useNavigate();

  useEffect(() => {
    const getPlayerInfo = async () => {
      try {
        let player01Address = null;
        let player02Address = null;

        if (
          gameData.activeBattle.players[0].toLowerCase() ===
          walletAddress.toLowerCase()
        ) {
          player01Address = gameData.activeBattle.players[0];
          player02Address = gameData.activeBattle.players[1];
        } else {
          player01Address = gameData.activeBattle.players[1];
          player02Address = gameData.activeBattle.players[0];
        }

        const player01 = await contract.getPlayer(player01Address);
        const player02 = await contract.getPlayer(player02Address);

        setPlayer1({
          ...player01,
        });
        setPlayer2({ ...player02 });
      } catch (error) {
        setErrorMessage(error);
      }
    };

    if (contract && gameData.activeBattle) getPlayerInfo();
  }, [contract, gameData, tokenId]);


  useEffect(() => {
    const timer = setTimeout(() => {
      if (!gameData?.activeBattle) navigate("/");
    }, 2000);

    return () => clearTimeout(timer);
  }, []);

  return (
    <div
      className={`${styles.flexBetween} ${styles.gameContainer} ${battleGround}`}
    >
      {showAlert?.status && <Alert type={showAlert.type} msg={showAlert.msg} />}

      <PlayerInfo player={player2} playerIcon={player02Icon} mt />

      <div className={`${styles.flexCenter} flex-col my-10`}>
        <Card
          card={player2}
          title={player2?.playerName}
          playerTwo
          cardRef={player2Ref}
        />

        <div className="flex items-center flex-row">
          <Card
            card={player1}
            title={player1?.playerName}
            playerOne
            cardRef={player1Ref}
            restStyles="mt-3"
          />

        </div>
      </div>

      <PlayerInfo player={player1} playerIcon={player01Icon} />

      <GameInfo />
    </div>
  );
};

export default Battle;
