import { connect } from 'dva';
import Header from 'components/common/Header/Header'
import queryString from 'query-string';
import { Checkbox} from "antd-mobile"
import style from "./Collect.less"
// import {durationTime} from '~/parameterConfig'
import CollectList from "components/Collect/CollectList"
import ShareImg from 'components/Customization/ShareImg'

import { routerRedux } from 'dva/router';
const CheckboxItem = Checkbox.CheckboxItem;

class Collect extends React.Component{
    constructor(props) {
        super(props);
        this.state ={
            manageState:false,
            allChecked:false,
            shareImgURL:``
        }
    }
    manage=()=>{
        if(this.state.manageState){
            this.setState({
                manageState:false
            })
        }else{
            this.setState({
                manageState:true
            })
        }
    }
    allCheck(){
        if(this.state.allChecked){
            this.setState({
                allChecked:false
            })
            this.props.allCheck(false)
        }else{
            this.setState({
                allChecked:true
            })
            this.props.allCheck(true)
        }
    }
    componentWillReceiveProps=(nextProps)=> {
        if(nextProps.shareImgURL != this.props.shareImgURL){
            this.setState({shareImgURL:nextProps.shareImgURL})
        }
        if(nextProps.checkCollect.length >= this.props.collectList.length&&nextProps.checkCollect.length>0){
            this.setState({
                allChecked:true
            })
        }else{
            this.setState({
                allChecked:false
            })
        }
    }
    render(){
        return(
           <div className={style.collectBox}>
               <Header title={`我的收藏`} rightContent={<span className={style.manage} onClick={()=>{this.manage()}}>管理</span>}></Header>
                <div className={style.listBox}>
                    <CollectList manage={this.state.manageState} />
                </div>
                <ShareImg shareImgURL={this.state.shareImgURL} />
                {
                    this.state.manageState?
                    <div className={`flexBox ${style.manageBt}`}>
                        <div  className={style.left}>
                            <CheckboxItem checked={this.state.allChecked} onClick={()=>{this.allCheck()}}>全选</CheckboxItem>
                        </div>
                        <div className={`flex1`}></div>
                        <a className={style.right} onClick={()=>{this.props.deleteCollect()}} href="javascript:;">删除</a>
                    </div>
                    :null
                }
           </div>
        )
    }
}
const mapStateToProps=(state)=> {
    const {collectList,checkCollect,shareImgURL} = state.collect;
    return {
        collectList,
        checkCollect,
        shareImgURL
    };
  }
const mapDispatchToProps = (dispatch)=>{
    return{
        allCheck:(state)=>{
            dispatch({ type: 'collect/allCheck',payload:{state}})
        },
        deleteCollect:()=>{
            dispatch({type:`collect/deleteCollect`})
        }
    }
}
export default connect(mapStateToProps,mapDispatchToProps)(Collect);