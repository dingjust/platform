import React from 'react';
import { connect } from 'dva';
import style from "./MeasureSelect.less"
import Icon from "components/common/Icon/Icon"
import Header from "components/common/Header/Header"
import onePNG from "assets/measureData/1.png"
import twoPNG from "assets/measureData/2.png"
import threePNG from "assets/measureData/3.png"
import fourPNG from "assets/measureData/4.png"
import banner from "assets/measureData/banner.png"
import { routerRedux } from 'dva/router';

import CommonFn from "components/common/CommonFn/CommonFn"


class  MeasureList extends React.Component{
    render(){
        return(
            <div className={`flexBox ${style.measureList}`} onClick={()=>{this.props.goLinke(this.props.list.url)}}>
                <div className={style.listImg}>
                    {(() => {
                        switch (this.props.list.weight) {
                            case 1:
                            return <span className={`${style.weight} ${style.one}`}>容易</span>
                            case 2:
                            return <span className={`${style.weight} ${style.two}`}>中等</span>
                            case 3:
                            return <span className={`${style.weight} ${style.three}`}>困难</span>
                            default:
                            return null
                        }
                        }
                        )()}
                    <img src={this.props.list.img} alt=""/>
                </div>
                <div className={`flex1 pr`}>
                    <p className={style.listTitle}>{this.props.list.title}</p>
                    <p className={style.listTime}>
                        <Icon name={`icon-shijian`}></Icon>
                        {this.props.list.time}
                    </p>
                    <p className={style.explain}>{this.props.list.explain}</p>
                </div>
            </div>
        )
    }
}

const listData =[
    {
        img:onePNG,
        url:`measureState`,
        title:`量体机器`,
        time:`2Min`,
        weight:1,
        explain:`穿好专用量体衣服直接扫描量体即可`
    },
    {
        img:twoPNG,
        url:undefined,
        title:`表格录入`,
        weight:3,
        time:`15Min`,
        explain:`根据身体部位名称输入尺码`
    },
    {
        img:threePNG,
        url:undefined,
        title:`指引录入`,
        time:`12Min`,
        weight:2,
        explain:`根据人体模型提示输入尺码`
    }
    ,
    {
        img:fourPNG,
        url:undefined,
        title:`现有衣服尺寸`,
        time:`12Min`,
        weight:2,
        explain:`根据衣服的部位提示输入尺码`
    }
]

class MeasureSelect extends CommonFn{
    constructor(props) {
        super(props);
        this.state={
          type:this.getQurey(location.hash).selectedTab,
        }
      }
      render(){
            return (
                <div className={style.measureSelect}>
                    <Header leftContent={this.state.type!=undefined?"":null} title={`量体`}></Header>
                    <div className={style.banner}>
                        <img src={banner} alt="banner"/>
                    </div>
                    <div className ={style.listBox}>
                        {
                            listData.map((obj)=>{
                               return(
                                <MeasureList list={obj} goLinke={this.props.goLinke}></MeasureList>
                               )
                            })
                        }
                    </div>
                </div>
            )
        }
}
const mapStateToProps = (state)=>{
    return{

    }
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
        }
    }
}
export default connect(mapStateToProps,mapDispatchToProps)(MeasureSelect);
