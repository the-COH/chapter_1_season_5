import ReactToolTip from "react-tooltip";

import styles from "../styles";

function PlayerInfo({ player, playerIcon, mt }) {
  return (
    <div className={`${styles.flexCenter} ${mt ? "mt-4" : "mb-4"}`}>
      <img
        data-for={`Player-${mt ? "1" : "2"}`}
        data-tip
        src={playerIcon}
        alt="player02"
        className="w-14 h-14 object-contain rounded-full" />

      <ReactToolTip
        id={`Player-${mt ? "1" : "2"}`}
        backgroundColor="#74f46f0"
        effect="solid"
      >
        <p className={styles.playerInfo}>
          <span className={styles.playerInfoSpan}>Name: </span>{" "}
          {player?._id}
        </p>
        <p className={styles.playerInfo}>
          <span className={styles.playerInfoSpan}>Address: </span>{" "}
          {player?.playerAddress?.slice(0, 10)}
        </p>
      </ReactToolTip>
    </div>
  );
}

export default PlayerInfo;
