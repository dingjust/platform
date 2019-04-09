import { connect } from 'dva';
import Header from 'components/common/Header/Header'
import queryString from 'query-string';
import { Checkbox} from "antd-mobile"
import Icon from "components/common/Icon/Icon"
import style from "./PreConfiguration.less"
import {durationTime} from '~/parameterConfig'
import FiltrateList from "components/PreConfiguration/FiltrateList"
import PreconfigurationList from "components/PreConfiguration/PreconfigurationList"

import { routerRedux } from 'dva/router';

class PreConfiguration extends React.Component{
    constructor(props) {
        super(props);
        this.state ={
            filtrateState:false
        }
    }
    componentWillReceiveProps=(nextProps)=> {
        
    }
    render(){
        return(
           <div className={style.preConfigurationBox}>
               <Header title={`预配置`} 
                    rightContent={
                        <span className={style.manage} onClick={()=>{this.state.filtrateState?
                            this.setState({filtrateState:false}):this.setState({filtrateState:true})}
                    }>
                    <Icon name={`icon-tiaojianshaixuan`}></Icon></span>}>
                </Header>
                <div className={style.pd9}>
                    {
                        this.state.filtrateState?
                        <div>
                            <FiltrateList></FiltrateList>
                        </div>:null
                    }
                    
                    <div className={this.state.filtrateState?`${style.listBox} ${style.listTobbom}`:`${style.listBox}`}>
                        <PreconfigurationList />
                    </div>
                </div>
           </div>
        )
    }
}
const mapStateToProps=(state)=> {
    const {preConfigurationList} = state.preConfiguration;
    return {
        preConfigurationList
    };
  }
const mapDispatchToProps = (dispatch)=>{
    return{
        
    }
}
export default connect(mapStateToProps,mapDispatchToProps)(PreConfiguration);