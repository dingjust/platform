import 'package:b2b_commerce/src/_shared/widgets/order_status_color.dart';
import 'package:b2b_commerce/src/business/cooperator/cooperator_item.dart';
import 'package:b2b_commerce/src/business/orders/reconciliation/components/fast_reconciliation_sheet_info.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/out_order/form/form_components.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class DeliveryOrderDetailPage extends StatefulWidget {
  final int id;

  ///说否需要回退刷新
  final bool needRefresh;

  const DeliveryOrderDetailPage({Key key, this.id, this.needRefresh = false})
      : super(key: key);

  @override
  _DeliveryOrderDetailPageState createState() =>
      _DeliveryOrderDetailPageState();
}

class _DeliveryOrderDetailPageState extends State<DeliveryOrderDetailPage> {
  FastShippingSheetModel order;

  ///是否需要回调刷新
  bool needRefresh = false;

  @override
  void initState() {
    super.initState();
    if (widget.needRefresh != null) {
      needRefresh = widget.needRefresh;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FastShippingSheetModel>(
      builder: (BuildContext context,
          AsyncSnapshot<FastShippingSheetModel> snapshot) {
        if (snapshot.data != null && order != null) {
          return WillPopScope(
              onWillPop: onPop,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text('出货单详情'),
                  backgroundColor: Constants.THEME_COLOR_MAIN,
                  elevation: 0.5,
                ),
                body: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: ListView(
                    children: <Widget>[
                      CooperatorItem(
                        model: order.cooperator,
                      ),
                      _main(),
                      Container(
                        height: 10,
                      ),
                      FastReconSheetBlock(
                        sheet: order.fastReconciliationSheet,
                      ),
                      _OrderInfo(
                        order: order,
                      )
                    ],
                  ),
                ),
                resizeToAvoidBottomPadding: true,
              ));
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      initialData: null,
      future: _getData(),
    );
  }

  Widget _buildStateRow() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('.${LogisticsSheetStateLocalizedMap[order.state]}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getDeliveryOrderStateColor(order.state)))
        ],
      ),
    );
  }

  ///单据
  Widget _main() {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            _buildStateRow(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [FormLabel('标题：')],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    '${order.title ?? ''}',
                  ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [FormLabel('单据：')],
              ),
            ),
            Row(
              children: [Expanded(child: Attachments(list: order.medias))],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [FormLabel('备注：')],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    '${order.remarks ?? ''}',
                  ))
                ],
              ),
            ),
          ],
        ));
  }

  /// 查询明细
  Future<FastShippingSheetModel> _getData() async {
    if (order == null) {
      FastShippingSheetModel detailModel =
          await DeliveryOrderRespository.getDetail(widget.id);
      order = detailModel;
    }
    return order;
  }

  ///页面回退回调
  Future<bool> onPop() async {
    if (needRefresh != null && needRefresh) {
      Navigator.of(context).pop(true);
      return false;
    } else {
      return true;
    }
  }
}

///订单基础信息
class _OrderInfo extends StatelessWidget {
  final FastShippingSheetModel order;

  final TextStyle _infoStyle = const TextStyle(color: Colors.grey);

  const _OrderInfo({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildInfoRow('订单编号', order.code),
              ),
              GestureDetector(
                onTap: () {
                  copyToClipboard(order.code);
                },
                child: Text(
                  '复制单号',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                  ),
                ),
              )
            ],
          ),
          _buildInfoRow(
              '创建时间', DateFormatUtil.formatYMDHMS(order.creationtime)),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildInfoRow(String title, String val) {
    if (val == '' || val == null) {
      return Container();
    } else {
      return Row(
        children: [
          Container(
            width: 80,
            child: Text(
              '$title：',
              style: _infoStyle,
              textAlign: TextAlign.justify,
            ),
          ),
          Expanded(
              child: Text(
            '$val',
            style: _infoStyle,
          ))
        ],
      );
    }
  }

  ///复制粘贴
  copyToClipboard(final String text) {
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      BotToast.showText(text: '复制到粘贴板');
    }
  }
}
