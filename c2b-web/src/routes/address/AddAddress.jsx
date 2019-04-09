import { connect } from 'dva';
import Header from 'components/common/Header/Header'
import queryString from 'query-string';
import {List, InputItem, Switch,TextareaItem, Toast} from "antd-mobile"
import style from "./AddAddress.less"
import Picker from "components/Address/Picker"
import {durationTime} from '~/parameterConfig'
import { routerRedux } from 'dva/router';
import {district,hotCities} from "assets/js/district.js"//地址库

const Item = List.Item;
class AddAddress extends React.Component{
    constructor(props) {
        super(props);
        this.state ={
            visible:false,
            cellphone: '',
            fullname: '',
            line1: '',
            pickerValue:``,
            pickerCode:[],
            checked:true,
            visibleBox:false
        }
    }
    saveAdderss = async()=>{
       
        const reg = /^[1][3,4,5,7,8][0-9]{9}$/;
        if (!reg.test(this.state.cellphone.replace(/\s+/g, ""))) {
            Toast.fail('请输入正确手机号！',durationTime)
            return false
        }
        const {id} = queryString.parse(this.props.location.search)
        let phone = this.state.fullname.replace(/\s+/g, "");
        let data = {
            id:id,
            cellphone: this.state.cellphone,
            fullname: phone,
            line1: this.state.line1,
            region:{
                isocode:this.state.pickerCode[0]
            },
            city:{
                code:this.state.pickerCode[1]
            },
            district:{
                code:this.state.pickerCode[2]
            },
            defaultAddress:this.state.checked
        }
    
      const state =  await this.props.saveAdderss(data,id)
      if(state){
          Toast.success('提交成功！',durationTime)
          history.back(-1);
      }

    }
    onChangeName=(value)=>{
        
        this.setState({
            fullname:value
        })
        // console.log(value)
    }
    componentWillReceiveProps=(nextProps)=> {
        if(nextProps.details != this.props.details){
           let pickerCode = [];
           let pickerValue = [];

           pickerCode.push(nextProps.details.region&&nextProps.details.region.isocode)
           pickerCode.push(nextProps.details.city&&nextProps.details.city.code)
           pickerCode.push(nextProps.details.district&&nextProps.details.district.code)

           pickerValue.push(nextProps.details.region&&nextProps.details.region.name)
           pickerValue.push(nextProps.details.city&&nextProps.details.city.name)
           pickerValue.push(nextProps.details.district&&nextProps.details.district.name)
            
            this.setState({
                cellphone: nextProps.details.cellphone,
                fullname: nextProps.details.fullname,
                line1:  nextProps.details.line1,
                pickerValue:pickerValue.join(`/`),
                pickerCode:pickerCode,
                checked:nextProps.details.defaultAddress
            })
        }
    }
    onChangePhone=(value)=>{
        this.setState({
            cellphone:value
        })
    }
    onChangeline1=(value)=>{
        this.setState({
            line1:value
        })
    }
    hidePicker =()=>{
        this.setState({
            visible: false,
            address:''
        })
        //修复 过度动画刷新时候显示
        setTimeout(()=>{
            this.setState({
                visibleBox:false
            })
        },300)
    }
    getAddress(){
        if(this.state.pickerValue!=''){
            return this.state.pickerValue
        }else{
            return <span className={style.placeholder}>所在地址</span>
        }
    }
    onChange = (value, selectedRows) => {
        this.setState({
            pickerValue: selectedRows.map(item => item.name).join('/'),
            visible: false,
            pickerCode:value
        })
        console.log('选择值:', value);
    }
    openPicker(){
        this.setState({
            visibleBox:true
        })
        //修复 过度动画刷新时候显示
       setTimeout(()=>{
        this.setState({
            visible:true
        })
       },50)
    }
    getTitle=()=>{
        const {id} = queryString.parse(this.props.location.search)
        return(
         id?`修改收货地址`:`添加收获地址`   
        )
    }
    deleteAddress=()=>{
        const {id} = queryString.parse(this.props.location.search)
        let state =  this.props.deleteAddress(id)
        if(state){
            history.back(-1);
        }
    }
    render(){
        // const { getFieldProps, getFieldError } = this.props.form;
        return(
           <div className={style.addAddress}>
               <Header title={this.getTitle()} rightContent={<span className={style.submit} onClick={this.saveAdderss}>提交</span>}></Header>
                <div className={style.fromBox}>
                    <List>
                    <InputItem
                        type="text"
                        placeholder="收货人"
                        maxLength={6}
                        clear={true}
                        onChange={this.onChangeName}
                        value={this.state.fullname}
                        
                        ></InputItem>
                        <InputItem
                        type="phone"
                        placeholder="手机号码"
                        clear={true}
                        onChange={this.onChangePhone}
                        value={this.state.cellphone}
                        ></InputItem>
                        <Item arrow="horizontal"  onClick={() => {this.openPicker()}}>{this.getAddress()}</Item>
                        <TextareaItem
                            placeholder="详细地址：如道路、门牌号、小区、楼栋号、单元室等"
                            data-seed="logId"
                            autoHeight
                            labelNumber={5}
                            onChange={this.onChangeline1}
                            value={this.state.line1}
                        />
                    </List>
                    <Item className={style.switch} extra={<Switch 
                            checked={this.state.checked}
                            onClick={(checked) => {
                                this.setState({
                                    checked:checked
                                })
                            }}/>}
                            >设置为默认地址</Item>
                        <div onClick={this.deleteAddress} className={style.delete}>
                            删除收获地址
                        </div>
                </div>
                {
                    this.state.visibleBox?
                    <Picker  
                    ref="picker"
                    tipText={`省份/地区`}
                    title={`请选择`}
                    dataHotCities={hotCities}
                    visible={this.state.visible}
                    onClose={this.hidePicker}
                    value={this.state.pickerCode}
                    dataSource={district}
                    onChange={this.onChange} />
                    :null
                }
                
           </div>
        )
    }
}
const mapStateToProps=(state)=> {
    const {details} = state.address;
    return {
        details
    };
  }
const mapDispatchToProps = (dispatch)=>{
    return{
        saveAdderss:(saveData,id)=>{
           return dispatch({type:`address/addAddress`, payload:{saveData,id} });
        },
        deleteAddress:(id)=>{
            return dispatch({type:`address/deleteAddress`, payload:{id} });
        },
       
        goLinke:(url,params)=>{
            dispatch(routerRedux.push({
                pathname: url,
                search:params
            }));
        }
    }
}
export default connect(mapStateToProps,mapDispatchToProps)(AddAddress);