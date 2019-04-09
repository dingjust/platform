import React from 'react';
import style from "./Index.less"
import { connect } from 'dva';
import IndexList from 'components/Index/IndexList'
import { SearchBar,Carousel,NavBar,Badge} from 'antd-mobile';
import banner1 from 'assets/banner/1.png'
import Icon from 'components/common/Icon/Icon'
// import MainLayout from 'components/MainLayout/MainLayout';
const banner = [
    {
        url:`baidu.com`,
        img:banner1
    }, {
        url:`baidu.com`,
        img:banner1
    }, {
        url:`baidu.com`,
        img:banner1
    }
]
class Index extends React.Component {
    state={
        numberIndex:0,
        animation:[
            {
                "list":[ {
                    "code" : "C2B007",
                    "img" : "/medias/-96Wx96H-C2B007?context=bWFzdGVyfHJvb3R8MjI0NDQ2fGltYWdlL3BuZ3xoMmMvaDA2Lzg3OTgzODkzNzA5MTAucG5nfGVkMWRkMThlYmJlZmQyNzMyMWZlNTQ3M2E0YjVlMjc5Mzk5NWUwZGQyYTlmM2JhNzg3YWZjZDhmYTg3ZjFiMDE",
                    "title" : "女士T恤"
                 }, {
                    "code" : "C2B011",
                    "img" : [
                        "https://www.dingjust.top/imageserver/_ui/images/C2B007/99981f6aadb44e2b128f21628516e327-1.0.png",
                        "https://www.dingjust.top/imageserver/_ui/images/C2B007/2c6dfdf981d7b0f0b5e8a707830c3faf-1.0.png"
                    ],
                    "title" : "女士工装外套"
                 }, {
                    "code" : "C2B005",
                    "img" : "/medias/-96Wx96H-C2B005?context=bWFzdGVyfHJvb3R8NDE3Nzk0fGltYWdlL3BuZ3xoYmMvaGU5Lzg3OTg0MjMyODU3OTAucG5nfDg1NmZhMzI5ZThmNGIxNWZlZjU2YzMwY2NhY2QxNmNlODJlMDAxYjQ3NjdmMTYzYTQ0MTA2NmI1YWUyZTE0Y2E",
                    "title" : "女士衬衣"
                 } ],
                "title" : "测试"
            },
            {
                "list":[ {
                    "code" : "C2B007",
                    "img" : "/medias/-96Wx96H-C2B007?context=bWFzdGVyfHJvb3R8MjI0NDQ2fGltYWdlL3BuZ3xoMmMvaDA2Lzg3OTgzODkzNzA5MTAucG5nfGVkMWRkMThlYmJlZmQyNzMyMWZlNTQ3M2E0YjVlMjc5Mzk5NWUwZGQyYTlmM2JhNzg3YWZjZDhmYTg3ZjFiMDE",
                    "title" : "女士T恤"
                 }, {
                    "code" : "C2B011",
                    "img" : [
                        "https://www.dingjust.top/imageserver/_ui/images/C2B007/99981f6aadb44e2b128f21628516e327-1.0.png",
                        "https://www.dingjust.top/imageserver/_ui/images/C2B007/2c6dfdf981d7b0f0b5e8a707830c3faf-1.0.png"
                    ],
                    "title" : "女士工装外套"
                 }, {
                    "code" : "C2B005",
                    "img" : "/medias/-96Wx96H-C2B005?context=bWFzdGVyfHJvb3R8NDE3Nzk0fGltYWdlL3BuZ3xoYmMvaGU5Lzg3OTg0MjMyODU3OTAucG5nfDg1NmZhMzI5ZThmNGIxNWZlZjU2YzMwY2NhY2QxNmNlODJlMDAxYjQ3NjdmMTYzYTQ0MTA2NmI1YWUyZTE0Y2E",
                    "title" : "女士衬衣"
                 } ],
                "title" : "测试"
            },
            {
                "list":[ {
                    "code" : "C2B007",
                    "img" : "/medias/-96Wx96H-C2B007?context=bWFzdGVyfHJvb3R8MjI0NDQ2fGltYWdlL3BuZ3xoMmMvaDA2Lzg3OTgzODkzNzA5MTAucG5nfGVkMWRkMThlYmJlZmQyNzMyMWZlNTQ3M2E0YjVlMjc5Mzk5NWUwZGQyYTlmM2JhNzg3YWZjZDhmYTg3ZjFiMDE",
                    "title" : "女士T恤"
                 }, {
                    "code" : "C2B011",
                    "img" : [
                        "https://www.dingjust.top/imageserver/_ui/images/C2B007/99981f6aadb44e2b128f21628516e327-1.0.png",
                        "https://www.dingjust.top/imageserver/_ui/images/C2B007/2c6dfdf981d7b0f0b5e8a707830c3faf-1.0.png"
                    ],
                    "title" : "女士工装外套"
                 }, {
                    "code" : "C2B005",
                    "img" : "/medias/-96Wx96H-C2B005?context=bWFzdGVyfHJvb3R8NDE3Nzk0fGltYWdlL3BuZ3xoYmMvaGU5Lzg3OTg0MjMyODU3OTAucG5nfDg1NmZhMzI5ZThmNGIxNWZlZjU2YzMwY2NhY2QxNmNlODJlMDAxYjQ3NjdmMTYzYTQ0MTA2NmI1YWUyZTE0Y2E",
                    "title" : "女士衬衣"
                 } ],
                "title" : "测试"
            },
            {
            "list":[ {
                "code" : "C2B007",
                "img" : "/medias/-96Wx96H-C2B007?context=bWFzdGVyfHJvb3R8MjI0NDQ2fGltYWdlL3BuZ3xoMmMvaDA2Lzg3OTgzODkzNzA5MTAucG5nfGVkMWRkMThlYmJlZmQyNzMyMWZlNTQ3M2E0YjVlMjc5Mzk5NWUwZGQyYTlmM2JhNzg3YWZjZDhmYTg3ZjFiMDE",
                "title" : "女士T恤"
             }, {
                "code" : "C2B011",
                "img" : [
                    "https://www.dingjust.top/imageserver/_ui/images/C2B007/99981f6aadb44e2b128f21628516e327-1.0.png",
                    "https://www.dingjust.top/imageserver/_ui/images/C2B007/2c6dfdf981d7b0f0b5e8a707830c3faf-1.0.png"
                ],
                "title" : "女士工装外套"
             }, {
                "code" : "C2B005",
                "img" : "/medias/-96Wx96H-C2B005?context=bWFzdGVyfHJvb3R8NDE3Nzk0fGltYWdlL3BuZ3xoYmMvaGU5Lzg3OTg0MjMyODU3OTAucG5nfDg1NmZhMzI5ZThmNGIxNWZlZjU2YzMwY2NhY2QxNmNlODJlMDAxYjQ3NjdmMTYzYTQ0MTA2NmI1YWUyZTE0Y2E",
                "title" : "女士衬衣"
             } ],
            "title" : "测试"
        }]
    }
    componentDidMount(){
        // 触发
        this.refs.indexMain.addEventListener('scroll', this.orderScroll.bind(this));
    }
    orderScroll() {
        let listNumber = this.props.data.length;
        let windowHeight = window.screen.height;
        // let centerBot = center*2; 
        let indexHeight = this.refs.indexMain.scrollHeight; //文本高度
        let maringTop = this.refs.searchBar.clientHeight-this.refs.carousel.clientHeight;//顶部导航等高度
        let ollListHeight = indexHeight - maringTop //去除顶部距离总剩余列表总高度
        let itemHeight = ollListHeight/listNumber //单列高度
        let numberIndex = Math.round((this.refs.indexMain.scrollTop-maringTop)/itemHeight) // 返回居中的为第几列
        // console.log('scroll');
        // console.log(this.refs.indexMain.scrollTop)
        // console.log(`图片高度${itemHeight}`)
        // console.log(`列表起点${indexHeight-ollListHeight}`)
        // console.log(`返回第几列动画${numberIndex}`)
        this.setState({
            numberIndex:numberIndex
        })
        return numberIndex;
    }
    render(){
        return ( 
            <div ref='indexMain' className={style.indexMain} >
                <div ref='searchBar' className={`flexBox ${style.topNav}`}>
                    <div className={`flex1`}>
                        <SearchBar placeholder="请输入您想定制的商品" />
                    </div>
                    <div className={style.news}>
                        <Icon name={`icon-xiaoxi1`}></Icon>
                        <span className={style.badge}>12</span>
                    </div>
                </div>
                <div ref='carousel'>
                    <Carousel
                    autoplay={false}
                    infinite
                    className={style.banner}
                    beforeChange={(from, to) => console.log(`slide from ${from} to ${to}`)}
                    afterChange={index => console.log('slide to', index)}
                    >
                    {banner.map(val => (
                        <a
                        key={val}
                        // href={val.url}
                        style={{ display: 'inline-block', width: '100%' }}
                        >

                        <img
                            src={val.img}
                            alt=""
                            style={{ width: '100%', verticalAlign: 'top' }}
                            onLoad={() => {
                            // fire window resize event to change height
                            window.dispatchEvent(new Event('resize'));
                            // this.setState({ imgHeight: 'auto' });
                            }}
                        />
                        </a>
                    ))}
                    </Carousel>
                </div>
                {/* {
                    this.state.animation&&this.state.animation.map((obj,index) => (
                        // <IndexList title = { obj.title }
                        // iconName = { obj.iconName }
                        // list = { obj.list }
                        // />
                        <IndexList animationState={this.state.numberIndex == index} title={obj.title} list = {obj.list}></IndexList>
                    ))
                }  */}
                {
                    this.props.data&&this.props.data.map((obj,index) => (
                        <IndexList title = { obj.title }
                        animationState={this.state.numberIndex == index} 
                        iconName = { obj.iconName }
                        list = { obj.list }
                        />
                    ))
                } 
            </div>
        )
    }
    
}

const mapStateToProps=(state)=>{
    const { data } = state.index;
    return {
        data
    };
}
export default connect(mapStateToProps)(Index);