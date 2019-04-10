import React from 'react';
import { connect } from 'dva';
import {InputItem,Toast } from "antd-mobile"

import style from "./MeasureData.less"
import Icon from "components/common/Icon/Icon"
import Header from "components/common/Header/Header"
import onePNG from "assets/measureData/1.png"
import Cookie from '~/utils/cookie';

import height from "assets/measureData/height.png"
import weight from "assets/measureData/weight.png"
import frontlength from "assets/measureData/frontlength.png"
import backlength from "assets/measureData/backlength.png"
import shoulderwidth from "assets/measureData/shoulderwidth.png"
import bust from "assets/measureData/bust.png"
import downbust from "assets/measureData/downbust.png"
import abdominal from "assets/measureData/abdominal.png"
import waistline from "assets/measureData/waistline.png"
import hipline from "assets/measureData/hipline.png"
import sleevelength from "assets/measureData/sleevelength.png"
import wristline from "assets/measureData/wristline.png"
import pantslength from "assets/measureData/pantslength.png"
import crotch from "assets/measureData/crotch.png"
import kneeline from "assets/measureData/kneeline.png"
import uparmline from "assets/measureData/uparmline.png"

import { routerRedux } from 'dva/router';

class  MeasureDataList extends React.Component{
    onChange=(key)=>{
        
    }
    render(){
        return(
           ``
        )
    }
}

const listData =[
    {
        img:height,
        key:`height`,
        title:`身高`,
        unit:`cm`,
        value:0
    },
    {
        img:weight,
        title:`体重`,
        key:`weight`,
        unit:`kg`,
        value:0
    },
    {
        img:frontlength,
        key:`frontlength`,
        title:`前衣长`,
        unit:`cm`,
        unit:`cm`,
        value:0
    },
    {
        img:backlength,
        title:`后衣长`,
        key:`backlength`,
        unit:`cm`,
        value:0
    },
    {
        img:shoulderwidth,
        key:`shoulderwidth`,
        title:`总肩宽`,
        unit:`cm`,
        value:0
    },
    {
        img:bust,
        title:`胸围`,
        key:`bust`,
        unit:`cm`,
        value:0
    },
    {
        img:downbust,
        key:`downbust`,
        title:`下胸围`,
        unit:`cm`,
        value:0
    },
    {
        img:abdominal,
        title:`腹围`,
        key:`abdominal`,
        unit:`cm`,
        value:0
    },
    {
        img:waistline,
        title:`腰围`,
        key:`waistline`,
        unit:`cm`,
        value:0
    },
    {
        img:hipline,
        title:`臀围`,
        key:`hipline`,
        unit:`cm`,
        value:0
    },
    {
        img:sleevelength,
        title:`袖长`,
        key:`sleevelength`,
        unit:`cm`,
        value:0
    },
    {
        img:wristline,
        title:`手腕围`,
        key:`wristline`,
        unit:`cm`,
        value:0
    },
    {
        img:pantslength,
        title:`裤长`,
        key:`pantslength`,
        unit:`cm`,
        value:0
    },
    {
        img:kneeline,
        title:`膝围(净)`,
        key:`kneeline`,
        unit:`cm`,
        value:0
    },
    {
        img:uparmline,
        title:`上臂围`,
        key:`uparmline`,
        unit:`cm`,
        value:0
    },
    {
        img:crotch,
        title:`立裆`,
        key:`crotch`,
        unit:`cm`,
        value:0
    }
]

class MeasureData extends React.Component{
    constructor(props) {
        super(props);

        this.state= {
            phone:Cookie.get(`phone`),
            measureData:{
                height:``,
                weight:``,
                frontlength:``,
                backlength:``,
                shoulderwidth:``,
                bust:``,
                downbust:``,
                abdominal:``,
                waistline:``,
                hipline:``,
                sleevelength:``,
                wristline:``,
                pantslength:``,
                crotch:``,
                // uphipline:``,
                kneeline:``
            },
            key:``
        }
    
      }
      async saveMeasureData(measureData){
        const state = this.props.saveMeasureData(measureData)
        if(state){
            Toast.info(`保存成功！`)
        }
      }
      componentWillReceiveProps=(nextProps)=> {
        if (nextProps.measureData !== this.props.measureData) {
            this.setState({
              measureData:nextProps.measureData
            });
        }
      }
      onChange=(value)=>{
          let keyValue = this.state.key
          let json = this.state.measureData
          json[keyValue] = value
        this.setState({
            measureData:json
        })
        }
        getKey=(key)=>{
            console.log(this.state.measureData)
            this.setState({
                key:key
            })
        }
        back= ()=>{
            this.props.clearInterval()
            history.go(-1);
          }
      render(){
            return (
                <div className={style.measureData}>
                    {
                        this.props.stateData?
                        <span className={style.loading}>正在获取量体数据...</span>:null
                    }
                    <Header title={`尺码表`} 
                    leftContent={
                        <div onClick={()=>{this.back()}}><Icon name={`icon-zuojiantou-xuanzezitihecixiu1`} /></div>
                    }
                     rightContent={<span className={style.save} onClick={()=>{this.saveMeasureData(this.state.measureData)}}>保存</span>}></Header>
                    <div className={`flexBox ${style.upData}`}>
                        <div className={`flexBox ${style.imgData}`}>
                            <div className={style.userImg}>
                                <img src={onePNG} alt=""/>
                            </div>
                            <span className={`flex1 overflowText ${style.name}`}>
                            {this.state.phone}
                            </span>
                        </div>
                        <div className={`flex1`}>
                            {/* <span className={style.title}>身高：</span>
                            <span  className={style.text}>12</span>
                            <span className={style.title}>体重：</span>
                            <span  className={style.text}>12</span> */}
                            <span onClick={()=>{this.props.setData()}}>
                                <Icon name={`icon-shuaxin`}></Icon>
                            </span>
                        </div>
                    </div>
                    <div className ={style.listBox}>
                        <div className={`${style.listTitle}`}>
                            <div className={style.iconTitle}>量体部位</div>
                            <div className={style.textTitle}>量体数据</div>
                        </div>
                        {
                            listData.map((obj)=>{
                                // return(<MeasureDataList list={obj} measureData={this.state.measureData}></MeasureDataList>)
                                return(
                                    <div className={`flexBox ${style.measureDataList}`}>
                                        <div className={`flex1 flexBox ${style.icon}`}>
                                            <div className={style.imgBox}>
                                                <img src={obj.img} alt=""/>
                                            </div>
                                            <span className={`flex1`}>{obj.title}</span>
                                        </div>
                                        <div className={`flexBox ${style.inputBox}`}>
                                            <div className={`flex1`}>
                                                <InputItem
                                                    type="money"
                                                    onFocus={()=>{this.getKey(obj.key)}}
                                                    onChange={this.onChange}
                                                    value={this.state.measureData[obj.key]}
                                                ></InputItem>
                                            </div>
                                            <span className={style.unit}>{obj.unit}</span>
                                        </div>
                                </div>
                                )
                            })
                        }
                    </div>
                </div>
            )
        }
}
const mapStateToProps = (state)=>{
    const {measureData,stateData} = state.measureData;
    return {
        measureData,
        stateData
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
        setKey:(key,value)=>{
            dispatch({ type: 'measureData/setKey',payload: { key, value }});
        },
        getMeasureData:()=>{
            dispatch({ type: 'measureData/getMeasureData' })
        },
        setData:()=>{
            dispatch({ type: 'measureData/setData' })
        },
        saveMeasureData:(measureData)=>{
           
           return dispatch({ type: 'measureData/saveMeasureData',payload:measureData})
        },
        clearInterval:()=>{
            dispatch({ type: 'measureData/clearInterval'})
        }
    }
}
export default connect(mapStateToProps,mapDispatchToProps)(MeasureData);
