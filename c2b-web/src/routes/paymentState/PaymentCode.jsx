import React from 'react';
import { connect } from 'dva';
import style from "./PaymentCode.less"
import Icon from "components/common/Icon/Icon"
import Header from "components/common/Header/Header"
import { routerRedux } from 'dva/router';
import onePNG from "assets/measureData/1.png"


class PaymentCode extends React.Component{
      state = {

      }
    //   back= ()=>{
    //     this.props.history.replace({
    //       pathname:`shoppingCart`
    //     })
    //   }
      render(){
            return (
                <div className={style.paymentCode}>
                    <Header  title={`支付方式`}></Header>
                    <div className={style.code}>
                        {/* <img src={onePNG} alt="banner"/> */}
                        <Icon name={`icon-erweima`}></Icon>
                        <p>请扫码支付</p>
                    </div>
                    <a className={style.bt} onClick={()=>{this.props.goLinke(`paymentState`,this.props.location.search)}} href="javascript:;">已支付</a>
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
export default connect(mapStateToProps,mapDispatchToProps)(PaymentCode);
