import React from 'react';
import Link from "next/link";

//Internal import
import Style from './helpcenter.module.css';
const Helpcenter = () => {
  const helpcenter = [
    {
      name: "About",
      link: "aboutus",
    },
    {
      name: "Contact Us",
      link: "contactus",
    },
    {
      name: "Sign Up",
      link: "signUp",
    },
    {
      name: "Login",
      link: "login",
    },
    {
      name: "Subscription",
      link: "subscription",
    },
  ];
  return (
    <div className={Style.box}>
      {helpcenter.map((el, i) => (
        <div className={Style.helpcenter} key={i + 1}>
          <Link href={{ pathname: `${el.link}` }}>{el.name}</Link>
        </div>
      ))}
    </div>
  );
};

export default Helpcenter;