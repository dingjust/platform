import React from 'react';
import { connect } from 'dva';
import { NavBar} from 'antd-mobile';
import BottomNav from 'components/ShoppingCart/BottomNav'
import CartList from 'components/ShoppingCart/CartList'
import Icon from 'components/common/Icon/Icon';
import style from './ShoppingCart.less'

class ShoppingCart extends React.Component {
  back= ()=>{
    history.go(-1);
  }
  listBoxClass=()=>{
    if(this.props.location&&this.props.location.pathname == "/shoppingCart"){
      return `${style.listBox}`
    }else{
      return `${style.listBox}  ${style.bottom2}`
    }
  }
  bottomNavClass=()=>{
    if(this.props.location&&this.props.location.pathname == "/shoppingCart"){
      return `${style.bottomNav}`
    }else{
      return `${style.bottomNav}  ${style.bottom1}`
    }
  }
  render(){
    return (
      <div className={style.ShoppingCart}>
        <NavBar
          mode="dark"
          leftContent={
            this.props.location&&this.props.location.pathname == "/shoppingCart"?
              <div onClick={()=>{this.back()}}><Icon name={`icon-zuojiantou-xuanzezitihecixiu1`} /></div>:null
          }
        >购物袋</NavBar>
        <div className={this.listBoxClass()}>
          <CartList/>
        </div>
        <div className={this.bottomNavClass()}>
          <BottomNav />
        </div>
      </div>
    );
  }
}

const mapStateToProps=(state)=> {
  const {entries} = state.shoppingCart;
  return {
    entries
  };
}


export default connect(mapStateToProps)(ShoppingCart);
