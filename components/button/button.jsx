import React from 'react';
import Style from "./button.module.css";
const Button = ({btnName,handleClick}) => {
  return (
    <div className={Style.box}>
      {console.log(btnName)}
      <button className={Style.button} onClick={() => handleClick()}>
        {btnName}
      </button>
    </div>
  );
};

export default Button;