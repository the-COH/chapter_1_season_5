import React from "react";
import { useNavigate } from "react-router-dom";

import styles from "../styles";
import { Alert } from "../components";
import { battlegrounds } from "../assets";
import { useGlobalContext } from "../context";

const Battleground = () => {
  const { setShowAlert, showAlert, setBattleGround } = useGlobalContext();

  const navigate = useNavigate();

  const handleBattleGroundChoice = (bg) => {
    setBattleGround(bg.id);

    localStorage.setItem("battleGround", bg.id);

    setShowAlert({
      status: true,
      type: "info",
      msg: `You have chosen ${bg.name} as your battleground`,
    });

    setTimeout(() => {
      navigate(-1);
    }, 1000);
  };

  return (
    <div className={`${styles.flexCenter} ${styles.battlegroundContainer}`}>
      {showAlert?.status && <Alert type={showAlert.type} msg={showAlert.msg} />}
      <h1 className={`${styles.headText} text-center`}>
        Choose your
        <span className="text-siteViolet"> Battle </span>
        Ground
      </h1>

      <div className={`${styles.flexCenter} ${styles.battleGroundsWrapper}`}>
        {battlegrounds.map((bg) => (
          <div
            key={bg.id}
            className={`${styles.flexCenter} ${styles.battleGroundCard}`}
            onClick={() => handleBattleGroundChoice(bg)}
          >
            <img
              src={bg.image}
              alt="bg"
              className={styles.battleGroundCardImg}
            />
            <div className="info absolute">
              <p className={styles.battleGroundCardText}>{bg.name}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Battleground;
