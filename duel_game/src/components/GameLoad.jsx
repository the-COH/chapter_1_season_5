import React from "react";
import { useNavigate } from "react-router-dom";
import { player01 } from "../assets";
import { useGlobalContext } from "../context";
import styles from "../styles";
import CustomButton from "./CustomButton";

const GameLoad = () => {
  const { walletAddress } = useGlobalContext();
  const navigate = useNavigate();

  return (
    <div className={`${styles.flexBetween} ${styles.gameLoadContainer}`}>
      <div className={styles.gameLoadBtnBox}>
        <CustomButton
          title="Choose Battleground"
          handleClick={() => navigate("/battleground")}
          restStyles="mt-6"
        />
      </div>

      <div className={`flex-1 ${styles.flexCenter} flex-col`}>
        <h1 className={`${styles.headText} text-center`}>
          Waiting for a <br /> worthy opponent....
        </h1>
        <p className={styles.gameLoadText}>
          While you're waiting, choose your preferred battleground
        </p>

        <div className={styles.gameLoadPlayersBox}>
          <div className={`${styles.flexCenter} flex-col`}>
            <img src={player01} className={styles.gameLoadPlayerImg} />
            <p className={styles.gameLoadPlayerText}>
              {walletAddress.slice(0, 30)}
            </p>
          </div>

          <h2 className={styles.gameLoadVS}>VS</h2>
          <div className={`${styles.flexCenter} flex-col`}>
            <img src={player01} className={styles.gameLoadPlayerImg} />
            <p className={styles.gameLoadPlayerText}>????????????</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default GameLoad;
