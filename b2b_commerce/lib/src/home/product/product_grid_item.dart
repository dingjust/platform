import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  final ApparelProductModel model;

  static const borderRadius = 10.0;

  const ProductGridItem({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<CertificationStatusHelper>(context, listen: false)
            .oncheckProfile(
                context: context, onJump: () => jumpToDetailPage(context));
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius)),
          padding: EdgeInsets.only(bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildImage(context),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${model.name ?? ''}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: Color(0xff242629),
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Text(
                                  '￥${model?.minPrice ?? ''}',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                              Text(
                                '${getAddressStr()}',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
            ],
          )),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (model?.thumbnail == null) {
      return Container();
    } else {
      const processUrl = 'image_process=resize,w_320/crop,mid,w_320,h_320';
      return ClipRRect(
        //剪裁为圆角矩形
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius)),
        child: CachedNetworkImage(
          imageUrl: '${model.thumbnail.imageProcessUrl(processUrl)}',
          height: 190,
          fit: BoxFit.cover,
          placeholder: (context, url) => SpinKitRing(
            color: Colors.grey[300],
            lineWidth: 2,
            size: 30,
          ),
          errorWidget: (context, url, error) => SpinKitRing(
            color: Colors.grey[300],
            lineWidth: 2,
            size: 30,
          ),
        ),
      );
    }
  }

  String getAddressStr() {
    if (model?.belongTo?.contactAddress?.city != null) {
      return model.belongTo.contactAddress.city.name;
    } else if (model?.belongTo?.contactAddress?.region != null) {
      return model.belongTo.contactAddress.region.name;
    }
    return '';
  }

  void jumpToDetailPage(BuildContext context) {
    //跳转到产品详情页
    Navigator.of(context).pushNamed(AppRoutes.ROUTE_APPAREL_PRODUCT,
        arguments: {'code': model.code});
  }
}

class ProductStaggeredGridItem extends StatelessWidget {
  final ApparelProductModel model;

  static const borderRadius = 12.0;

  const ProductStaggeredGridItem({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<CertificationStatusHelper>(context, listen: false)
            .oncheckProfile(
                context: context, onJump: () => jumpToDetailPage(context));
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius)),
          padding: EdgeInsets.only(bottom: 12),
          child: Column(
            children: <Widget>[
              _buildImage(context),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${model.name ?? ''}',
                        style: TextStyle(
                            color: Color(0xff222222),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              child: RichText(
                                text: TextSpan(
                                    text: '￥',
                                    style: TextStyle(
                                        color: Color(0xFFFF4D4F),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text: '${model?.minPrice ?? ''}',
                                          style: TextStyle(fontSize: 14))
                                    ]),
                              )),
                          Text(
                            '${getAddressStr()}',
                            style: TextStyle(
                                color: Color(0xff999999), fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (model?.thumbnail == null) {
      return Container();
    } else {
      const processUrl = 'image_process=resize,w_320/crop,mid,w_320,h_320';
      return ClipRRect(
        //剪裁为圆角矩形
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius)),
        child: CachedNetworkImage(
          imageUrl: '${model.thumbnail.imageProcessUrl(processUrl)}',
          placeholder: (context, url) => SpinKitRing(
            color: Colors.grey[300],
            lineWidth: 2,
            size: 30,
          ),
          errorWidget: (context, url, error) => SpinKitRing(
            color: Colors.grey[300],
            lineWidth: 2,
            size: 30,
          ),
        ),
      );
    }
  }

  String getAddressStr() {
    if (model?.belongTo?.contactAddress?.city != null) {
      return model.belongTo.contactAddress.city.name;
    } else if (model?.belongTo?.contactAddress?.region != null) {
      return model.belongTo.contactAddress.region.name;
    }
    return '';
  }

  void jumpToDetailPage(BuildContext context) {
    //跳转到产品详情页
    Navigator.of(context).pushNamed(AppRoutes.ROUTE_APPAREL_PRODUCT,
        arguments: {'code': model.code});
  }
}
