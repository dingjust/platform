import 'package:b2b_commerce/src/business/orders/sales_production/production_progress/production_progress_order_detail_v2_page.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/production_progress/production_progress_order_form_page.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///节点详情页
class ProductionProgressDetailPage extends StatefulWidget {
  ///节点
  final ProductionProgressModel progress;

  ///工单下单数
  final List<ColorSizeEntryV2Model> colorSizeEntries;

  const ProductionProgressDetailPage({
    Key key,
    this.progress,
    this.colorSizeEntries,
  }) : super(key: key);

  @override
  _ProductionProgressDetailPageState createState() =>
      _ProductionProgressDetailPageState();
}

class _ProductionProgressDetailPageState
    extends State<ProductionProgressDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.progress.progressPhase.name}'),
        elevation: 0.5,
      ),
      bottomNavigationBar: Container(
        height: 50,
        width: double.infinity,
        child: FlatButton(
          onPressed: () => _reportQuantity(),
          color: const Color.fromRGBO(255, 219, 0, 1),
          child: Text(
            '上报数量',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 10),
        child: ListView(
          children: <Widget>[
            _InfoRow(
              title: '预计完成时间：',
              val: '${DateFormatUtil.formatYMD(widget.progress.estimatedDate)}',
            ),
            _InfoRow(
              title: '实际完成时间：',
              val: '${DateFormatUtil.formatYMD(widget.progress.finishDate)}',
            ),
            _InfoRow(
              title: '实际数量/预计数量：',
              val: '$actualNum/$expectNum',
            ),
            ColorSizeNoteEntryTable(
              data: totalEntries,
              compareFunction:
                  Provider.of<SizeState>(context, listen: false).compareByName,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [Text('上报记录：')],
              ),
            ),
            for (ProductionProgressOrderModel order
            in widget.progress?.productionProgressOrders ?? [])
              _OrderItem(
                model: order,
                onItemTap: () => orderDeatil(context, order),
              ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [Text('附件：')],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
              child: Row(
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: '参考图片',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      TextSpan(
                        text: '（若无图片可不上传）',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            Attachments(list: widget.progress.medias),
            Divider(),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [Text('备注：')],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(child: Text('${widget.progress.remarks ?? '暂无备注'}'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void orderDeatil(BuildContext context,
      ProductionProgressOrderModel order) async {
    dynamic result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductionProgressOrderDetailV2Page(
                  progress: widget.progress,
                  model: order,
                  colorSizeEntries: order.entries
                      ?.map((e) =>
                      ColorSizeInputEntry(
                          color: e.color,
                          size: e.size,
                          quantity: e.quantity))
                      ?.toList() ??
                      [],
                )));
    if (result != null && result) {
      await _refreshData();
    }
  }

  ///实际数量
  int get actualNum {
    int result = 0;
    if (widget.progress.productionProgressOrders != null) {
      widget.progress.productionProgressOrders
          .where(
              (element) => element.status == ProductionProgressOrderStatus.PASS)
          .forEach((item) {
        result += item.amount;
      });
    }
    return result;
  }

  ///预计数量
  int get expectNum {
    int result = 0;
    if (widget.colorSizeEntries != null) {
      widget.colorSizeEntries.forEach((item) {
        result += item.quantity;
      });
    }
    return result;
  }

  ///合并有效单据entry
  List<OrderNoteEntryModel> get totalEntries {
    List<OrderNoteEntryModel> result = [];
    //构造订单需要
    if (widget.colorSizeEntries != null) {
      widget.colorSizeEntries.forEach((element) {
        result.add(OrderNoteEntryModel(
            size: element.size.name,
            color: element.color.name,
            quantity: 0,
            needQuantity: element.quantity));
      });
    }

    if (widget.progress.productionProgressOrders != null) {
      widget.progress.productionProgressOrders
          .where((element) =>
              element.status == ProductionProgressOrderStatus.PASS &&
              element.entries != null)
          .forEach((entry) {
        entry.entries.forEach((element) {
          OrderNoteEntryModel note = result.firstWhere(
              (val) => val.color == element.color && val.size == element.size,
              orElse: () => null);
          if (note != null) {
            note.quantity += element.quantity;
          }
        });
      });
    }
    return result;
  }

  //上报数量
  void _reportQuantity({ProductionProgressOrderModel model}) async {
    ProductionProgressOrderModel productionProgressOrderModel = model;
    if (productionProgressOrderModel == null) {
      productionProgressOrderModel = new ProductionProgressOrderModel();
    }
    if (productionProgressOrderModel.medias == null) {
      productionProgressOrderModel.medias = [];
    }
    if (productionProgressOrderModel.reportTime == null) {
      productionProgressOrderModel.reportTime = DateTime.now();
    }
    if (productionProgressOrderModel.entries == null) {
      productionProgressOrderModel.entries = [];
    }
    productionProgressOrderModel.operator = new B2BCustomerModel(
        id: UserBLoC().currentUser.id, name: UserBLoC().currentUser.name);

    List<ColorSizeInputEntry> _colorSizeEntries = [];

    _colorSizeEntries = widget.colorSizeEntries
        .map((e) =>
        ColorSizeInputEntry(
          size: e.size.name,
          color: e.color.name,
        ))
        .toList();

    dynamic result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductionProgressOrderFormPage(
                  progress: widget.progress,
                  model: productionProgressOrderModel,
                  colorSizeEntries: _colorSizeEntries,
                )));

    if (result != null && result) {
      await _refreshData();
    }
  }

  Future _refreshData() async {
    ProgressWorkSheetModel model =
    await ProgressWorkSheetRepository().detail(widget.progress.belong.code);
    if (model != null) {
      setState(() {
        widget.progress.productionProgressOrders = model.progresses
            .firstWhere((element) => element.id == widget.progress.id,
            orElse: () => null)
            ?.productionProgressOrders;
      });
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String val;

  const _InfoRow({Key key, this.title, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

class _OrderItem extends StatelessWidget {
  final ProductionProgressOrderModel model;

  final VoidCallback onItemTap;

  const _OrderItem({Key key, this.model, this.onItemTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 0.5, color: Colors.grey[300]),
                bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text('单号：${model.id}')),
                Text(
                  '${ProductionProgressOrderStatusLocalizedMap[model.status]}',
                  style: TextStyle(color: _ORDER_STATUS_COLORS[model.status]),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RichText(
                      text: TextSpan(
                          text: '数量：',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                          children: [
                        TextSpan(
                            text: '${model.amount}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: model.status ==
                                        ProductionProgressOrderStatus.PASS
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                      ])),
                ),
                Text('上报人：${model.operator.name}'),
              ],
            ),
            Row(
              children: [
                Text('上报时间：${DateFormatUtil.formatYMD(model.reportTime)}'),
              ],
            )
          ],
        ),
      ),
    );
  }
}

///  生产工单状态颜色
const _ORDER_STATUS_COLORS = {
  ProductionProgressOrderStatus.PASS: Colors.green,
  ProductionProgressOrderStatus.CANCEL: Colors.red,
};
