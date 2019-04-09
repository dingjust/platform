import { TabBar } from 'antd-mobile';
import React from 'react';

import Icon from "components/common/Icon/Icon";
import CommonFn from "components/common/CommonFn/CommonFn";
import PropTypes from 'prop-types';
import style from "./MainLayout.less"
import issueIcon from "assets/issueIcon.png"
import ShoppingCart from 'routes/shoppingCart/ShoppingCart';
import Index from 'routes/index/Index';
import MeasureSelect from "routes/measureData/MeasureSelect"
import Users from 'routes/users/Users';
import { connect } from 'dva';

// import queryString from 'query-string';

class MainLayout extends CommonFn {
    constructor(props) {
        super(props);
        let tabValue = this.getQurey(location.hash).selectedTab?this.getQurey(location.hash).selectedTab:`index`
        this.state = {
            selectedTab: tabValue,
            hidden: false,
            fullScreen: true,
        };
    }

    selectedTab(value){
        this.setState({selectedTab:value})
        this.goUrl({url:'/',params:{selectedTab:value}});
    }
    componentWillMount () {
        
    }
    render() {
        return ( <div className={style.mainLayout} style = { this.state.fullScreen ? { position: 'fixed', height: '100%', width: '100%', top: 0 } : { height: 800 } } >
            <TabBar unselectedTintColor = "#949494"
            tintColor = "#33A3F4"
            barTintColor = "white"
            hidden = { this.state.hidden }>

                <TabBar.Item icon = {
                    <Icon name={`icon-dibu-shouye1`}></Icon>}
                    selectedIcon = {
                    <Icon newClass={style.blue} name={`icon-dibu-shouye1`}></Icon>}
                    title = "首页"
                    key = "index"
                    selected = { this.state.selectedTab === 'index' }
                    onPress = {
                        () => {
                            // console.log(this)
                            // this.setState({
                            //     selectedTab: 'index',
                            // });
                            this.selectedTab(`index`)
                        }
                    } >
                    <Index />
                </TabBar.Item>
                <TabBar.Item icon = {
                    <Icon newClass={style.lianChi} name={`icon-liangti`}></Icon> }
                    selectedIcon = {
                    <Icon newClass={`${style.blue} ${style.lianChi}`} name={`icon-liangti`}></Icon> }
                    title = "量尺"
                    key = "measureSelect"
                    selected = { this.state.selectedTab === 'measureSelect' }
                    onPress = {
                        () => {
                            this.selectedTab(`measureSelect`)
                        }
                    } >
                    {/* <Index /> */}
                    <MeasureSelect />
                </TabBar.Item>
                <TabBar.Item
                    icon = {
                        <div className={style.issueIcon}> <img src={issueIcon} alt=""/></div> }
                        selectedIcon = {
                        <div  className={style.issueIcon}> <img src={issueIcon} alt=""/></div> }
                    title = ""
                    key = "issueIcon"
                    selected = { this.state.selectedTab === 'issueIcon' }
                    onPress = {
                        () => {
                            console.log(this)
                            // this.setState({
                            //     selectedTab: 'issueIcon',
                            // });
                            // this.selectedTab(`index`)
                        }
                    } >
                </TabBar.Item>
                <TabBar.Item icon = {
                    <Icon name={`icon-dibu-gouwudai1`}></Icon> }
                    selectedIcon = {
                    <Icon newClass={style.blue}  name={`icon-dibu-gouwudai1`}></Icon> }
                        title = "购物车"
                        key = "shoppingCart"
                    selected = { this.state.selectedTab === 'shoppingCart' }
                    onPress = {
                        () => {
                            this.props.shoppingCart()
                            // this.setState({
                            //     selectedTab: 'shoppingCart',
                            // });
                            this.selectedTab(`shoppingCart`)
                        }
                    } >
                    <ShoppingCart />
                </TabBar.Item>
                <TabBar.Item icon = {
                    <Icon name={`icon-dibu-wode`}></Icon> }
                    selectedIcon = {
                    <Icon newClass={style.blue}  name={`icon-dibu-wode`}></Icon> }
                    title = "我的"
                    key = "my"
                    selected = { this.state.selectedTab === 'my' }
                    onPress = {
                        () => {
                            // this.setState({
                            //     selectedTab: 'my',
                            // });
                            this.selectedTab(`my`)
                        }
                    } >
                    <Users />
                </TabBar.Item>
            </TabBar> 
        </div>
        );
    }
}
const mapStateToProps=(state)=>{
    return {
    };
  }
  const mapDispatchToProps = (dispatch) => {

    return {
        shoppingCart: (abstractPartsKey) =>{
            dispatch({ type: 'shoppingCart/getCatList'})
        }
    }
  }
export default connect(mapStateToProps,mapDispatchToProps)(MainLayout);