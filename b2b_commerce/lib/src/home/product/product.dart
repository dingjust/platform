import 'package:b2b_commerce/src/home/product/product_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class RecommendProductItem extends StatelessWidget {
  const RecommendProductItem(
      {Key key,
      this.model,
      this.imageSize = 200,
      this.showAddress = false,
      this.onClick})
      : super(key: key);

  final ApparelProductModel model;

  final double imageSize;

  final bool showAddress;

  ///点击回调
  final VoidCallback onClick;

  static Map<ProductType, Color> _tagColors = {
    ProductType.FUTURE_GOODS: Color.fromRGBO(20, 138, 255, 1),
    ProductType.SPOT_GOODS: Color.fromRGBO(255, 137, 12, 1),
    ProductType.TAIL_GOODS: Color.fromRGBO(255, 214, 12, 1),
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          if (onClick != null) {
            onClick();
          }
          //跳转到产品详情页
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetailPage(model.code)));
        },
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: <Widget>[
                  model?.thumbnails != null &&
                          model.thumbnails.isNotEmpty &&
                          model?.thumbnails[0].url != null
                      ? Container(
                          width: 200,
                          height: 200,
                          child: CachedNetworkImage(
                              imageUrl: '${model?.thumbnails[0].normalUrl()}',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5)),
                                    ),
                                  ),
                              placeholder: (context, url) => SpinKitCircle(
                                    color: Colors.black12,
                                    size: 60,
                                  ),
                              errorWidget: (context, url, error) =>
                                  SpinKitCircle(
                                    color: Colors.black12,
                                    size: 60,
                                  )),
                        )
                      : Container(
                          height: imageSize,
                          padding: EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)),
                              image: DecorationImage(
                                image: AssetImage(
                                  'temp/picture.png',
                                  package: "assets",
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: imageSize,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: Text(
                                    '${model.name}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                '销量${model.salesVolume ?? 0}件',
                                style:
                                TextStyle(color: Colors.grey, fontSize: 10),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: RichText(
                                  text: TextSpan(
                                      text: '￥',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 14),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '${model?.minPrice ?? ''}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ]),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: showAddress
                                      ? Container(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          model.belongTo.contactAddress !=
                                              null
                                              ? '${model.belongTo.contactAddress
                                              ?.region?.name ?? ''}${model
                                              .belongTo.contactAddress?.city
                                              ?.name ?? ''}'
                                              : '',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color.fromRGBO(
                                                  149, 149, 149, 1)),
                                        ),
                                        Text(
                                          '',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color.fromRGBO(
                                                  149, 149, 149, 1)),
                                        )
                                      ],
                                    ),
                                  )
                                      : Container())
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            buildProductTypeTag()
          ],
        ));
  }

  Widget buildProductTypeTag() {
    ProductType type = ProductType.FUTURE_GOODS;
    if (model.productType != null) {
      if (model.productType.length == 1) {
        type = model.productType.first;
      } else if (model.productType.length > 1) {
        type = ProductType.SPOT_GOODS;
      }
    }
    return RecommendProductTag(
      Text(
        ProductTypeLocalizedMap[type],
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
      height: 50,
      width: 50,
      color: _tagColors[type],
    );
  }
}
