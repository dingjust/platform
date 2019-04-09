import React from 'react';
import { connect } from 'dva';
// import Loader from '../Loader/Loader';
import style from "./Detail.less"


class Detail extends React.Component{

  componentWillReceiveProps=(nextProps)=> {
    if (nextProps.state !== this.props.state) {
      this.classFn()
    }
  }
  classFn(){
    if(this.props.state){
      return `${style.detail}`
    }else{
      return `${style.detail} ${style.hidden}`
    }
  }
  render(){
    return (
        <div className={this.classFn()} ref="detail" dangerouslySetInnerHTML={{__html: this.props.detail}} />
    );
  }
}

function mapStateToProps(state) {
  const { detail } = state.shoppingCart;
  return {
    loading: state.loading.models.shoppingCart,
    detail,
  };
}

export default connect(mapStateToProps)(Detail);
