import React from 'react';
import { connect } from 'dva';
import style from "./MeasureState.less"
import Icon from "components/common/Icon/Icon"
import Header from "components/common/Header/Header"
import sb from "assets/measureData/sb.png"
import {Toast } from "antd-mobile"
import {durationTime} from "~/parameterConfig"

import { routerRedux } from 'dva/router';

class MeasureSelect extends React.Component{
        state = {

      }
      getText(state){
          switch(state){
            case 0:
            return `正在启动量体设备...`;
            case 1:
            return `开始测量`;
          }
      }
      btFn(){
          if(this.props.stateText == 0){
              return `${style.bt} ${style.forbid}`
          }else{
            return `${style.bt}`
          }
      }
      componentWillReceiveProps=(nextProps)=> {
        // if (nextProps.stateText !== this.props.stateText) {
        //     if(nextProps.stateText == 2){
                
        //     }
        // }
      }
     async selectNext(state){
        //   if(state == 1){
           const returnSatate = await this.props.getFacility()
           console.log(returnSatate)
           if(returnSatate){
            this.props.goLinke(`measureData`)
           }else{
            Toast.fail(<span style={{color:`#fff`}}>请检查量体设备<br/>或选择其他量体方式</span>)
           }
        //   }
      }
      render(){
            return (
                <div className={style.measureState}>
                    <Header title={`量体机器`}></Header>
                    <div className={style.userImg}>
                        <img src={sb} alt="userImg"/>
                    </div>
                    <div className={style.guidanceText}>
                        <p>请身穿量体服，进入到测量位置双手握拳、</p>
                        <p>自然站立，手臂稍微展开，不要紧贴身体。</p>
                        <p>请先进入到测量位置再按“开始测量”。</p>
                    </div>
                    <a href="javascript:;" className={this.btFn()} onClick={()=>{this.selectNext(this.props.stateText)}}>{this.getText(this.props.stateText)}</a>
                </div>
            )
        }
}
const mapStateToProps = (state)=>{
    const {stateText} = state.measureData;
    return {
        stateText
    };
}
const mapDispatchToProps = (dispatch) => {
    return {
        goLinke:(url,params)=>{
            if(url){
                dispatch(routerRedux.push({
                    pathname: url,
                    search:params
                }));
            }
        },
        getFacility:()=>{
           return  dispatch({type:'measureData/getFacility'});
            
        }
    }
}
export default connect(mapStateToProps,mapDispatchToProps)(MeasureSelect);
