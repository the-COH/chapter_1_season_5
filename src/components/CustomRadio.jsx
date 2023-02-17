import React from "react";
import styles from "../styles";


const CustomRadio = ({ label, value, onChange }) => {
  return (
    <div>
    <label htmlFor="name" className={styles.label}>
      {label}
    </label>
    <div className={`${styles.input} ml-4`}>

      <label>
        <input type="radio" name="radio-group" value="5" onChange={() => onChange(e.target.value)} />
        <span className={styles.radio}>5</span>
      </label>

      <label>
        <input type="radio" name="radio-group" value="25" onChange={() => onChange(e.target.value)} />
        <span className={styles.radio}>25</span>
      </label>

      <label>
        <input type="radio" name="radio-group" value="50"onChange={() => onChange(e.target.value)} />
        <span className={styles.radio}>50</span>
      </label>

      <label>
        <input type="radio" name="radio-group" value="100" onChange={() => onChange(e.target.value)} />
        <span className={styles.radio}>100</span>
      </label>

    </div>
  </div>
  );
};

export default CustomRadio;
