import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/order_status_color.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/progress_work_sheet/progress_work_sheet_detail_page.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

/// 生产进度块
class ProgressWorkSheetItem extends StatelessWidget {
  final ProgressWorkSheetModel model;

  const ProgressWorkSheetItem({Key key, this.model}) : super(key: key);

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
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
      ),
      onTap: () async {
        print('------------------------');
        dynamic result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProgressWorkSheetDetailPage(
                      code: model.code,
                    )));
        if (result != null) {
          Provider.of<ProgressWorkSheetState>(context, listen: false).clear();
        }
      },
    );
  }

  Widget _foot() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('生产数量：${productQuantity()}'),
            Text('交货日期：${DateFormatUtil.formatYMD(model.expectedDeliveryDate)}')
          ],
        ),
        Row(
          children: [Text('工单负责人：${model.personInCharge?.name ?? ''}')],
        )
      ],
    );
  }

  productQuantity() {
    int count = 0;
    model.colorSizeEntries.forEach((entry) {
      if (entry.quantity != null) {
        count += entry.quantity;
      }
    });
    return count;
  }

  Widget _main({double height = 80.0}) {
    return Row(
      children: [
        Hero(
          tag: 'productHero${model.id}',
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
                        fontSize: 15, color: Color.fromRGBO(255, 133, 148, 1)),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            '单号：${model.code}',
            textAlign: TextAlign.start,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500),
          ),
        ),
        _getOrderStatus(),
      ],
    );
  }

  ///订单状态
  Widget _getOrderStatus() {
    return Text(
      '${ProgressWorkSheetStatusLocalizedMap[model.status]}',
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: 18,
        color: PROGRESS_WORK_SHEET_STATUS_COLORS[model.status],
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
