import React, { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { CustomButton, PageHOC } from "../components";
import { useGlobalContext } from "../context";
import styles from "../styles";

const JoinBattle = () => {
  const {
    contract,
    gameData,
    setShowAlert,
    setTokenId,
    walletAddress,
    setErrorMessage,
  } = useGlobalContext();

  useEffect(() => {
    if (gameData?.activeBattle?.battleStatus === 1)
      navigate(`/battle/${gameData.activeBattle.name}`);
  }, [gameData]);

  const navigate = useNavigate();

  const handleClick = async (tokenId) => {
    setTokenId(tokenId);

    try {
      await contract.joinBattle(tokenId, {
        gasLimit: 2000000,
      });

      setShowAlert({
        status: true,
        type: "success",
        msg: `Joining ${tokenId}`,
      });

      navigate(`/battle/${tokenId}`);
    } catch (error) {
      setErrorMessage(error);
    }
  };

  return (
    <>
      <h2 className={styles.joinHeadText}>Available Battles:</h2>

      <div className={styles.joinContainer}>
        {gameData.pendingBattles.length ? (
          gameData.pendingBattles
            .filter(
              (battle) =>
                !battle.players.includes(walletAddress) &&
                battle.battleStatus !== 1
            )
            .map((battle, index) => (
              <div key={battle.name + index} className={styles.flexBetween}>
                <p className={styles.joinBattleTitle}>
                  {index + 1}. {battle.name}
                </p>
                <CustomButton
                  title="Join"
                  handleClick={() => handleClick(battle.name)}
                />
              </div>
            ))
        ) : (
          <p className={styles.joinLoading}>
            Reload the page to see new battles
          </p>
        )}
      </div>

      <p className={styles.infoText} onClick={() => navigate("/create-battle")}>
        Or create a new battle
      </p>
    </>
  );
};

export default PageHOC(
  JoinBattle,
  <>
    Join <br /> a Battle
  </>,
  <>Join already existing battles</>
);
