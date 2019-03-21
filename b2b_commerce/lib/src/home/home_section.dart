import 'package:b2b_commerce/src/business/search/apparel_product_search.dart';
import 'package:b2b_commerce/src/common/screen_conditions.dart';
import 'package:b2b_commerce/src/home/factory/quick_reaction_factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'factory/industrial_cluster_factory.dart';

/// 首页Banner
class HomeBannerSection extends StatelessWidget {
  final List<MediaModel> items = <MediaModel>[
    MediaModel(
      url: 'http://dingjust.oss-cn-shenzhen.aliyuncs.com/head.jpg',
    ),
    MediaModel(
      url:
          'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20190126151855.jpg',
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
  final String tips;

  const HomeSearchInputBox(
      {Key key, this.width = 400, this.height = 30, this.tips})
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
              B2BIcons.search,
              color: Colors.grey,
              size: 18,
            ),
            Text(
              tips == null ? '   找点什么...' : tips,
              style: TextStyle(color: Colors.grey, fontSize: 16),
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
          style: TextStyle(
            fontSize: 13,
            color: Color.fromRGBO(32, 32, 32, 1),
          ),
          children: <TextSpan>[
            TextSpan(
                text: value,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.red,
                    fontWeight: FontWeight.bold)),
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
              builder: (context) => ScreenConditions(
                    route: '地图找厂',
                  )));
        },
        title: '地图找厂',
        isHot: true,
        icon: Icon(
          B2BIcons.factory_map,
          color: Color.fromRGBO(97, 164, 251, 1.0),
          size: 30,
        ),
      ),
      AdvanceIconButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => IndustrialClusterPage()));
        },
        title: '产业集群',
        icon: Icon(
          B2BIcons.industrial_cluster,
          color: Color.fromRGBO(5, 202, 150, 1.0),
          size: 30,
        ),
      ),
      AdvanceIconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScreenConditions(
                    route: '品牌工厂',
                  )));
        },
        title: '品牌工厂',
        icon: Icon(
          B2BIcons.factory_brand,
          color: Color.fromRGBO(255, 189, 82, 1.0),
          size: 30,
        ),
      ),
      AdvanceIconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ScreenConditions(
                    route: '免费打样',
                  )));
        },
        title: '免费打样',
        icon: Icon(
          B2BIcons.free_proofing,
          color: Color.fromRGBO(255, 123, 118, 1.0),
          size: 30,
        ),
      ),
      AdvanceIconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuickReactionFactoryPage(
                      route: '全部工厂',
                    )),
          );
        },
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
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: iconList),
      ),
    );
  }
}
