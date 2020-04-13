import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductsSection extends StatelessWidget {
  final double height;

  const ProductsSection({Key key, this.height = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Expanded(child: _TodayNew()),
          Container(
            width: 5,
          ),
          Expanded(
              child: Column(
            children: <Widget>[
              Expanded(
                  child: _Plate(
                title: '1',
                subTitle: '2',
                onTap: () {},
                src:
                    'https://img14.360buyimg.com/cms/jfs/t1/107427/30/10891/37859/5e82d44aE203e3a82/dfe64671abf6ede5.jpg',
              )),
              Container(
                height: 5,
              ),
              Expanded(
                  child: _Plate(
                title: '1',
                subTitle: '2',
                onTap: () {},
                src:
                    'https://img14.360buyimg.com/cms/jfs/t1/107427/30/10891/37859/5e82d44aE203e3a82/dfe64671abf6ede5.jpg',
              ))
            ],
          ))
        ],
      ),
    );
  }
}

class _TodayNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.ROUTE_ORDER_PRODUCTS_INDEX);
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
                      '今日新款',
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
                        '今日新款',
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
                      child: CachedNetworkImage(
                          imageUrl:
                              'https://img14.360buyimg.com/cms/jfs/t1/107427/30/10891/37859/5e82d44aE203e3a82/dfe64671abf6ede5.jpg',
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
                    )
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
  final String title;

  final String subTitle;

  final VoidCallback onTap;

  final String src;

  const _Plate({Key key, this.title, this.subTitle, this.onTap, this.src})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: InkWell(
          onTap: onTap,
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
                            '$title',
                            style: TextStyle(fontSize: 18),
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
                            '${subTitle}',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )
                  ],
                )),
                Expanded(
                  child: CachedNetworkImage(
                      imageUrl: '$src',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
