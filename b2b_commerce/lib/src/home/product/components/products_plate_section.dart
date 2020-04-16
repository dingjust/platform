import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import '../plate_products_page.dart';

class ProductsPlateSection extends StatelessWidget {
  final double height;

  const ProductsPlateSection({Key key, this.height = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductHomeState>(
        builder: (context, ProductHomeState homteState, _) => Hero(
            tag: 'products',
            child: Container(
              height: height,
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Expanded(child: _TodayNew(homteState)),
                  Container(
                    width: 5,
                  ),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Expanded(
                          child: _Plate(
                              homteState, SeeProductPlateType.SEASON_HOT)),
                      Container(
                        height: 5,
                      ),
                      Expanded(
                          child: _Plate(homteState,
                              SeeProductPlateType.LIVE_BROADCAST_PROVIDE))
                    ],
                  ))
                ],
              ),
            )));
  }
}

class _TodayNew extends StatelessWidget {
  final ProductHomeState homteState;

  const _TodayNew(this.homteState);

  @override
  Widget build(BuildContext context) {
    PlateItem item = homteState.getItem(SeeProductPlateType.TODAY_NEW) ??
        PlateItem(
          title: '今日新款',
          subTitle: '抢先订购',
        );

    //计算今日产品时间起止
    DateTime now = DateTime.now();
    DateTime todayFrom = DateTime(now.year, now.month, now.day);
    DateTime todayTo =
        DateTime(now.year, now.month, now.day).add(Duration(days: 1));

    return Material(
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlateProductsPage(
                  title: '${item.title}',
                  condition: ProductCondition([], '',
                      createdDateFrom: todayFrom, createdDateTo: todayTo),
                    )));
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      '${item.title}',
                      overflow: TextOverflow.clip,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        '${item.subTitle}',
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                      ))
                    ],
                  ),
                ),
                Expanded(
                    child: Row(
                  children: <Widget>[
                    Expanded(
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        child: CachedNetworkImage(
                            imageUrl:
                                '${item?.picture?.previewUrl() ?? 'https://img14.360buyimg.com/cms/jfs/t1/107427/30/10891/37859/5e82d44aE203e3a82/dfe64671abf6ede5.jpg'}',
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) => SpinKitRing(
                                  color: Colors.black12,
                                  lineWidth: 2,
                                  size: 30,
                                ),
                            errorWidget: (context, url, error) => SpinKitRing(
                                  color: Colors.black12,
                                  lineWidth: 2,
                                  size: 30,
                                )),
                      ),
                    ))
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Plate extends StatelessWidget {
  final ProductHomeState homteState;

  final SeeProductPlateType type;

  const _Plate(this.homteState, this.type);

  @override
  Widget build(BuildContext context) {
    PlateItem item = homteState.getItem(type) ??
        PlateItem(
          title: '',
          subTitle: '',
        );

    return Material(
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlateProductsPage(type: type)));
          },
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${item.title}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    Container(height: 5),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${item.subTitle}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )
                  ],
                )),
                Expanded(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    child: CachedNetworkImage(
                        imageUrl:
                            '${item?.picture?.previewUrl() ?? 'https://img10.360buyimg.com/cms/jfs/t1/107713/34/10879/8254/5e82e4c6E04acb6ca/fbf1923587483f4f.jpg'}',
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) => SpinKitRing(
                              color: Colors.black12,
                              lineWidth: 2,
                              size: 30,
                            ),
                        errorWidget: (context, url, error) => SpinKitRing(
                              color: Colors.black12,
                              lineWidth: 2,
                              size: 30,
                            )),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
