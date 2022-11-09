import React from 'react';

//Internal import
import Style from "../styles/index.module.css";
import { HeroSection, Services,BigNFTSilder,Subscribe } from '../components/comp_index';
const Home = () => {
  return(
    <div className= {Style.homePage}>
      <HeroSection/>
      <Services/>
      <BigNFTSilder/>
      <Subscribe/>
    </div>
  );
};
export default Home;