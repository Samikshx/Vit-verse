import React, {useState, useEffect, useContext} from 'react';
import Image from 'next/image';
import Link from 'next/link';

//import icons
import {MdNotifications} from 'react-icons/md';
import {BsSearch} from 'react-icons/bs';
import {CgMenuLeft, CgMenuRight} from "react-icons/cg";

//internal import
import Style from "./navbar.module.css";
import {Discover, Helpcenter,Profile,Sidebar, Notification} from './index';
import {Button} from "../comp_index";
import images from '../../img';

import { NFTMarketplaceContext } from '../../Context/NFTMarketplaceContext';

const NavBar = () => {
  //usestate
  const [discover,setDiscover] = useState(false);
  const [help, setHelp] = useState(false);
  const [notification, setNotification] = useState(false);
  const [profile,setProfile] = useState(false);
  const [openSideMenu, setOpenSideMenu] = useState(false);
  
  const openMenu = (e)=>{
    const btnText = e.target.innerText;
    //console.log(e.target.innerHTML)
    if(btnText =="Discover"){
      setDiscover(true);
      setHelp(false);
      setNotification(false);
      setProfile(false);
    } 
    else if(btnText == "Help Center"){
      setDiscover(false);
      setHelp(true);
      setNotification(false);
      setProfile(false);
    }
    else {
      setDiscover(false);
      setHelp(false);
      setNotification(false);
      setProfile(false);
    }
  };

  const openNotification = ()=>{
    console.log("inside notification");
    if(!notification){
      setNotification(true);
      setDiscover(false);
      setHelp(false);
      setProfile(false);
    }
    else{
      setNotification(false);
    }
  };

  const openProfile = () => {
    if (!profile) {
      setProfile(true);
      setHelp(false);
      setDiscover(false);
      setNotification(false);
    } else {
      setProfile(false);
    }
  };

  const openSideBar = () => {
    if (!openSideMenu) {
      setOpenSideMenu(true);
    } else {
      setOpenSideMenu(false);
    }
  };
  
  const  {currentAccount, connectWallet} = useContext(NFTMarketplaceContext);

  return (
    <div className= {Style.navbar}>
      <div className={Style.navbar_container}>
        <div className ={Style.navbar_container_left}>
          <div className ={Style.logo}>
            <Image src= {images.vitverselogo} alt="NFT MARKETPLACE" width ={140} height={100}/>
          </div>
          <div className={Style.navbar_container_left_box_input}>
            <div className = {Style.navbar_conatiner_left_box_input_box}>
            <input type="text" placeholder="Search NFT" />
              <BsSearch onClick={() => {}} className={Style.search_icon}/>
            </div>
          </div>
        </div>
        {/* //END OF LEFT SECTION */}

        <div className ={Style.navbar_container_right}>
          <div className ={Style.navbar_container_right_discover}>
            {/* DISCOVER MENU */}
            <p onClick={(e) =>openMenu(e)}>Discover</p>
            {discover &&(<div className ={Style.navbar_container_right_discover_box}>
              <Discover/>
            </div>
            )}  
          </div>
          
          {/* HELP CENTER MENU */}
          <div className={Style.navbar_container_right_help}>
            <p onClick={(e) =>openMenu(e)}>Help Center</p>
            {help &&( <div className={Style.navbar_container_right_help_box}>
                <Helpcenter/>
              </div>
            )}
          </div>

          {/* NOTIFICATION */}
          <div className={Style.navbar_container_right_notify}>
            <MdNotifications className={Style.notify} onClick={openNotification}/>
            {notification && <Notification/>}
          </div>

          {/* CREATE BUTTON SECTION */}
          <div className={Style.navbar_container_right_button}>
            {currentAccount == "" ? (
              <Button btnName="Connect" handleClick={() => connectWallet()} />
            ) : (
              <a href={{pathname: "/"}}>
              <Button btnName="Create" handleClick={()=>{}}/></a>
              
            )}
          </div>

          {/* USER PROFILE */}
          <div className={Style.navbar_container_right_profile_box}>
            <div className={Style.navbar_container_right_profile}>
              <Image src={images.sam} alt="Profile" width={40} height={40} onClick={()=> openProfile()} className={Style.navbar_container_right_profile}/>

              {profile && <Profile/>}
            </div>
          </div>

          {/* MENU BUTTON */}
          <div className={Style.navbar_container_right_menuBtn}>
            <CgMenuRight
              className={Style.menuIcon}
              onClick={() => openSideBar()}
            />
          </div>
        </div>
    </div>
    {/* SIDBAR CPMPONE/NT */}
    {openSideMenu && (
        <div className={Style.sideBar}>
          <Sidebar
            setOpenSideMenu={setOpenSideMenu}
          />
        </div>
      )}
  </div>
  );
};

export default NavBar;