import React from "react";
import styles from "../styles";

// all numbers starting from 1-1337 -- id validation
const regex = new RegExp("\\b(1[0-9]{0,2}|2[0-9]{0,2}|3[0-3][0-9]{0,1}|133[0-7]1337)\\b");

const CustomInput = ({ label, placeholder, value, onChange }) => {
  return (
    <div>
      <label htmlFor="name" className={styles.label}>
        {label}
      </label>
      <input
        type="text"
        placeholder={placeholder}
        value={value}
        onChange={(e) => {
          if (e.target.value === "" || regex.test(e.target.value))
            onChange(e.target.value);
        }}
        className={`${styles.input} ml-4`}
      />
    </div>
  );
};

export default CustomInput;
