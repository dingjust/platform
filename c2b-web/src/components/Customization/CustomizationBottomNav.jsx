import React from "react"
import Icon from "components/common/Icon/Icon"
import { Toast } from 'antd-mobile';
import { connect } from 'dva';
import style from "./CustomizationBottomNav.less"
import store from '~/index'
import { routerRedux } from 'dva/router';
import { durationTime } from '~/parameterConfig';
import queryString from 'query-string';

// icon
// import index_ from "assets/customization/index.png"
// import liangti from "assets/customization/liangti.png"
// import shoucang from "assets/customization/shoucang.png"
// import cart from "assets/customization/cart.png"

const { dispatch } = store;
class TabBarItem extends React.Component{
    state={
        navList:[
            {
                icon:`icon-dibu-shouye1`,
                name:`首页`,
                hover:``,
                url:`/`,
                key:`index`,
                color:'#2F8AFF'
            },
            {
                icon:`icon-liangti`,
                name:`量体`,
                hover:`icon-liangtishuju-xuanzhong`,
                url:`measureSelect`,
                key:`measurement`,
                color:'#2F8AFF'
    
            },
            {
                icon:`shoucang`,
                class:`collect`,
                type:'animation',
                name:`收藏`,
                hover:`icon-shoucangdianjixiaoguo`,
                url:undefined,
                key:`collect`,
                color:'#2F8AFF'
            },
            {
                icon:`icon-dibu-gouwudai1`,
                name:`购物袋`,
                hover:`icon-gouwudai-xuanzhong`,
                url:`shoppingCart`,
                key:`shopping`,
                color:'#2F8AFF',
                search:1
            }
        ]
    }
    goUrl=(obj,index)=>{
        if(obj.url){
            const params = queryString.stringify({ type:1 });
            dispatch(routerRedux.push({
                pathname: obj.url,
                search:obj.params
            }));
        }
        if(obj.type&&obj.type == `animation`){
            this.addAnimaiton(index)
        }
    }
    addAnimaiton(index){
       let data = this.state.navList
       data[index].class = `${data[index].key}-animation ${data[index].key}`;
       this.setState({
        navList:data
       })
       setTimeout(async()=>{
            this.rmAnimaiton(index);
            let state = await this.props.addCollect()
            if(state){
                Toast.success('收藏成功！',durationTime);
            }
        },700)
    }
    rmAnimaiton(index){
        let data = this.state.navList
        data[index].class = `${data[index].key}`;
        this.setState({
            navList:data
        })
    }
    render(){
        return(
            <div className={`flexBox ${style.tabBarItem}`}>
              {
                this.state.navList.map((obj,index)=>{
                    return(
                        <div className={`flex1 pr`} onClick={()=>{this.goUrl(obj,index)}}>
                            {
                                obj.type!=`animation`?<Icon newClass = {style.blue} name={obj.icon}/>:<span className={obj.class}></span>
                            }
                            <p className={style.title} style={{color:obj.color}}>{obj.name}</p>
                        </div>
                    )
                })
              }
                
            </div>
        )
    }
}

class CustomizationBottomNav extends React.Component{
   
    
    render(){
        return(
            <div className={`flexBox ${style.customizationBottomNav}`}>
                <div className={`flex2`}>
                        <TabBarItem addCollect={this.props.addCollect}/>
                </div>
                <div  className={`flex1 flexBox`}>
                    {
                        this.props.entryNumber==``||this.props.entryNumber.entryNumber==undefined?
                        <a onClick={()=>{this.props.addCat(1,this.props)}} className={style.getCat} href="javascript:;">加入购物袋</a>:
                        <a onClick={()=>{this.props.saveAlter()}} className={style.getCat} href="javascript:;">保存修改</a>
                    }
                </div>
            </div>
        )
    }
}

const mapDispatchToProps = (dispatch) => {
    return {
        addCat: (qty) =>{
            dispatch({ type: 'customization/addCat',payload:{qty}});
        },
        saveAlter: async()=>{
           const state =  await dispatch({ type: 'customization/saveAlter'});
           if(state){
               Toast.success('修改成功！',durationTime)
           }
        },
        addCollect:()=>{
            return dispatch({type:'customization/addCollect'});
        }
    }
  }
  const mapStateToProps=(state)=>{
    const {abstractParts,entryNumber} = state.customization;
    return {
      abstractParts,
      entryNumber
    };
  }

  export default connect(mapStateToProps,mapDispatchToProps)(CustomizationBottomNav);