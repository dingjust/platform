import React from "react"
import style from "./CustomizationComponentsList.less"
import { SearchBar,Tabs,ListView,Modal } from 'antd-mobile';
import IconBg from 'components/common/Icon/IconBg'
import Icon from 'components/common/Icon/Icon'
// import { StickyContainer, Sticky } from 'react-sticky';
import { connect } from 'dva';
import {HybrisImgUrl,imgUrl} from "~/parameterConfig"
import Details from "components/Customization/Detail"
import TouchImg from "components/Customization/TouchImg"


class QueryCondition extends React.Component{

    itemClick=(index,key)=>{
        if(key == 0){
            this.props.selectColor(index)
            this.props.getTexture()
        }else{
            this.props.selectTexture(index)
        }
        this.props.getCustomizationList()
    }
    render(){
        return(
            <div className={`flexBox ${style.queryCondition}`}>
                <div className={style.title}>{this.props.title}</div>
                <div className={`flex1`}>
                    <div className={style.imgBox}>
                        {this.props.selectList.map((imgList,index)=>(
                            <div>
                                <div className={imgList.checked?`${style.imgItem}  ${style.bigSize}`:`${style.displayNone}`}>
                                    <img src={`${HybrisImgUrl}${imgList.select}`} alt="选中"/>:
                                </div>
                                <div className={imgList.checked?`${style.displayNone}`:`${style.imgItem}`}>
                                    <img onClick={()=>{this.itemClick(index,this.props.index_)}} src={`${HybrisImgUrl}${imgList.common}`} alt="默认"/>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>
        )
    }
}

// 面料列表组件
class SelectList extends React.Component{
    classType = ()=>{
        if(this.props.type != 0){
            // return `flex-align`
        }
    }
    imgBorder = ()=>{
        if(this.props.type != 0){
            return `imgBorder`
        }
    }
    goDatial=(e,code)=>{
        e.stopPropagation();
        this.props.onOpenDetails()
        this.props.getDetail(code)
        return false;
    }
    render (){
        return (
            <div className={`flexBox ${style.selectListItem}`}>
                <div className={`${style.selectImgBox} ${this.imgBorder()}`}>
                    <img src={this.props.img} alt=""/>
                </div>
                <div className={`flex2 ${this.classType()}`}>
                    <p  className={style.title}>{this.props.title}</p>
                    {/* {
                        this.props.type == 0?( */}
                            <div>
                                <p className={`${style.details} overflowText`}>{this.props.summary}</p>
                                <div className={style.star}>
                                    <Icon name={`icon-xingji-`}/>
                                    <Icon name={`icon-xingji-`}/>
                                    <Icon name={`icon-xingji-`}/>
                                </div>
                            </div>
                        {/* ):null
                    } */}
                </div>
                <div className={` ${this.classType()} ${style.selectPriceBox}`}>
                    {/* {
                         this.props.type == 0? */}
                         <p className={style.price}>￥{this.props.price}</p>
                         {/* :null
                    } */}
                <a className={style.goDatial} onClick={(e)=>{this.goDatial(e,this.props.code)}} href="javascript:;">详情</a>
                </div>
            </div>
        )
    }
} 
const tabs = [
    { title: '全部' },
    { title: '爆款热度' },
    { title: '基本款' },
    { title: '季节款' }
  ];

const dataSource1 = new ListView.DataSource({
    rowHasChanged: (row1, row2) => row1 !== row2,
});

class CustomizationComponentsList extends React.Component {
    state={
        loading:false,
        index:this.props.list.parts.length - 1,
        queryConditionData:[
            {
              title:'颜色',
              selectList:this.props.colorArray
            },
            {
              title:'样式',
              selectList:[]
            },
            
        ],
        detailsState:true,
        returnList:true,
        dataSource:dataSource1.cloneWithRows(this.props.list.parts)
    }
    hei = document.documentElement.clientHeight - 500;

    selectBg=(index,key)=>{
        if(index==key){
            return `selectBg`
        }
    }
    componentWillReceiveProps=(nextProps)=> {
        if (nextProps.colorArray !== this.props.colorArray) {
            let json = this.state.queryConditionData
            json[0].selectList = nextProps.colorArray
            this.setState({
                queryConditionData: json
            });
        }
        if (nextProps.textureArray !== this.props.textureArray) {
            let json = this.state.queryConditionData
            json[1].selectList = nextProps.textureArray
            this.setState({
                queryConditionData: json
            });
        }
        if(nextProps.filtrate != this.props.filtrate){
            // console.log(this.props.filtrate)
            this.setState({
                dataSource:dataSource1.cloneWithRows(nextProps.filtrate)
            })
        }
    }
    row = (rowData, sectionID, rowID) => {
        return (
          <div key={rowID} className={`${style.selectListBox} ${this.selectBg(this.props.list.list_index,rowID)}`}>
                <div onClick={()=>{this.props.alterComponents(rowData,rowData.code);this.props.onClose()}}>
                    <SelectList
                        onOpenDetails = {this.onOpenDetails}
                        getDetail = {this.props.getDetail}
                        type = {this.props.type}
                        img={`${HybrisImgUrl}${rowData.thumbnail}`}
                        title={rowData.name}
                        tip={rowData.tip}
                        code={rowData.code}
                        summary={rowData.summary}
                        details={rowData.details}
                        price={rowData.price}
                        />
                </div>
          </div>
        );
      };
    toDetail=(id)=>{
       console.log('ddd')
       
      }
    onEndReached=()=>{
        console.log(`刷新`)
    }
    separator = (sectionID, rowID) => (
        <div
          key={`${sectionID}-${rowID}`}
          className={style.row}
        />
      );
    onClose = ()=>{
        this.props.onClose()
    }
    onCloseDetails=()=>{
        this.setState({
            detailsModel:false
        })
    }
    onOpenDetails=()=>{
        this.setState({
            detailsModel:true
        })
    }
    MyBody=(props)=>{
        return (
          <div className="am-list-body my-body">
            <span style={{ display: 'none' }}>you can custom body wrap element</span>
            {props.children}
          </div>
        )}
    returnState(e){
        this.setState({
            detailsState:e
        })
    }
    returnList(e){
        this.setState({
            returnList:e
        })
    }
    render(){
        let html;
        if(this.props.type == 0){
            html = (
                <div className={style.queryConditionBox}>
                    {this.state.queryConditionData.map((data,key_)=>(
                        <QueryCondition
                         title= {data.title}
                         getTexture={this.props.getTexture}
                         getCustomizationList={this.props.getCustomizationList}
                         index_={key_}
                         selectList = {data.selectList} 
                         selectTexture={this.props.selectTexture}
                         selectColor={this.props.selectColor}/>
                    ))}
                </div>);
        }
        return(
            
            <div className={this.state.returnList?style.customizationComponentsList:`${style.customizationComponentsList} ${style.customizationHidden}` }>
                <TouchImg  onClose={this.props.onClose} returnState={this.returnList.bind(this)} />
                <div>
                    <div className={style.search}>
                        <SearchBar placeholder="请输入搜索内容" maxLength={8} />
                    </div>
                    <div>
                        <Tabs tabs={tabs}initalPage={'t2'}>
                        </Tabs>
                    </div>
                    {html}
                </div>
                <Modal
                    className={style.detailsModel}
                    
                    visible={this.state.detailsModel}
                    animationType="slide-up"
                >
                    <div className={style.cloneDetail} onClick={()=>{this.onCloseDetails()}}>
                        <IconBg  name={`icon-17cuowu`} />
                    </div>
                    <Details ref="details" state={this.state.detailsState} ></Details>
                    {/* {console.log(this.refs.details)} */}
                    <TouchImg onClose={this.props.onClose}  returnState={this.returnState.bind(this)} />
                </Modal>
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
                        height: this.hei,
                        overflow: 'auto',
                        }}
                    onScroll={() => { console.log('scroll'); }}
                    scrollRenderAheadDistance={500}
                    onEndReached={this.onEndReached}
                    onEndReachedThreshold={100}
                    />
            </div>
        )
    }
}

const mapStateToProps=(state)=> {
    const {abstractParts,colorArray,textureArray,filtrate,url} = state.customization;
    return {
      abstractParts,
      colorArray,
      textureArray,
      filtrate,
      url
    };
  }
const mapDispatchToProps = (dispatch) => {
    return {
        alterComponents: (component,code) =>{
            dispatch({ type: 'customization/alterComponents',payload:{component,code}});
        },
        selectColor:(index)=>{
            dispatch({type:'customization/selectColor',payload:{index}})
        },
        selectTexture:(index)=>{
            dispatch({type:'customization/selectTexture',payload:{index}})
        },
        getCustomizationList:()=>{
            dispatch({type:'customization/getCustomizationList'})
        },
        getTexture:()=>{
            dispatch({type:`customization/getTexture`})
        },
        getDetail:(partCode)=>{
            dispatch({type:`customization/getDetail`,payload:{partCode}})
        }
    }
  }
export default connect(mapStateToProps,mapDispatchToProps)(CustomizationComponentsList);
