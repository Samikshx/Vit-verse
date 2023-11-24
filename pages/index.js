import React, { useState,useEffect, useContext } from 'react';

//Internal import
import Style from "../styles/index.module.css";
import { HeroSection, Services,BigNFTSilder,Subscribe,Title, Category ,Filter,Collection, NFTcard,FollowerTab,DayComponents,Brand} from '../components/comp_index';
import { NFTMarketplaceContext } from '../Context/NFTMarketplaceContext';
const Home = () => {
  const {checkIfWalletConnected} = useContext(NFTMarketplaceContext);
  useEffect(()=>{
    checkIfWalletConnected()
  }, []);
  return(
    <div className= {Style.homePage}>
      <HeroSection/>
      <Services/>
      <BigNFTSilder/>
      <Title heading="New Collection" paragraph="Discover the most outstanding NFTs in all topics of life."/>
      <Filter/>
      <NFTcard/>
      <Title heading="Browse by category" paragraph="Explore the NFTs in the most featured categories."/>
      <DayComponents/>
      <Collection/>
      <FollowerTab/>
      <Title heading="Browse by category" paragraph="Explore the NFTs in the most featured categories."/>
      <Category/>
      <Brand/>
      <Subscribe/>
    </div>
  );
};
export default Home;