import 'package:b2b_commerce/src/business/search/apparel_product_search.dart';
import 'package:b2b_commerce/src/common/find_factory_by_map.dart';
import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'factory/industrial_cluster_factory.dart';

/// 首页Banner
class HomeBannerSection extends StatelessWidget {
  final List<MediaModel> items = <MediaModel>[
    MediaModel(
      url: 'http://dingjust.oss-cn-shenzhen.aliyuncs.com/banner.png',
    ),
    MediaModel(
      url: 'https://dingjust.oss-cn-shenzhen.aliyuncs.com/banner2.png',
    )
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
          border: Border.all(color: Colors.grey[300], width: 0.5),
        ),
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
