import React from "react";
import Tilt from "react-parallax-tilt";

import { allCards } from "../assets";
import styles from "../styles";

function generateCardImage() {
  return allCards[Math.floor(Math.random() * (allCards.length - 1))];
}

const img1 = generateCardImage();
const img2 = generateCardImage();

const Card = ({ card, title, restStyles, cardRef, playerTwo }) => {
  return (
    <Tilt>
      <div ref={cardRef} className={`${styles.cardContainer} ${restStyles}`}>
        <img
          src={playerTwo ? img2 : img1}
          alt="card"
          className={`${styles.cardImg}`}
        />

        <div
          className={`${styles.cardPointContainer} sm:left-[21.2%] left-[22%] ${styles.flexCenter}`}
        >
          <p className={`${styles.cardPoint} text-yellow-400`}>{card.att}</p>
        </div>

        <div
          className={`${styles.cardPointContainer} sm:right-[14.2%] right-[15%] ${styles.flexCenter}`}
        >
          <p className={`${styles.cardPoint} text-red-700`}>{card.def}</p>
        </div>

        <div className={`${styles.cardTextContainer} ${styles.flexCenter}`}>
          <p className={styles.cardText}>{title}</p>
        </div>
      </div>
    </Tilt>
  );
};

export default Card;
