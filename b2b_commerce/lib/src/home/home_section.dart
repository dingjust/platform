import 'package:b2b_commerce/src/business/search/apparel_product_search.dart';
import 'package:b2b_commerce/src/home/factory/quick_reaction_factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// 首页Banner
class HomeBannerSection extends StatelessWidget {
  final List<MediaModel> items = <MediaModel>[
    MediaModel(
      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548494182390&di=a7928c3e9b9adb28e71cd84991a28470&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01c16a59016013a80121455009859b.jpg%401280w_1l_2o_100sh.jpg',
    ),
    MediaModel(
      'http://pixdaus.com/files/items/pics/8/28/76828_bc2803f807a3f05873b3f0c105995173_large.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Carousel(items, 240);
  }
}

/// 首页搜索框
class HomeSearchInputBox extends StatelessWidget {
  // final
  final double width;
  final double height;

  const HomeSearchInputBox({Key key, this.width = 300, this.height = 30})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSearch(
          context: context, delegate: ApparelProductSearchDelegate()),
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300], width: 0.5)),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search,
              color: Colors.grey,
            ),
            Text(
              '找点什么...',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

///首页衣报送信息Item项
class HomeInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final String end;

  const HomeInfoItem({Key key, this.label, this.value, this.end})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: label,
          style: TextStyle(fontSize: 12, color: Colors.black),
          children: <TextSpan>[
            TextSpan(text: value, style: TextStyle(color: Colors.red)),
            TextSpan(text: '${end}')
          ]),
    );
  }
}

///首页Tab部分
class HomeTabSection extends StatelessWidget {
  final double height;

  const HomeTabSection({Key key, @required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<AdvanceIconButton> iconList = <AdvanceIconButton>[
      AdvanceIconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuickReactionFactoryPage()));
        },
        title: '地图找厂',
        icon: Icon(
          B2BIcons.factory_map,
          color: Color.fromRGBO(97, 164, 251, 1.0),
          size: 30,
        ),
      ),
      AdvanceIconButton(
        title: '企业集群',
        icon: Icon(
          B2BIcons.industrial_cluster,
          color: Color.fromRGBO(5, 202, 150, 1.0),
          size: 30,
        ),
      ),
      AdvanceIconButton(
        title: '品牌工厂',
        icon: Icon(
          B2BIcons.factory_brand,
          color: Color.fromRGBO(255, 189, 82, 1.0),
          size: 30,
        ),
      ),
      AdvanceIconButton(
        title: '免费打样',
        icon: Icon(
          B2BIcons.free_proofing,
          color: Color.fromRGBO(255, 123, 118, 1.0),
          size: 30,
        ),
      ),
      AdvanceIconButton(
        title: '全部工厂',
        icon: Icon(
          B2BIcons.factory_all,
          color: Color.fromRGBO(148, 161, 246, 1.0),
          size: 30,
        ),
      )
    ];

    return Container(
        height: height,
        color: Colors.white,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: TabBar(
              unselectedLabelColor: Colors.black26,
              labelColor: Colors.orange,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  text: '找工厂',
                ),
                Tab(
                  text: '找设计',
                ),
                Tab(
                  text: '找面辅料',
                )
              ],
              labelStyle: TextStyle(fontSize: 18, color: Colors.black),
              isScrollable: false,
            ),
            body: TabBarView(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: iconList),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '功能完善中，敬请期待！',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '功能完善中，敬请期待！',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
