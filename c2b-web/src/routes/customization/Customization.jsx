import React from 'react';
import { connect } from 'dva';
import style from './Customization.less';
import CustomizationNavBar from 'components/Customization/CustomizationNavBar';
import CustomizationComponents from 'components/Customization/CustomizationComponents';
import CustomizationBottomNav from "components/Customization/CustomizationBottomNav"
import {imgUrl} from "~/parameterConfig"
import Icon from "components/common/Icon/Icon"
import ShareImg from 'components/Customization/ShareImg'

import ReactImageMagnify from 'react-image-magnify';

class Customization extends React.Component {
  state={
    isOpen: false
  }
  onClose=()=>{
    this.setState({
      isOpen:false
    })
  }
  openViewer=()=>{
    this.setState({
      isOpen:true
    })
  }
  geturls=()=>{
    let array_ = []
    return array_.push(imgUrl+this.props.url)
  }
 render(){
  return (
    <div className = {style.customizationBox}>
      {/* 分享图片 */}
      <ShareImg shareImgURL={this.props.shareImgURL}/>
      <CustomizationNavBar />
      <div className={style.mainImg}>
        <div className={style.price}>
          <p className={style.priceValue}>￥{this.props.price}</p>
          <Icon name={`icon-jiagebiaoqian1`} />
        </div>
        {/* <span  onClick={this.openViewer}>
          <Icon newClass={style.magnify} name={`icon-fangda`}></Icon>
        </span> */}
        <ReactImageMagnify className={style.ImageMagnify} isActivatedOnTouch={true} {...{
          smallImage: {
              alt: 'Wristwatch by Ted Baker London',
              isFluidWidth: true,
              width:`100%`,
              height:`100%`,
              src: imgUrl+this.props.url
          },
          largeImage: {
              src: imgUrl+this.props.url,
              width: 2800,
              height: 4200
          }
      }} />

      </div>
      <div className={style.selectComponen}>
        <CustomizationComponents  />
      </div>
      <div className={style.bottomNav}>
        <CustomizationBottomNav urlParameter = {``} />
      </div>
    </div>
  );
 }
}
function mapStateToProps(state) {

  const {price, customizationComponent, productUserConfig, data,url,shareImgURL } = state.customization;
  return {
    price, customizationComponent, productUserConfig, data ,url,shareImgURL
  };
}
export default connect(mapStateToProps)(Customization);
