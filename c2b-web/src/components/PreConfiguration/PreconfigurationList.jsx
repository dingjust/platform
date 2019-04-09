import React from 'react';
import { connect } from 'dva';
import { ListView,Accordion,List,SwipeAction,Modal,Checkbox} from 'antd-mobile'
import style from "./PreconfigurationList.less"
import {HybrisImgUrl,imgUrl} from "~/parameterConfig"
import { routerRedux } from 'dva/router';
import store from '~/index'
import queryString from 'query-string';
import {hash} from '~/parameterConfig'

const { dispatch } = store;

const dataSource1 = new ListView.DataSource({
  rowHasChanged: (row1, row2) => row1 !== row2,
});
class PreconfigurationList extends React.Component {
  constructor(props) {
    super(props);
    this.state={
      loading:false,
      date: new Date(),
      key:-1,
      listSelect:``,
      modalName:``,
      modal:false,
      dataSource:dataSource1.cloneWithRows(props.collectList||[])
    }
  }
  componentWillReceiveProps=(nextProps)=> {
    
    if (nextProps.preConfigurationList !== this.props.preConfigurationList) {
      console.log(nextProps.preConfigurationList)
        this.setState({
          key:2,
          dataSource: dataSource1.cloneWithRows(nextProps.preConfigurationList)
        });
    }
  }
  goUrl=(url,pk,code)=>{
    this.props.goUrl({url,code,pk})
  }

  row = (rowData, sectionID, rowID) => {
    return (
        <div key={rowID} className={style.listItem} onClick={()=>{this.goUrl('customization',rowData.preConfig,rowData.product)}}>
            <div>
              <img src={`${imgUrl}${rowData.image}`} alt=""/>
            </div>
            <p className={style.price}>￥{rowData.price}</p>
        </div>
    );
  };
  separator = (sectionID, rowID) => (
    <div
      key={`${sectionID}-${rowID}`}
      className={style.row}
    />
  );

  onEndReached=async()=>{
    this.setState({
      loading:true
    })
    const state = await this.props.getPreConfigurationList({page:this.props.page+1})
    if(state){
      this.setState({
        loading:false
      })
    }
  }
 render(){
    return (
        <div className={style.preconfigurationListBox}>
          <ListView
            dataSource={this.state.dataSource}
            renderHeader={``}
            renderFooter={() => (<div className={style.loading}>
                {this.state.loading ? 'Loading...' : '定制也是有底线的'}
            </div>)}
            renderRow={this.row}
            renderSeparator={this.separator}
            className={`am-list`}
            pageSize={30}
            initialListSize={30}
            style={{
                height:'100%',
                overflow: 'auto',
                }}
            onScroll={() => { console.log('scroll'); }}
            scrollRenderAheadDistance={200}
            onEndReached={this.onEndReached}
            onEndReachedThreshold={100}
          />
        </div>
    );
 }
}

const mapStateToProps=(state)=> {
  const {preConfigurationList,page} = state.preConfiguration;

  return {
    preConfigurationList,
    page
  };
}
const mapDispatchToProps = (dispatch) => {
  return {
    goUrl:({url,code,pk})=>{
        let param = queryString.stringify({code,pk})
        dispatch(routerRedux.push({
            pathname:url,
            search:param
        }))
    },
    getPreConfigurationList:({page,pageSize})=>{
      return dispatch({ type: 'preConfiguration/preConfigurationList',payload:{page,pageSize}});
    }

  }
}
export default connect(mapStateToProps,mapDispatchToProps)(PreconfigurationList);
