import React from 'react';
import { connect } from 'dva';
import { NavBar, Icon } from 'antd-mobile';
import DetailComponent from 'components/Detail/Detail';
import Header from 'components/common/Header/Header'

class Users extends React.Component {
  render (){
    return(
      <div>
        <Header title={`个人中心`} ></Header>
      </div>
    )
  }
}

export default connect()(Users);
