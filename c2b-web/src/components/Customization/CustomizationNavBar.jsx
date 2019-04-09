import React from 'react';
import { connect } from 'dva';
import {Popover, NavBar, Toast } from 'antd-mobile';
import queryString from 'query-string';
import Icon from 'components/common/Icon/Icon';
import IconBg from 'components/common/Icon/IconBg';
import style from "./CustomizationNavBar.less"
import classNames from 'classnames';
import { routerRedux } from 'dva/router';
import store from '~/index'
import {hash} from '~/parameterConfig'

const Item = Popover.Item;
const { dispatch } = store;
class RightContent extends React.Component  {
  state = {
    visible: false,
    selected: '',
  };
  onSelect = (opt) => {
    switch (opt.key){
      case '3':
      this.props.shareImg()
      break;
      case '4':
      dispatch(routerRedux.push({
          pathname: `collect`
      }));
      break;
      case '2':
      let search = location.hash.split(`?`);
      const { code } = queryString.parse(search[1]);
      this.props.reset({code_:code})
      break;
    }
    this.setState({
      visible:false
    });

  };
  handleVisibleChange = (visible) => {
    this.setState({
      visible,
    });
  };
  render() {
    return(
      <Popover mask ={false}
        overlayClassName="fortest"
        overlayStyle={{ color: 'currentColor' }}
        visible={this.state.visible}
        overlay={[
          (<Item key="1" value="scan" icon={<Icon name={`icon-xiaoxi`}/>} data-seed="logId">消息</Item>),
          (<Item key="2" value="special" icon={<Icon newClass={style.reset} name={`icon-yijianzhongzhi`}/>} style={{ whiteSpace: 'nowrap' }}>一键重置</Item>),
          (<Item key="3" value="button ct" icon={<Icon newClass={style.share} name={`icon-fenxiang`}/>}><span style={{ marginRight: 5 }}>分享</span></Item>),
          (<Item key="4" value="button ct" icon={<Icon name={``}/>}><span style={{ marginRight: 5 }}>收藏夹</span></Item>)
        ]}
        align={{
          overflow: { adjustY: 0, adjustX: 0 },
          offset: [-10, 0],
        }}
        onVisibleChange={this.handleVisibleChange}
        onSelect={this.onSelect}
      >
        <div style={{
          height: '100%',
          padding: '0 15px',
          marginRight: '-15px',
          display: 'flex',
          alignItems: 'center',
        }}
        >
        {/* <Icon type="ellipsis" /> */}
        <IconBg newClass={style.moreIcon} name={`icon-iconfontzhizuobiaozhun0257`}/>
        </div>
      </Popover>)
  }
}

class CustomizationNavBar extends React.Component{
    back=()=> {
      history.go(-1);
    }
    backCustomization= async()=>{
      let state = await this.props.backCustomization()
      if(!state){
        Toast.info('已恢复到尽头，可以通过一键重置');
      }
    }
    render() {
      return (
        <NavBar
          mode="dark"
          className={style.customizationNavBar}
          onLeftClick={()=>{this.back()}}
          leftContent={[
            <IconBg newClass={style.fanhui} name={`icon-fanhui`}/>
          ]}
          rightContent={[
            <span onClick={this.backCustomization}><IconBg  name={`icon-chetuiyibu`}/></span>,
            <span className={style.mr}><RightContent reset={this.props.reset} shareImg={this.props.shareImg} /></span>,
          ]}
        ></NavBar>
      );
    }
}
const mapStateToProps=(state)=> {
  return {
   
  };
}

const mapDispatchToProps = (dispatch) => {
    return {
        reset: async({code_})=>{
          await dispatch({ type: 'customization/fetch',payload:{code_}});
          dispatch({ type: 'customization/getImg'});
        },
        shareImg:()=>{
          const routerUrl = hash
          dispatch({ type: 'customization/shareImg',payload:routerUrl})
        },
        backCustomization:()=>{
         return dispatch({type:'customization/backCustomization'})
        }
    }
  }
export default connect(mapStateToProps,mapDispatchToProps)(CustomizationNavBar);