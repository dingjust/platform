import React from 'react';
import { connect } from 'dva';
import style from "./Login.less"
import { NavBar,InputItem,Toast} from 'antd-mobile';
import Icon from "components/common/Icon/Icon"
import {durationTime} from "~/parameterConfig"
import DetailComponent from 'components/Detail/Detail';
import logoImg from "assets/logo.png"
class Login extends React.Component{
     state = {
        hasError: false,
        getCodeState:true,
        getCodeText:`获取验证码`,
        getCodeTime:60,
        thirdparty:[
            {
                icon:`icon-weibo`,
                text:`微博`
            },
            {
                icon:`icon-weixin`,
                text:`微信`
            },
            {
                icon:`icon-QQ`,
                text:`QQ`
            },
            {
                icon:`icon-zhifubao`,
                text:`支付宝`
            }
        ]
      }
      back=()=>{
        history.go(-2);
      }
      onErrorClick = () => {
        if (this.state.hasError) {
          Toast.info('Please enter 11 digits');
        }
      }
      codeClass(){
          if(this.state.getCodeTime == 60){
              return `${style.getCode}`
          }else{
            return `${style.getCode} ${style.disabled}`
          }
      }
      setTime(){
        if(this.state.getCodeTime == 0){
            this.setState(
                {
                    getCodeText:`获取验证码`,
                    getCodeTime:60
                }
            )
            this.props.getCodeSatae(true)

        }else{
            this.setState(
                {
                    getCodeText:`重新发送(${this.state.getCodeTime})`,
                }
            )
            this.setState(
                {
                    getCodeTime:this.state.getCodeTime-1
                }
            )
            setTimeout(()=>{
                this.setTime()
            },1000)
        }
      }
      getCode = async ()=>{
        const reg = /^[1][3,4,5,7,8][0-9]{9}$/;
        if (!reg.test(this.props.phone.replace(/\s+/g, ""))) {
            Toast.fail('请输入正确手机号！',durationTime)
            return false
        }
        if(this.state.getCodeTime != 60){
            Toast.info('验证码已发送',durationTime)
            return false;
        }
        
        let state =  await this.props.fetch(this.props.phone)
        console.log(state)
        if(state){
            this.setTime()
        }
      }
      onChangePhone = (value) => {
        this.props.getPhone(value)
      }
      onChangeCode = (code) => {
        this.props.getCode(code)
      }
      render(){
            return (
                <div className={style.loginMain}>
                    <NavBar
                        mode="dark"
                        rightContent={[
                        <div className={style.backIcon}  onClick={this.back} >
                            <Icon name={`icon-17cuowu`} />
                        </div>
                        ]}
                    ></NavBar>
                <img className={style.logo}  src={logoImg} alt=""/>
                

                <div>
                    <InputItem
                            type="phone"
                            placeholder="请输入手机号码"
                            onBlur={this.blurPhone}
                            // error={this.state.hasError}
                            clear={true}
                            // onErrorClick={this.onErrorClick}
                            onChange={this.onChangePhone}
                            value={this.props.phone}
                        ></InputItem>
                    <div className={style.lineBox}>
                        <span className={style.bottomBr}></span>
                    </div>
                    <div className={`flexBox ${style.getCodeBox}`}>
                        <div className={`flex1`}>
                            <InputItem
                                type="code"
                                placeholder="请输入手机验证码"
                                // error={this.state.hasError}
                                clear={true}
                                // onErrorClick={this.onErrorClick}
                                onChange={this.onChangeCode}
                                value={this.props.code}
                            ></InputItem>
                        </div>
                        <a className={this.codeClass()} onClick={()=>{
                            this.getCode()
                        }} href="javascript:;">{this.state.getCodeText}</a>
                    </div>
                    <div className={style.lineBox}>
                        <span className={style.bottomBr}></span>
                    </div>
                </div>
                <div className={style.pd6}>
                    <bottom className={style.bottom} onClick={()=>{this.props.login(this.props.code)}}>确定</bottom>
                    <p className={style.agree}>点击确认，即表示已阅读并同意<span>《注册会员服务条款》</span></p>

                    <div className={`${style.thirdparty}`}>
                       <div className={`flexBox `}>
                        <div className={`flex1 ${style.titleLine}` }></div>
                        <span className={`flex1 ${style.title}`}>第三方登录</span>
                        <div className={`flex1 ${style.titleLine}`}></div>
                       </div>
                       <div className={`flexBox `}>
                            {
                                this.state.thirdparty.map((list)=>{
                                    return(
                                        <div className={`flex1`}>
                                            <div className={style.iconBox}>
                                                <Icon name={list.icon} />
                                            </div>
                                            <p className={style.text} >{list.text}</p>
                                        </div>
                                    )
                                })
                            }
                            
                       </div>
                    </div>
                </div>
                </div>
            );
        }
}
const mapStateToProps = (state)=>{
    const {code,phone } = state.login;
    return {
        code,
        phone
    };
  }
const mapDispatchToProps = (dispatch) => {
    return {
        login: (code) =>{
            dispatch({ type: 'login/login',payload:code});
        },
        fetch: (phone) => {
            return  dispatch({ type: 'login/fetch',payload:phone});
        },
        getPhone:(phone)=>{
            dispatch({ type: 'login/getPhone',payload:phone});
        },
        getCode:(code)=>{
            dispatch({ type: 'login/getCode',payload:code});
        }
    }
  }
export default connect(mapStateToProps,mapDispatchToProps)(Login);
