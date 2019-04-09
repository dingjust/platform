import React from "react"
import style from "./CustomizationComponents.less"
import { connect } from 'dva';
import { Modal,NavBar, Toast} from 'antd-mobile';
import IconBg from "components/common/Icon/IconBg"
import CustomizationComponentsList from "components/Customization/CustomizationComponentsList"
import hint from "assets/customization/hint.png"
import {HybrisImgUrl,durationTime} from "~/parameterConfig"
import default_ from "assets/customization/default.png"
import { routerRedux } from 'dva/router';
import queryString from 'query-string';


class ComponentsItem extends React.Component{
    render(){
        return(
            <div className={`${style.componentsItem} ${this.props.newClass}`}>
                <img src={this.props.img} alt=""/>
                <p className={style.textCenter}>{this.props.name}</p>
            </div>
        )
    }
}

class CustomizationComponents extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
          modal: false,
          hint:true,
          index_:0
        };
      }
      showModal = (key,index) => (e) => {

        e.preventDefault(); // 修复 Android 上点击穿透
        this.setState({
          [key]: true,
        });
        this.setState({
            index_:index
        })
        this.props.abstractPartsKey(index)
        this.setState({
            hint: false
        });

        if(index==0){
            this.props.getColor()
            this.props.getTexture()
        }
      }
      onClose = key => () => {
        this.setState({
          [key]: false,
        });
      }
      componentWillReceiveProps=(nextProps)=> {
        if (nextProps.abstractParts !== this.props.abstractParts) {
            this.setState({
                mark: Array(nextProps.abstractParts.length)
            });
        }
     }
      
      render(){
        return(
            <div className={`customizationComponents`}>
                {/* {
                   this.state.hint !=false?<img hint className={style.hint} src={hint} alt="引导" />:''
                } */}
                <div className={style.componentsBg}>
                    <div onClick={()=>{this.props.goURL('preConfiguration')}}>
                        <ComponentsItem img={default_} name={`为你选择`} />
                    </div>
                    {this.props.abstractParts.map((data,index)=>(
                        <div className={`pr`}  onClick={this.showModal('modal',index)}>
                            {
                                data.parts[data.list_index].mark?
                                <span className={style.mark}></span>: null
                            }
                            <ComponentsItem newClass={this.state.index_ == index?style.active:``} img={`${HybrisImgUrl}${data.parts[data.list_index].thumbnail}`} name={data.name} />
                        </div>
                    ))}
                </div>
                
                <Modal
                    className={style.componentsModal}
                    popup
                    visible={this.state.modal}
                    onClose={this.onClose('modal')}
                    animationType="slide-up"
                >
                   <NavBar
                        leftContent={[
                            <span className={style.tabBg}>{this.props.abstractParts[this.state.index_]&&this.props.abstractParts[this.state.index_].name}</span>
                        ]}
                        rightContent={[
                        <div onClick={this.onClose('modal')}>
                            <IconBg newClass={style.sixClose} name={`icon-17cuowu`}/>
                        </div>
                        ]}
                    ></NavBar>
                    <CustomizationComponentsList type={
                        this.props.abstractParts[this.state.index_]&&this.props.abstractParts[this.state.index_].name=='面料'?0:1
                    } list={this.props.abstractParts[this.state.index_]} onClose={this.onClose(`modal`)}/>
                </Modal>
            </div>
    )}
}

const mapStateToProps=(state)=>{
    const {abstractParts} = state.customization;
    return {
      abstractParts
    };
  }
  const mapDispatchToProps = (dispatch) => {
    return {
        abstractPartsKey: (abstractPartsKey) =>{
            dispatch({ type: 'customization/getAbstractPartsKey',payload:abstractPartsKey});
        },
        getColor:()=>{
            dispatch({type:'customization/getColor'})
        },
        getTexture:()=>{
            dispatch({type:'customization/getTexture'})
        },
        goURL:(url)=>{
            const code = location.hash.split('?')
            dispatch(routerRedux.push({
                pathname: url,
                search:code[1]
            }));
        }
    }
  }
  export default connect(mapStateToProps,mapDispatchToProps)(CustomizationComponents);