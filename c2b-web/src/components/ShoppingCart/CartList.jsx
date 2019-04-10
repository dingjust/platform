import React from 'react';
import { connect } from 'dva';
import { ListView,Accordion,SwipeAction,List,InputItem,Toast,Modal,Checkbox,NavBar} from 'antd-mobile'
import Icon from "components/common/Icon/Icon"
import CustomizationList from "./CustomizationList"
import style from "./CartList.less"
import IconBg from "components/common/Icon/IconBg"
import {HybrisImgUrl,imgUrl} from "~/parameterConfig"
import { routerRedux } from 'dva/router';
import store from '~/index'
import queryString from 'query-string';

const { dispatch } = store;
const CheckboxItem = Checkbox.CheckboxItem;

let modalAlert = Modal.alert;
let clearClick = null;

class CartListItem extends React.Component{
  onChange = (key) => {
    console.log(key);
  }
  serversQuantity = ({number,index, entryNumber })=>{
    clearTimeout(clearClick);
    clearClick = setTimeout(()=>{
      this.props.serversSaveQuantity(number,index, entryNumber)
    },600)
  }
  minusQuantity = (obj,index)=>{
    let number = obj.quantity-1
    let entryNumber = obj.entryNumber
    if(number>0){
      
      this.props.editQuantity(number,index)
      this.serversQuantity({number,index,entryNumber})
    }else{
      modalAlert('删除', '是否确定删除定制商品?', [
        { text: '取消', onPress: () => console.log('cancel') },
        { text: '确定', onPress: () => this.serversQuantity({number,index,entryNumber}) },
      ])
    }
    this.props.totalMoney();
  }
  changBox = (value)=>{
    console.log(value)
  }
  checked =(obj,index)=>{
    if (obj.checked == true){
      this.props.checked(false,index)
    }else{
      this.props.checked(true,index)
    }
    this.props.totalMoney();
  }
  addQuantity = (obj,index)=>{
    let number = obj.quantity+1
    let entryNumber = obj.entryNumber
    if(number<999){
      this.props.editQuantity(number,index)
      this.serversQuantity({number,index,entryNumber})
      
    }else{
      Toast.info("购买数额不能大于999！")
    }
    this.props.totalMoney();
  }
  // alter(code,pk,entryNumber){
  //   // 修改部件
  //   const params = queryString.stringify({ code,pk,entryNumber });
  //   dispatch(routerRedux.push({
  //     pathname:`/customization`,
  //     search:params
  //   }))
  // }

  render(){
    return(
      <div className={`flexBox ${style.cartListItem}`}>
            <div className={style.checkBox}>
              <CheckboxItem onClick={()=>{this.checked(this.props.list,this.props.listIndex)}} checked={this.props.list&&this.props.list.checked} onChange={()=>{this.changBox}}></CheckboxItem>
            </div>
              <div className={`flex1 flexBox`}>
                <div className={style.productImg}>
                <img src={`${imgUrl}${this.props.list&&this.props.list.product&&this.props.list.product.image}`} alt=""/>
                </div>
                <div className={`flex1 ${style.productData}`}>
                  <p className={style.title}>{this.props.list&&this.props.list.product&&this.props.list.product.name}</p>
                  <div className={`${this.props.list&&this.props.list.userConfig.pk}`}>
                    <Accordion defaultActiveKey="1" className={style.accordionBox} onChange={this.onChange}>
                      <Accordion.Panel header="详细">
                        <List>
                          <List.Item >
                            {
                              this.props.list&&this.props.list.userConfig.description?
                              JSON.parse(this.props.list.userConfig.description).parts.map((obj,index)=>(
                                  <div className={`flexBox ${style.mt2}`}>
                                    <img className={style.accordionImg} src={`${HybrisImgUrl}${obj.image}`} alt=""/>
                                    <p className={`flex1 ${style.text}`}>{obj.value}</p>
                                    {
                                      <span onClick={()=>{this.props.onOpen(this.props.list,obj,index,this.props.listIndex)}}>
                                      {/* <Icon newClass={style.alter} name={`icon-xiugai`} /> */}
                                      <span className={style.alter}>修改</span>
                                
                                      </span>
                                    }
                                    
                                  </div>
                              )):null
                            }
                          </List.Item>
                        </List>
                      </Accordion.Panel>
                    </Accordion>
                  </div>
                  <div className={`flexBox ${style.countMoney}`}>
                    <p className={`flex1 ${style.money}`}><span>￥</span>{this.props.list&&this.props.list.tolPrice}</p>
                    <div className={`flexBox ${style.countMoneyBt}`}>
                      <a href="javascript:;"  onClick={()=>{this.minusQuantity(this.props.list,this.props.index)}}>-</a>
                      <InputItem
                        type="number"
                        onChange={this.chang}
                        value={this.props.list&&this.props.list.quantity}
                      ></InputItem>
                      <a href="javascript:;" onClick={()=>{this.addQuantity(this.props.list,this.props.index)}}>+</a>
                    </div>
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
class CartList extends React.Component {
  constructor(props) {
    super(props);
    
    this.state={
      loading:false,
      date: new Date(),
      key:-1,
      listSelect:``,
      modalName:``,
      modal:false,
      part:'',
      partIndex:0,
      listIndex:0,
      entryNumber:'',
      filtrateList:[],
      dataSource:dataSource1.cloneWithRows(props.entries||[])
    }

  }

  componentWillReceiveProps=(nextProps)=> {
    if (nextProps.entries !== this.props.entries) {
        this.setState({
          key:2,
          dataSource: dataSource1.cloneWithRows(nextProps.entries)
        });
    }
    if(nextProps.filtrate != this.props.filtrate){
      this.setState({
        filtrateList: nextProps.filtrate
      });
    }
  }
  deleteCartItem=(index)=>{
    // this.props.checked(true,index)
    this.props.deleteCart(index)
  }
  addCollect=(row,index_)=>{
    this.props.addCollectProps({entries:row.entryNumber,index_})
  }
  row = (rowData, sectionID, rowID) => {
    return (
      <div key={rowID} className={`${style.cartListBox}`}>
            <SwipeAction
            autoClose
            right={[
                {
                text:<span className={style.addCollect} >转入收藏夹</span>,
                className:``,
                onPress: () => this.addCollect(rowData,rowID)
                },
                {
                text: <Icon name={`icon-shanchu1`} newClass={`swipeActionFontSize ${style.deleteIcon}`}></Icon>,
                className:`${style.delete}`,
                onPress: () => this.deleteCartItem(rowData.entryNumber)
                },
            ]}
            onOpen={() => console.log('global')}
            onClose={() => console.log('global')}
            >
                <CartListItem
                 list={rowData} 
                 listIndex={rowID}
                 onOpen={this.onOpen}
                 checked={this.props.checked}
                 totalMoney={this.props.totalMoney}
                 serversSaveQuantity={this.props.serversSaveQuantity}
                 editQuantity={this.props.editQuantity}/>
            </SwipeAction>
            
      </div>
    );
  };
  toDetail=(id)=>{
   console.log('ddd')
  }
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
  onOpen=(obj,partCode,partIndex,listIndex)=>{
    // 赋值当前部件下标
    this.setState({partIndex:partIndex})
    // 赋值当前部件所属列表下标
    this.setState({listIndex:listIndex})
    //赋值购物车id
    this.setState({entryNumber:obj.entryNumber})
    // 初始化部件列表
    this.setState({
      filtrateList: []
    })
    
    this.setState({
      modal:true
    })
    this.setState({
      modalName:partCode.name
    })
    // 标记选中部件
    this.setState({
      part:partCode.part
    })
    let productCode = obj.product.code,
    absPartCode = partCode.absPart,
    textureCode=``,
    colorCode = ``
    this.setState({
      listSelect:obj.product.code
    })
    
    this.props.getCustomizationList({ productCode, absPartCode, textureCode, colorCode })
    if(absPartCode == `fabric`){
      this.props.getColor({productCode, absPartCode})//获取颜色
      this.props.getTexture({productCode, absPartCode})//获取样式
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
          <Modal
            className={style.cartComponentsModal}
            popup
            visible={this.state.modal}
            onClose={this.onClose('modal')}
            animationType="slide-up"
          >
              <NavBar
                  leftContent={[
                      <span className={style.tabBg}>{this.state.modalName}</span>
                  ]}
                  rightContent={[
                  <div onClick={this.onClose('modal')}>
                      <IconBg  name={`icon-17cuowu`}/>
                  </div>
                  ]}
              ></NavBar>
              {/* listSelect={this.state.listSelect} */}
              <CustomizationList 
               type={this.state.modalName=='面料'?0:1}
               part={this.state.part}
               entryNumber={this.state.entryNumber}
               listIndex={this.state.listIndex}
               partIndex={this.state.partIndex}
               list={this.state.filtrateList}
               onClose={this.onClose(`modal`)}/>
          </Modal>
        </div>
    );
 }
}

const mapStateToProps=(state)=> {
  const { entries,checkEntries,filtrate } = state.shoppingCart;

  return {
    entries,
    checkEntries,
    filtrate
  };
}
const mapDispatchToProps = (dispatch) => {
  return {
    editQuantity: (number,index) =>{
      dispatch({ type: 'shoppingCart/editQuantity',payload:{number,index}});
    },
    editPrice:()=>{
      dispatch({type:'shoppingCart/editPrice'});
    },
    serversSaveQuantity:(number,index,entryNumber)=>{
      dispatch({ type: 'shoppingCart/serversSaveQuantity',payload:{number,index,entryNumber}});
    },
    checked:(state,index)=>{
      dispatch({ type: 'shoppingCart/getChecked',payload:{state,index}});
    },
    totalMoney:()=>{
      dispatch({type:'shoppingCart/totalMoney'})
    },
    // 获取部件列表
    getCustomizationList:({ productCode, absPartCode, textureCode, colorCode })=>{
      dispatch({type:`shoppingCart/getCustomizationList`,payload:{ productCode, absPartCode, textureCode, colorCode }})
    },
    // 获取颜色列表
    getColor:({ productCode, absPartCode})=>{
      dispatch({type:'shoppingCart/getColor',payload:{ productCode, absPartCode}})
    },
    // 获取样式列表
    getTexture:({ productCode, absPartCode})=>{
        dispatch({type:`shoppingCart/getTexture`,payload:{ productCode, absPartCode}})
    },
    deleteCart:(deleteId)=>{
      dispatch({ type: 'shoppingCart/deleteCart',payload:{ deleteId}});
    },
    addCollectProps:({entries, index_})=>{
      dispatch({type:`shoppingCart/addCollect`,payload:{ entries, index_}});
    }
  }
}
export default connect(mapStateToProps,mapDispatchToProps)(CartList);
