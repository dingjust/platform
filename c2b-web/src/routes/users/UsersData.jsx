import React from 'react';
import { connect } from 'dva';
import {Accordion} from 'antd-mobile'
import Header from 'components/common/Header/Header'
import Icon from 'components/common/Icon/Icon';
import style from './UsersData.less'
class UsersData extends React.Component {
  render (){
    return(
      <div className={style.UsersData}>
        <Header title={`基础信息`} ></Header>

        <div className={style.top}>
            <img src="../../assets/users/defaultHeader.png" alt=""/>
            <span>点击编辑昵称</span>
        </div>
        <div>
            <span>我是男生</span>
            <span>我是女生</span>
        </div>
        <Accordion defaultActiveKey="0" className="my-accordion" onChange={this.onChange}>
            <Accordion.Panel header="Title 2" className="pad">this is panel content2 or other</Accordion.Panel>
        </Accordion>
      </div>
    )
  }
}

export default connect()(UsersData);
