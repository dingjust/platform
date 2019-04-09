import { NavBar} from 'antd-mobile';
import Icon from 'components/common/Icon/Icon'
import style from "./Header.less"
class Header extends React.Component{
    back() {
        history.go(-1);
    }
    rightContent(){
        if(this.props.rightContent){
            return this.props.rightContent
        }
        return null;
    }
    leftContent(){
        if(this.props.leftContent||this.props.leftContent == ""){
            return this.props.leftContent
        }else{
            return [<span onClick={()=>{this.back()}}><Icon name={`icon-zuojiantou-xuanzezitihecixiu1`} /></span>]
        }
    }
    render(){
        return(
            <NavBar className={style.header}
            mode="dark"
            leftContent={this.leftContent()}
            rightContent={this.rightContent()}
            >{this.props.title}</NavBar>
        )
    }
}

export default Header;