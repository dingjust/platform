import React from 'react';
import { connect } from 'dva';
import { NavBar, Icon } from 'antd-mobile';
import DetailComponent from 'components/Detail/Detail';

function Users() {
  function back() {
    history.go(-1);
  }
  return (
    <div>
      <NavBar
        mode="dark"
        leftContent={[
          <span onClick={back}>返回</span>,
        ]}
        rightContent={[
          <Icon key="0" type="search" style={{ marginRight: '16px' }} />,
          <Icon key="1" type="ellipsis" />,
        ]}
      >详情</NavBar>
      {/* <DetailComponent /> */}
      sdfsdfsdfsf
    </div>
  );
}

export default connect()(Users);
