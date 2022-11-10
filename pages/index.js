import React from 'react';

//Internal import
import Style from "../styles/index.module.css";
import { HeroSection, Services,BigNFTSilder,Subscribe,Title } from '../components/comp_index';
const Home = () => {
  return(
    <div className= {Style.homePage}>
      <HeroSection/>
      <Services/>
      <BigNFTSilder/>
      <Subscribe/>
      <Title heading="Browse by category" paragraph="Explore the NFTs in the most featured categories."/>
    </div>
  );
};
export default Home;