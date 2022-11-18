import React from "react";
import Image from "next/image";
import { MdVerified } from "react-icons/md";

//INTERNAL IMPORT
import Style from "./DayComponents.module.css";
import images from "../../../img";

const DayComponents = ({el,i}) => {
  return (
    <div className={Style.daysComponent}>
      {el!=undefined &&
      <div className={Style.daysComponent_box}>
      <div className={Style.daysComponent_box_img}>
        <Image
          src={el.background}
          className={Style.daysComponent_box_img_img}
          alt="profile background"
          width={400}
          height={300}
          objectFit="covers"
        />
      </div>

      <div className={Style.daysComponent_box_profile}>
        <Image
          src={images.creatorbackground2}
          alt="profile"
          width={130}
          height={130}
          className={Style.daysComponent_box_img_1}
          objectFit="covers"
        />
        <Image
          src={images.creatorbackground1}
          alt="profile"
          width={130}
          height={130}
          className={Style.daysComponent_box_img_2}
          objectFit="covers"
        />
        <Image
          src={images.creatorbackground3}
          alt="profile"
          width={130}
          height={130}
          className={Style.daysComponent_box_img_3}
          objectFit="covers"
        />
      </div>

      <div className={Style.daysComponent_box_title}>
        <h2>Amazing Collection</h2>
        <div className={Style.daysComponent_box_title_info}>
          <div className={Style.daysComponent_box_title_info_profile}>
            <Image
              src={el.user}
              alt="profile"
              width={30}
              height={30}
              objectFit="covers"
              className={Style.daysComponent_box_title_info_profile_img}
            />

            <p>
              Creator
              <span>
                Samiksha 
                <small>
                  <MdVerified />
                </small>
              </span>
            </p>
          </div>

          <div className={Style.daysComponent_box_title_info_price}>
            <small>255 ETH</small>
          </div>
        </div>
      </div>
    </div>
      }
    </div>
  );
};

export default DayComponents;