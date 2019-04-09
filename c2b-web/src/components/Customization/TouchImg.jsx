import style from "./TouchImg.less"
import {imgUrl} from "~/parameterConfig"
import { connect } from 'dva';

class TouchImg extends React.Component{
    constructor(props) {
        super(props);
        this.state={
            flag:false,
            cur:{
                x: 0,
                y: 0
            },
            nx:0,
            ny:0,
            dx:0,
            dy:0,
            x:`70%`,
            y:`70%`
        }
    }
    down(event) {
        let touch;
        this.setState({
            flag:true
        })
        if (event.touches) {
            touch = event.touches[0];
        } else {
            touch = event;
        }
        let cur = {
            x:touch.clientX,
            y:touch.clientY
        }
        this.setState({
            dx:this.refs.touchImg.offsetLeft,
            dy:this.refs.touchImg.offsetTop,
            cur:cur
        })
        // document.addEventListener("touchmove", function() {
        //     event.preventDefault();
        // }, false);
        this.returnState(event,false)
        
    }
    move(event) {

        
        if (this.state.flag) {
            var touch;
            if (event.touches) {
                touch = event.touches[0];
            } else {
                touch = event;
            }
            this.setState({
                nx:touch.clientX - this.state.cur.x,
                ny:touch.clientY - this.state.cur.y,
            })
            this.setState({
                x:this.state.dx + this.state.nx,
                y:this.state.dy + this.state.ny
            })

            document.addEventListener("touchmove", function() {
                event.preventDefault();
            }, false);
            // this.state.touchDom.style.left = this.state.x + "px";
            // this.state.touchDom.style.top = this.state.y + "px";
            //阻止页面的滑动默认事件
            // event.stopPropagation();
            // event.nativeEvent.stopImmediatePropagation();
        }
        
    }
    
    end(event) {
        this.setState({
            flag:false
        })
        // document.addEventListener("touchmove", function() {
        //     event.preventDefault();
        // }, true);
        this.returnState(event,true)
    }
    returnState(event,state){
        this.props.returnState(state)
    }
    render(){
         return(
            <div className={style.floatImg} style={{left:this.state.x,
                top:this.state.y}} onMouseUp={()=>{this.end()}} onMouseDown={()=>{this.end()}}  onTouchEnd={()=>{this.end(event)}} onTouchMove={()=>{this.move(event)}}  onTouchStart={()=>{this.down(event)}} ref="touchImg" onMouseDown={(e)=>this.mousedown(e)} onClick={()=>{this.props.onClose()}}>
                <img src={`${imgUrl}${this.props.url}`} alt=""/>
            </div>
        )
    }
}
const mapStateToProps=(state)=> {
    const {url} = state.customization;
    return {
      url
    };
  }
const mapDispatchToProps = (dispatch) => {
    return {
        
    }
  }
export default connect(mapStateToProps,mapDispatchToProps)(TouchImg);