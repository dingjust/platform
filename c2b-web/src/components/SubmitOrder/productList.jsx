import style from "./productList.less"
import { connect } from 'dva';
import {imgUrl} from "~/parameterConfig"
class productList extends React.Component{
    getUserConfig(obj){
        let config = JSON.parse(obj.description)
        let title = []
        config.parts.map((obj)=>{
            title.push(obj.value)
        })
        return title.join();
    }
    render(){
        return(
            <div className={`flexBox ${style.productList}`}>
                <div className={style.img}>
                    <img src={`${imgUrl}${this.props.list.product.image}`} alt=""/>
                </div>
                <div className={`flex1 ${style.pr}`}>
                    <p className={style.title}>{this.props.list.product.name}</p>
                    <p className={style.part}>{this.getUserConfig(this.props.list.userConfig)}</p>
                    <p className={style.numberData}>
                        <span className={style.money}><span>￥</span>{this.props.list.basPrice}</span>
                        <span className={style.quantity}>x {this.props.list.quantity}</span>
                    </p>
                </div>
            </div>
        )
    }
}

export default connect()(productList);