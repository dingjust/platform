import React from 'react';
import { connect } from 'dva';
import { ListView,Accordion,List,SwipeAction,Modal,Checkbox} from 'antd-mobile'
import Icon from "components/common/Icon/Icon"
import style from "./CollectList.less"
import IconBg from "components/common/Icon/IconBg"
import {HybrisImgUrl,imgUrl} from "~/parameterConfig"
import { routerRedux } from 'dva/router';
import store from '~/index'
import queryString from 'query-string';
import {hash} from '~/parameterConfig'

const { dispatch } = store;
const CheckboxItem = Checkbox.CheckboxItem;

let modalAlert = Modal.alert;
let clearClick = null;

class CollectListItem extends React.Component{
  onChange = (key) => {
    console.log(key);
  }
  serversQuantity = ({number,index, entryNumber })=>{
    clearTimeout(clearClick);
    clearClick = setTimeout(()=>{
      this.props.serversSaveQuantity(number,index, entryNumber)
    },600)
  }
  changBox = (value)=>{
    console.log(value)
  }
  checked =(obj,index)=>{
    if (obj.checked == true){
      this.props.checked(false,index*1)
    }else{
      this.props.checked(true,index*1)
    }
  }

  alter(code,pk){
    // 修改部件
    const params = queryString.stringify({ code,pk,type:`coolect` });
    dispatch(routerRedux.push({
      pathname:`/customization`,
      search:params
    }))
  }
  render(){
    return(
      <div className={`flexBox ${style.collectListItem}`}>
            {
              this.props.manage?
              <div className={style.checkBox}>
                <CheckboxItem onClick={()=>{this.checked(this.props.list,this.props.listIndex)}} checked={this.props.list&&this.props.list.checked} onChange={()=>{this.changBox}}></CheckboxItem>
              </div>
              :null
            }
              <div className={`flex1 flexBox`}>
                <div className={style.productImg}>
                <img src={
                  `${imgUrl}${this.props.list&&this.props.list.productUserConfig.description&&JSON.parse(this.props.list.productUserConfig.description).url}`} alt=""/>
                </div>
                <div className={`flex1 ${style.productData}`}>
                    <p className={`flex1 ${style.title}`}>{this.props.list&&this.props.list.productUserConfig&&this.props.list.productUserConfig.productName}</p>
                  <div>
                    <Accordion defaultActiveKey="1" className={style.accordionBox} onChange={this.onChange}>
                      <Accordion.Panel header="详情">
                        <List>
                          <List.Item >
                            {
                              this.props.list&&this.props.list.productUserConfig.description?
                              JSON.parse(this.props.list.productUserConfig.description).parts.map((obj,index)=>(
                                  <div className={`flexBox ${style.mt2}`}>
                                    <img className={style.accordionImg} src={`${HybrisImgUrl}${obj.image}`} alt=""/>
                                    <p className={`flex1 ${style.text}`}>{obj.value}</p>
                                    
                                  </div>
                              )):null
                            }
                          </List.Item>
                        </List>
                      </Accordion.Panel>
                    </Accordion>
                  </div>
                  <div className={`flexBox ${style.countMoney}`}>
                    <p className={`flex1 ${style.money}`}>
                      <span>￥</span>{this.props.list&&this.props.list.productUserConfig.productPrice}
                      <span className={style.amend} onClick={()=>{this.alter(this.props.list.productUserConfig.productCode,this.props.list.productUserConfig.id)}}>继续定制</span>
                    </p>
                  </div>
                </div>
              </div>
      </div>
    )
  }
}
const dataSource1 = new ListView.DataSource({
  rowHasChanged: (row1, row2) => row1 !== row2,
});
class CollectList extends React.Component {
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
    
    if (nextProps.collectList !== this.props.collectList) {
        this.setState({
          key:2,
          dataSource: dataSource1.cloneWithRows(nextProps.collectList)
        });
    }
  }
  shareCollect=(obj,index)=>{
    const routerUrl = hash,
    productCode = obj.productUserConfig.productCode,
    productUserConfig = obj.productUserConfig.selectJson,
    url = JSON.parse(obj.productUserConfig.description).url
    this.props.getShareImg({routerUrl, productCode, productUserConfig, url})
  }
  deleteCollect=(obj,index)=>{
    this.props.checked(true,index)
    this.props.deleteCollectProps()
  }
  row = (rowData, sectionID, rowID) => {
    return (
      <div key={rowID} className={`${style.collectListBox}`}>
      <SwipeAction
        autoClose
        right={[
            {
            text:<Icon name={`icon-fenxiang1`} newClass={`swipeActionFontSize ${style.shareIcon}`}></Icon>,
            className:`${style.shareBox}`,
            onPress: () => this.shareCollect(rowData,rowID)
            },
            {
            text: <Icon name={`icon-shanchu1`} newClass={`swipeActionFontSize ${style.deleteIcon}`}></Icon>,
            className:`${style.delete}`,
            onPress: () => this.deleteCollect(rowData,rowID)
            },
        ]}
       
        >
          <div>
              <CollectListItem
                list={rowData} 
                listIndex={rowID} 
                manage={this.props.manage}
              //  onOpen={this.onOpen}
                checked={this.props.checked}
              //  totalMoney={this.props.totalMoney}
              //  serversSaveQuantity={this.props.serversSaveQuantity}
              //  editQuantity={this.props.editQuantity}
                />
          </div>
        </SwipeAction>
      </div>
    );
  };
  separator = (sectionID, rowID) => (
    <div
      key={`${sectionID}-${rowID}`}
      className={style.row}
    />
  );
  onClose = key => () => {
        
    this.setState({
      [key]: false,
    });
  }
  onEndReached=async()=>{
    this.setState({
      loading:true
    })
    const state = await this.props.getCollectList({page:this.props.page+1})
    if(state){
      this.setState({
        loading:false
      })
    }
  }
 render(){
    return (
        <div className={style.h100}>
          <ListView
            dataSource={this.state.dataSource}
            renderHeader={``}
            renderFooter={() => (<div className={style.loading}>
                {this.state.loading ? 'Loading...' : '定制也是有底线的'}
            </div>)}
            renderRow={this.row}
            renderSeparator={this.separator}
            className="am-list"
            pageSize={30}
            style={{
                height:'100%',
                overflow: 'auto',
                }}
            onScroll={() => { console.log('scroll'); }}
            scrollRenderAheadDistance={500}
            onEndReached={this.onEndReached}
            onEndReachedThreshold={100}
          />
        </div>
    );
 }
}

const mapStateToProps=(state)=> {
  const {collectList,page} = state.collect;

  return {
    collectList,
    page
  };
}
const mapDispatchToProps = (dispatch) => {
  return {
    
    checked:(state,index)=>{
      dispatch({ type: 'collect/getChecked',payload:{state,index}});
    },
    getCollectList:({page,pageSize})=>{
      return dispatch({ type: 'collect/collectList',payload:{page,pageSize}});
    },
    getShareImg:({routerUrl, productCode, productUserConfig, url})=>{
      return dispatch({ type: 'collect/shareImg',payload:{routerUrl, productCode, productUserConfig, url}});
    },
    deleteCollectProps:()=>{
      return dispatch({ type: 'collect/deleteCollect',payload:{}});
    }
  }
}
export default connect(mapStateToProps,mapDispatchToProps)(CollectList);
