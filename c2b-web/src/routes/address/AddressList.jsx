import { connect } from 'dva';
import Header from 'components/common/Header/Header'
import { SwipeAction, List, Toast } from 'antd-mobile';
import { routerRedux } from 'dva/router';
import queryString from 'query-string';
import {durationTime} from '~/parameterConfig'

import Icon from "components/common/Icon/Icon"
import style from './AddressList.less'
const Brief = List.Item.Brief;

class AddressList extends React.Component{
    deleteAddress= async(id)=>{
        const state = await this.props.deleteAddress(id);
        if(state){
            Toast.success('删除成功！',durationTime);
            this.props.getAddressList()
        }
    }
    setDefault=async(saveData,id)=>{
       
        saveData.defaultAddress = true
        const state = await this.props.setDefault(saveData,id);
        const {type} = queryString.parse(this.props.location.search);
        if(state){
            Toast.success('设置成功！',durationTime);
            if(type==`back`){
                history.go(-1);
            }
            this.props.getAddressList()
        }
    }
    render(){
        return(
            <div className={style.addressList}>
                <Header title={`地址管理`}></Header>
                    <List  className={style.listBox}>
                        {
                            this.props.addressList&&this.props.addressList.map((obj)=>{
                                return(
                                    <SwipeAction
                                        autoClose
                                        right={[
                                            {
                                            text:<span className={style.defaultBt} >设为默认</span>,
                                            className:`${style.default}`,
                                            onPress: () => this.setDefault(obj,obj.id)
                                            },
                                            {
                                            text:<Icon name={`icon-shanchu1`} newClass={`swipeActionFontSize ${style.deleteIcon}`}></Icon>,
                                            className:`${style.delete}`,
                                            onPress: () => this.deleteAddress(obj.id)
                                            },
                                        ]}
                                        onOpen={() => console.log('global')}
                                        onClose={() => console.log('global')}
                                        >
                                        <List.Item
                                            onClick={e => console.log(e)}
                                        >
                                        <div className={`flexBox`}>
                                            <div className={`flex1`}>
                                                <p className={style.title}>
                                                    <span className={style.name}>{obj.fullname}</span>
                                                    <span className={style.phone}>{obj.cellphone}</span>
                                                    {
                                                        obj.defaultAddress?<span className={style.default}>默认</span>:null
                                                    }
                                                </p>
                                                <p className={`overflowText ${style.addressDetail}`}>{obj.region.name}{obj.city.name}{obj.district.name}{obj.line1}</p>
                                            </div>
                                            <div className={`${style.alter}`} onClick={()=>{this.props.goLinke(`addAddress`,`id=${obj.id}`)}}>
                                                <Icon  name={`icon-bianji`} ></Icon>
                                            </div>
                                        </div>
                                        </List.Item>
                                    </SwipeAction>
                                )

                            })
                        }    
                    </List>
                    <div className={style.newAddress} onClick={()=>{this.props.goLinke(`addAddress`)}}>
                        <Icon name={`icon-xinjianshouhuodizhi`}></Icon>
                        <span>新建收获地址</span>
                    </div>
            </div>
        )
    }
}
const mapStateToProps=(state)=> {
    const { addressList} = state.address;
    return {
        addressList
    };
  }
  const mapDispatchToProps = (dispatch) => {
      return {
        goLinke:(url,params)=>{
            dispatch(routerRedux.push({
                pathname: url,
                search:params
            }));
        },
        deleteAddress:(id)=>{
            return dispatch({type:`address/deleteAddress`, payload:{id} });
        },
        getAddressList:()=>{
            return dispatch({type:`address/getAddressList`});
        },
        setDefault:(saveData,id)=>{
            return dispatch({type:`address/addAddress`, payload:{saveData,id} });
         },
      }
  }
export default connect(mapStateToProps,mapDispatchToProps)(AddressList);