import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

/// 生产工单列表item
class OutProductionTaskOrderItem extends StatelessWidget {
  final ProductionTaskOrderModel model;

  /// 是否是选择列表
  final bool isSelectList;

  /// item是否被选择
  final bool isSelected;

  /// 回调方法
  final VoidCallback onPressed;

  const OutProductionTaskOrderItem(this.model,
      {this.isSelected = false,
      this.isSelectList = false,
      this.onPressed,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[_header(), _date(), _main()],
        ),
        decoration: BoxDecoration(
            color: isSelected ? Constants.THEME_COLOR_MAIN : Colors.white,
            borderRadius: BorderRadius.circular(12)),
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

  Widget _main(
      {double height = 86.0,
      TextStyle textStyle =
          const TextStyle(color: Color(0xff666666), fontSize: 13)}) {
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
          padding: EdgeInsets.only(left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                model.product.name,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222)),
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '货号：${model.product.skuID}',
                      style: textStyle,
                    ),
                    Text(
                      '品类：${model.product.category?.name}',
                      style: textStyle,
                    )
                  ],
                ),
              ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '订单数：${model.quantity}',
                          style: textStyle,
                        )
                      ],
                    ),
                  ),
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
        Text(
          '${model.code}',
          textAlign: TextAlign.start,
          style: const TextStyle(
              fontSize: 13,
              color: Color(0xff222222),
              fontWeight: FontWeight.w500),
        ),
        Expanded(
            flex: 1,
            child: Container(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${ProductionTaskOrderStateLocalizedMap[model.state]}',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF222222),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ))
      ],
    );
  }

  Widget _date() {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
              child: Text(
                '交货日期：${DateFormatUtil.formatYMD(model.deliveryDate)}',
                style: TextStyle(color: Color(0xffFF4D4F), fontSize: 13),
              ))
        ],
      ),
    );
  }
}
