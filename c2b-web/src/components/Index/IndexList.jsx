import React from 'react';
import style from './IndexList.less'
import Icon from 'components/common/Icon/Icon'
import {HybrisImgUrl} from "~/parameterConfig"
import CommonFn from "components/common/CommonFn/CommonFn"

class ClothesAnimation extends React.Component{
    state={
        imgIndex:0,
        interval:``
    }
    componentDidMount(){
        setTimeout(()=>{
            this.refs.imgBox.style.width= this.refs.imgSwitchover0.clientWidth+`px`
            this.refs.imgBox.style.height= this.refs.imgSwitchover0.clientHeight+`px`
        },0)
        if(this.props.animationState){
            this.start()
        }
    }
    componentWillReceiveProps(nextProps){
        if(nextProps.animationState != this.props.animationState){
            if(nextProps.animationState){
                this.start()
            }else{
                clearInterval(this.state.interval)
            }
        }
    }
    start=()=>{
        let imgLenght =  this.props.imgList.length-1;
        this.setState({
            interval:setInterval(()=>{
                if(imgLenght ==this.state.imgIndex){
                    this.setState({
                        imgIndex:0
                    })
                }else{
                    this.setState({
                        imgIndex:this.state.imgIndex+1
                    })
                }
            },1500)
        })
    }
    classSwitchover=(index)=>{
        
        if(this.state.imgIndex == index){
            return `${style.fadeIn}`
        }else{
            return `${style.fadeOut}`
        }
    }
    render(){
        return (
            <div ref='imgBox' className={`${style.animationImg} ${style.clear}`}>
                {
                    this.props.imgList.map((obj,index)=>{
                        return(
                            <div ref={`imgSwitchover${index}`} className={this.classSwitchover(index)}>
                                <img src = {HybrisImgUrl+obj.img} alt = "" />
                            </div>
                        )
                    })
                }
            </div>
        )
    }
}

class IndexList extends CommonFn {
    goDetails(code) {
        if(code!=""&&code!=undefined){
            this.goUrl({url:'customization',params:{code}})
        }
    }
    render() {
        return (
        <div className = {style.listBox }>
            <p className = { style.title } > { this.props.title } < Icon name = { this.props.iconName } > </Icon></p >
            <div className = { style.listItemBox } >
                {
                    this.props.list.map((obj,index)=>{
                        return (
                            <div onClick = {()=>{ this.goDetails(obj.code)} }
                            className = { `flex-column ${style.listItem}` } >
                                <div className = {`flex1 ${style.imgBox} ${style.clear}` } >
                                    {
                                        // Array.isArray(obj.imgs)&&obj.imgs.length>1?<ClothesAnimation animationState={this.props.animationState} imgList={obj.imgs}/>
                                        // :<img src = {HybrisImgUrl+obj.imgs[0].img } alt = "" />
                                        index == 1?<ClothesAnimation animationState={this.props.animationState} imgList={obj.imgs}/>
                                        :<img src = {HybrisImgUrl+obj.imgs[0].img } alt = "" />
                                    }
                                    
                                </div>
                                <p className = { style.listTitle } > { obj.title } </p> 
                            </div>
                        )
                    })
                }
            </div> 
        </div>
        )
    }
}
export default IndexList