import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ExternalSaleOrderEntryDetailPage extends StatelessWidget {
  final ProductionTaskOrderModel entry;

  const ExternalSaleOrderEntryDetailPage({Key key, this.entry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('订单行明细'),
        backgroundColor: Constants.THEME_COLOR_MAIN,
        elevation: 0.5,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            _buildProductRow(),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: ColorSizeEntryTable(
                data: entry.colorSizeEntries,
                compareFunction:
                    Provider.of<SizeState>(context, listen: false).compare,
              ),
            ),
            buildRow('生产数量', '${entry.quantity}'),
            buildRow(
                '合作方式', CooperationModeLocalizedMap[entry.cooperationMode]),
            buildRow('交货日期', DateFormatUtil.formatYMD(entry.deliveryDate)),
            AddressInfoBlock(
              model: entry.shippingAddress,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProductRow({double height = 80.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Hero(
            tag: 'productHero${entry.code}',
            child: ImageFactory.buildThumbnailImage(entry?.product?.thumbnail,
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
                    entry.product.name,
                    style: TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '货号：${entry.product.skuID}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "品类：${entry.product.category.name}",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(255, 133, 148, 1)),
                    ),
                  )
                ],
              ),
            ),
          ),
          RichText(
              text: TextSpan(
                  text: '销售价格：',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  children: [
                TextSpan(
                    text: '￥${entry.unitPrice}',
                    style: TextStyle(color: Color(0xffff1744), fontSize: 20))
              ])),
        ],
      ),
    );
  }

  Widget buildRow(String title, String val) {
    if (val == null || val == '') {
      return Container();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('$title'), Text('$val')],
      ),
    );
  }
}
