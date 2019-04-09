import React from "react"
import { connect } from 'dva';
import style from "./FiltrateList.less"
import { SearchBar,Tabs} from 'antd-mobile';
import {HybrisImgUrl,imgUrl} from "~/parameterConfig"

const tabs = [
    { title: '全部' },
    { title: '颜色' },
    { title: '样式' },
    { title: '领型' },
    { title: '衣袖' }
  ];
class ColorItem extends React.Component{
    state={
        list:this.props.list,
        index_:null
    }
    componentWillReceiveProps=(nextProps)=>{
        if(nextProps.default != this.props.default){
            this.setState({
                index_:null
            })
        }
        
    }
    selectItem=(index)=>{
        this.setState({
            index_:index
        })
        setTimeout(()=>{
            this.props.returnValue({key:this.props.key_,value:this.state.list[this.state.index_].code})
        },100)
    }
    render(){
        return(
            <div className={style.colorItemBox}>
                {
                    this.state.list.map((obj,index)=>{
                        return(
                            <div  onClick={()=>{this.selectItem(index)}} >
                                <div className={this.state.index_ == index?`${style.displayNone} ${style.colorItemCommon}`:`${style.colorItemCommon}`}>
                                    <img src={`${HybrisImgUrl}${obj.common}`} alt=""/>
                                </div>
                                <div className={this.state.index_ == index?`${style.colorItemSelect}`:`${style.displayNone}  ${style.colorItemCommon}`}>
                                    <img src={`${HybrisImgUrl}${obj.select}`} alt=""/>
                                </div>
                            </div>
                            
                        )
                    })
                }
            </div>
        )
    }
}
class Part extends React.Component{
    state={
        list:this.props.list,
        index_:null
    }
    componentWillReceiveProps=(nextProps)=>{
        if(nextProps.default != this.props.default){
            this.setState({
                index_:null
            })
        }
        
    }
    selectItem=(index)=>{
        this.setState({
            index_:index
        })
        setTimeout(()=>{
            this.props.returnValue({key:this.props.key_,value:this.state.list[this.state.index_].code})
        },100)
    }
    render(){
        return(
            <div className={style.partBox}>
                {
                    this.state.list.map((obj,index)=>{
                        return(
                            <div className={this.state.index_==index?`${style.partItem} ${style.partSelect}`:`${style.partItem}`} onClick={()=>{this.selectItem(index)}} >
                                <img src={`${HybrisImgUrl}${obj.common}`} alt=""/>
                            </div>
                        )
                    })
                }
            </div>
        )
    }
}
class FiltrateList extends React.Component{
    state={
       index_:0
    }
    filtersArray=(key)=>{
        for (let i=0;i<this.props.filtersList.length;i++)
        {
            if(this.props.filtersList[i].code == key){
                return this.props.filtersList[i];
            }
        }
    }
    getList=(obj)=>{
        this.props.getPreConfigurationList({[obj.key]:obj.value})
    }
    tabIndex=(tab,index)=>{
        switch  (index){
            case 0:
            this.props.getPreConfigurationList({page:0});
            break;
            default:
            this.setState({index_:index})
            break;
        }
    }
    render(){
        return(
            <div className={style.FiltrateListBox}>
                <div className={style.search}>
                    <SearchBar placeholder="搜索" maxLength={8} />
                </div>
                <div>
                    <Tabs tabs={tabs} onChange={this.tabIndex} initalPage={'t2'}>
                        <div>
                            
                        </div>
                        <div>
                            <ColorItem returnValue={this.getList} key_={`color`} default={this.state.index_}  list={this.filtersArray(`color`).filters}></ColorItem>
                        </div>
                        <div>
                            <ColorItem returnValue={this.getList}  key_={`texture`} default={this.state.index_} list={this.filtersArray(`texture`).filters}></ColorItem>
                        </div>
                        <div>
                            <Part returnValue={this.getList} key_={`collar`} default={this.state.index_} list={this.filtersArray(`collar`).filters}></Part>
                        </div>
                        <div>
                            <Part returnValue={this.getList}  key_={`sleeve`} default={this.state.index_} list={this.filtersArray(`sleeve`).filters}></Part>
                        </div>
                    </Tabs>
                </div>
            </div>
        )
    }
}

const mapStateToProps=(state)=> {
    const {filtersList} = state.preConfiguration
    return {
        filtersList
    }
  }
const mapDispatchToProps = (dispatch)=>{
    return{
        getPreConfigurationList:({page,pageSize,color, texture, collar, sleeve })=>{
            return dispatch({ type: 'preConfiguration/preConfigurationList',payload:{page,pageSize,color, texture, collar, sleeve }});
          }
    }
}

export default connect(mapStateToProps,mapDispatchToProps)(FiltrateList);