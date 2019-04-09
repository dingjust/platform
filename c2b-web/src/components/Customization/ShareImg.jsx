import React from 'react';
import { connect } from 'dva';
import {Modal } from 'antd-mobile';
import style from "./ShareImg.less"
import {imgUrl} from '~/parameterConfig'
import IconBg from 'components/common/Icon/IconBg'

class ShareImg extends React.Component{
    state={
        modal:false
    }
    componentWillReceiveProps=(nextProps)=> {
        if (nextProps.shareImgURL !== this.props.shareImgURL && nextProps.shareImgURL!='') {
            this.setState({
                modal:true
            })
        }
    }
    onClose = ()=>{
        this.setState({
            modal:false
        })
    }
    render(){
        return(
            <Modal className={style.shareImg} onClose={this.onClose} visible={this.state.modal}>
                <div className={style.closeIcon} onClick={this.onClose}>
                    <IconBg newClass={`borderWhite`}  name={`icon-17cuowu`}/>
                </div>
                <div className={style.imgBox}>
                    <img src={imgUrl+this.props.shareImgURL} alt="分享图片"/>
                </div>
            </Modal>
        )
    }
}

export default connect()(ShareImg);
