import React from 'react';
import { connect } from 'dva';
import {Checkbox,Toast} from 'antd-mobile';
import style from './BottomNav.less'
import { routerRedux } from 'dva/router';
import store from '~/index'
import {durationTime} from "~/parameterConfig"

const { dispatch } = store;
const CheckboxItem = Checkbox.CheckboxItem;

class BottomNav extends React.Component {
    state={
        checked:false,
        deleteState:false
    }
    allCheck(){
        if(this.state.checked){
            this.setState({
                checked:false
            })
            this.props.allCheck(false)
        }else{
            this.setState({
                checked:true
            })
            this.props.allCheck(true)
        }
        this.props.totalMoney()
    }
    deleteCart(){
        let order = this.props.checkEntries.join();
        if(order!=''){
            this.props.deleteCart()
        }else{
            Toast.info("请勾选删除订单",durationTime);
        }
    }
    goSubmitOrder(){
        let order = this.props.checkEntries.join();
        let cartCode = this.props.cartCode
        if(order!=''){
            dispatch(
                routerRedux.push({
                    pathname: 'submitOrder',
                    search:`order=${order}&cartCode=${cartCode}`
                })
            )
        }else{
            Toast.info("请勾选结算订单！",durationTime);
        }

    }
    componentWillReceiveProps=(nextProps)=> {
        // console.log(nextProps.checkEntries)
        // console.log(this.props.checkEntries)

        // if (nextProps.checkEntries !== this.props.checkEntries) {
            if(nextProps.checkEntries.length>0){
                this.setState({
                    deleteState:true
                })
            }else{
                this.setState({
                    deleteState:false
                })
            }
            if(nextProps.checkEntries.length >= this.props.entries.length&&nextProps.checkEntries.length!=0){
                this.setState({
                    checked:true
                })
            }else{
                this.setState({
                    checked:false
                })
            }
        // }

    }
    render(){
        return (
            <div className={`flexBox ${style.bottomNav}`}>
                <div className={`${style.checkbox}`}>
                    <CheckboxItem checked={this.state.checked} onClick={()=>{this.allCheck()}}>
                    全选
                    </CheckboxItem>
                </div>
                {
                    this.state.deleteState?
                    <span className={style.delete} onClick={()=>{this.deleteCart()}}>删除</span>
                    :null
                }
                <div className={`flex1 ${style.money}`}>
                    <span className={`${style.title}`}>合计:</span>
                    <span className={`${style.number}`}>
                        <span className={style.tip}>￥</span>
                        {this.props.price}
                    </span>
                </div>
                <bottom className={style.settleAccounts} onClick={()=>{this.goSubmitOrder()}}>结算</bottom>
            </div>
        );
    }
}

const mapStateToProps=(state)=> {
  const { checkEntries,cartCode,entries,price } = state.shoppingCart;
  return {
    checkEntries,
    cartCode,
    entries,
    price
  };
}

const mapDispatchToProps = (dispatch) => {
    return {
        deleteCart:(deleteId)=>{
            dispatch({ type: 'shoppingCart/deleteCart',payload:{ deleteId}});
        },
        allCheck:(state)=>{
            dispatch({ type: 'shoppingCart/allCheck',payload:{state}})
        },
        totalMoney:()=>{
            dispatch({type:'shoppingCart/totalMoney'})
        }
    }
  }
export default connect(mapStateToProps,mapDispatchToProps)(BottomNav);
