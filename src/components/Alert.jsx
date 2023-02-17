import React from "react";
import { AlertIcon } from "../assets";
import styles from "../styles";

const Alert = ({ type, msg }) => {
  return (
    <div className={`${styles.alertContainer} ${styles.flexCenter}`}>
      <div className={`${styles.alertWrapper} ${styles[type]}`}>
        <AlertIcon type={type} /> {msg}
      </div>
    </div>
  );
};

export default Alert;
