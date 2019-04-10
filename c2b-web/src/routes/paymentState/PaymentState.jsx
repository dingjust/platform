import React from 'react';
import { connect } from 'dva';
import { NavBar} from 'antd-mobile';
import { routerRedux } from 'dva/router';
import queryString from 'query-string';
import Header from "components/common/Header/Header"

import Icon from 'components/common/Icon/Icon';
import style from './PaymentState.less'


class PaymentState extends React.Component {
  state={
    checked: true
  }
  back= (search)=>{
    this.props.history.replace({
      pathname:`/`
    })
  }
  goShopping(){
    this.props.history.replace({
      pathname:`customization`,
      search:this.props.location.search
    })
  }
  render(){
    return (
      <div className={style.paymentState}>
        <Header  title={`支付成功`}></Header>
        
        <div>
          <div className={style.iconBox}>
            <Icon newClass={style.icon} name={`icon-zhifuchenggong`}></Icon>
          </div>
          <p className={style.text}>支付成功</p>
          <p className={`${style.textTip}  ${style.mt3}`}>派送员将会以最快速度将衣服送到您的手中</p>
          <p  className={`${style.textTip}`}>请小主耐心等待哟~</p>
        </div>
          <div className={`flexBox ${style.btBox}`}>
            <a className={`${style.goShopping}`} href="javascript:;" onClick={()=>{this.goShopping()}}>继续定制</a>
            <a className={style.back} href="javascript:;" onClick={()=>{this.back()}}>返回首页</a>
          </div>
      </div>
    );
  }
}


const mapStateToProps=(state)=> {

  return {
  };
}

const mapDispatchToProps = (dispatch) => {
  return {

  }
}
export default connect(mapStateToProps,mapDispatchToProps)(PaymentState);
