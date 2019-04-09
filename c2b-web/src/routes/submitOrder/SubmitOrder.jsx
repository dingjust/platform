import React from 'react';
import { connect } from 'dva';
import { NavBar,Switch,List, Toast} from 'antd-mobile';
import Site from "components/SubmitOrder/Site"
import ProductList from "components/SubmitOrder/productList"
import Icon from 'components/common/Icon/Icon';
import style from './SubmitOrder.less'
import { routerRedux } from 'dva/router';
import {durationTime} from "~/parameterConfig"
import store from '~/index'

const { dispatch } = store;

const Item = List.Item;
const Brief = Item.Brief;

class ShoppingCart extends React.Component {
  state={
    checked: false,
    submitOrderState:true
  }
  back= ()=>{
    history.go(-1);
  }
  async submitOrder (siteState, pk){
    if(!this.state.submitOrderState){
      Toast.info(`提交订单中...`)
      return false
    }else{
      this.setState({
        submitOrderState:false
      })
    }
    const {code,data}= await this.props.submitOrder(siteState, pk)
    if(code == 201){
      // Toast.success('订单提交成功，请现场支付提货！',durationTime)
      this.setState({
        submitOrderState:true
      })
      this.props.history.replace({
        pathname:'/paymentCode',
        search:`code=${this.props.data&&this.props.data.entries&&this.props.data.entries[0].product.code}&orderOn=${data.code}`
      })
    }
  }
  render(){
    return (
      <div className={style.submitOrder}>
        <NavBar
          mode="dark"
          leftContent={
              <div onClick={()=>{this.back()}}><Icon name={`icon-zuojiantou-xuanzezitihecixiu1`} /></div>
          }
        >确认订单</NavBar>
        <div className={style.main}>

          <Site checked = {this.state.checked}/>
          {
            this.props.data&&this.props.data.entries&&this.props.data.entries.map((obj)=>{
              return (<ProductList list={obj}></ProductList>)
            })
          }
          <List >
            <Item extra="不可开发票" arrow="horizontal" onClick={() => {}}>发票</Item>
            <Item extra={`无可用`} arrow="horizontal" onClick={() => {}}>优惠券</Item>
            <Item extra={<span className={style.money}><span className={style.tip}>￥</span>{this.props.data&&this.props.data.subTol}</span>} arrow="horizontal">商品金额</Item>
            <Item extra={<span className={style.money}><span className={style.tip}>￥</span>{this.props.data&&this.props.data.tolDiscounts}</span>} arrow="horizontal">运费</Item>
            <Item extra={<span className={style.money}>-<span className={style.tip}>￥</span>{this.props.data&&this.props.data.delCost}</span>} arrow="horizontal">优惠</Item>
          </List>
          <List className={style.switch}>
            <Item extra={<Switch
              checked={this.state.checked}
              onClick={(checked) => {
                if(this.state.checked){
                  this.setState({checked:false})
                }else{
                  this.setState({checked:true})
                }
                // Toast.info('本商只能现场提货！',durationTime)
              }}
            />}>现场提货</Item>
          </List>
        </div>
        <div className={style.bottomNav}>
              <span className={style.title}>合计金额：</span>
              <span className={style.money}><span className={style.tip}>￥</span>{this.props.data&&this.props.data.tolPrice}</span>
              <a className={style.submitOrderBt} onClick={()=>{this.submitOrder(this.state.checked,'')}} href="javascript:;">提交订单</a>
        </div>
      </div>
    );
  }
}


const mapDispatchToProps = (dispatch) => {
  return {
    submitOrder: (siteState, pk) =>{
      return dispatch({ type: 'submitOrder/submitOrder',payload: { siteState, pk }});
    }
  }
}
const mapStateToProps=(state)=> {

  const { data } = state.submitOrder;
  return {
      data
  };
}
export default connect(mapStateToProps,mapDispatchToProps)(ShoppingCart);
