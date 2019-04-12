
import Icon from "components/common/Icon/Icon"
import { connect } from 'dva';
import style from './Site.less';
import { List,Toast} from 'antd-mobile';
import noSiteIcon from "assets/submitOrder/noSite.png"
import {durationTime} from "~/parameterConfig"
import CommonFn from "components/common/CommonFn/CommonFn"
import { addAddress } from "../../services/address";

const Item = List.Item;
const Brief = Item.Brief;
class Site extends CommonFn{
    constructor(props) {
        super(props);
        this.state={
            siteState:false,
            checked:true
        }
    }
    goAddAddress=()=>{
        if(this.state.siteState){
            this.goUrl({url:`addressList`,params:{type:`back`}})
        }else{
            this.goUrl({url:`addressList`})
        }
    }
    componentWillReceiveProps=(nextProps)=> {
        if(nextProps.address!=this.props.address&&nextProps.address!=undefined){
            this.setState({
                siteState:true
            })
        }
        if(nextProps.checked != this.props.checked){
            if(nextProps.checked){
                this.setState({checked:false})
            }else{
                this.setState({checked:true})
            }
        }
    }
    replace=(value)=>{
        if(value){
            return value.replace(/\s+/g, "")
        }
    }
    forbid=()=>{
        if(this.state.checked){
            return `flexBox`
        }else{
            return `${style.forbid} flexBox`
        }
    }
    render(){
        let html = ()=>{
            return (
                this.state.siteState?
                <div className={this.forbid()}>
                    <div className={style.siteIcon}>
                        <Icon name={`icon-dizhi`}></Icon>
                    </div>
                    <div className={`flex1`}>
                        <List className="my-list">
                        <Item
                            arrow="horizontal"
                            multipleLine
                            onClick={() => {}}
                            platform="android"
                            >
                            {this.props.address.fullname} {this.replace(this.props.address.cellphone)}<Brief>{this.props.address.region&&this.props.address.region.name}/{this.props.address.city&&this.props.address.city.name}/{this.props.address.district&&this.props.address.district.name}/{this.props.address.line1}</Brief>
                            </Item>
                        </List>
                    </div>
                </div>:
                <div className={style.noSiteBox}>
                    <img className={style.noSiteIcon} src={noSiteIcon} alt="地址icon"/>
                    <p>还没有收货地址，<a href="javascript:;" >去添加</a></p>
                </div>
            )
        }
        return (
            <div className={style.siteBox} onClick={()=>{this.goAddAddress()}} >
                {html()}
                <div className={style.siteBoder}></div>
            </div>
        )
    }
}


const mapStateToProps=(state)=>{
    const {address} = state.submitOrder;
    return {
        address
    };
  }

export default connect(mapStateToProps)(Site);