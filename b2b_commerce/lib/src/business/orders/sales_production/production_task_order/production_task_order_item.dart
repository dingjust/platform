import 'package:b2b_commerce/src/_shared/widgets/order_status_color.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:core/core.dart';

import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

/// 生产工单列表item
class ProductionTaskOrderItem extends StatelessWidget {
  final ProductionTaskOrderModel model;

  /// 是否是选择列表
  final bool isSelectList;

  /// item是否被选择
  final bool isSelected;

  /// 回调方法
  final VoidCallback onPressed;

  const ProductionTaskOrderItem(this.model,
      {this.isSelected = false,
      this.isSelectList = false,
      this.onPressed,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        // height: 120,
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[_header(), _main(), _foot()],
        ),
        decoration: BoxDecoration(
            color: isSelected ? Constants.THEME_COLOR_MAIN : Colors.white,
            borderRadius: BorderRadius.circular(10)),
      ),
      onTap: () async {
        if (isSelectList) {
          onPressed();
        } else {
          dynamic result = await Navigator.of(context).pushNamed(
              AppRoutes.ROUTE_PRODUCTION_TASK_ORDER_DETAIL,
              arguments: model.id);
          if (result != null) {
            Provider.of<ProductionTaskOrdersState>(context, listen: false)
                .clear();
          }
        }
      },
    );
  }

  Widget _foot() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('订单数量：${model.quantity}'),
      Text('交货时间：${DateFormatUtil.formatYMD(model.deliveryDate)}')
    ]);
  }

  Widget _main({double height = 80.0}) {
    return Row(
      children: [
        Hero(
          tag: 'productHero${model.code}',
          child: ImageFactory.buildThumbnailImage(model.product?.thumbnail,
              containerSize: height),
        ),
        Expanded(
            child: Container(
              height: height,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.product.name,
                    style: TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '货号：${model.product.skuID}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '品类：${model.product.category?.name}',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(255, 133, 148, 1)),
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            flex: 2,
            child: Text(
              '单号：${model.code}',
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            )),
        _buildTag(),
        Expanded(
            flex: 1,
            child: Container(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${ProductionTaskOrderStateLocalizedMap[model.state]}',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 18,
                      color: getProductionTaskOrderStateColor(model.state),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ))
      ],
    );
  }

  Widget _buildTag() {
    print(model.outOrder);
    //自创外接订单无originCompany
    return model.outboundOrderCode == null
        ? Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Color.fromRGBO(68, 138, 255, 1))),
      child: Center(
        child: Text(
          '未外发',
          style: TextStyle(
              color: Color.fromRGBO(68, 138, 255, 1), fontSize: 10),
        ),
      ),
    )
        : Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Constants.THEME_COLOR_MAIN)),
      child: Center(
        child: Text(
          '已外发',
          style:
          TextStyle(color: Constants.THEME_COLOR_MAIN, fontSize: 10),
        ),
      ),
    );
  }
}
