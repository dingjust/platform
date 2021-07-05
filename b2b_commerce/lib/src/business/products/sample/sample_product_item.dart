import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class SampleProductGridItem extends StatelessWidget {
  final ValueChanged<SampleProductModel> onItemTap;

  final VoidCallback onItemLongPress;

  final isSelected;

  final SampleProductModel model;

  const SampleProductGridItem(
      {Key key,
      this.model,
      this.onItemTap,
      this.onItemLongPress,
      this.isSelected = false})
      : super(key: key);

  static const borderRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      onLongPress: () => onLongPress(context),
      child: Container(
          decoration: BoxDecoration(
              color:
                  isSelected ? Color.fromRGBO(255, 214, 12, 0.2) : Colors.white,
              borderRadius: BorderRadius.circular(borderRadius)),
          padding: EdgeInsets.only(bottom: 5),
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildImage(context),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${model.name ?? ''}',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              '款号：${model.skuID ?? ''}',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
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
                      flex: 1,
                      child: Text(
                        '品类：${model?.category?.name ?? ''}',
                        style: TextStyle(color: Colors.black54, fontSize: 10),
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
    if (model?.images == null || model.images.isEmpty) {
      return Container();
    } else {
      const processUrl = 'image_process=resize,w_320/crop,mid,w_320,h_320';
      return ClipRRect(
        //剪裁为圆角矩形
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius)),
        child: CachedNetworkImage(
          imageUrl: '${model.images.first.imageProcessUrl(processUrl)}',
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

  void onTap(BuildContext context) {
    //有点击事件调用
    if (onItemTap != null) {
      onItemTap.call(model);
    } else {
      // 没有则跳转详情页
      Navigator.of(context).pushNamed(AppRoutes.ROUTE_SAMPLE_PRODUCT,
          arguments: {'code': model.code}).then((value) {
        Provider.of<SampleProductsState>(context, listen: false).clear();
      });
    }
  }

  void onLongPress(BuildContext context) {
    if (onItemLongPress != null) {
      onItemLongPress.call();
    }
  }
}
