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

  const ProductionProgressDetailPage(
      {Key key, this.progress, this.colorSizeEntries})
      : super(key: key);

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
              compareFunction: Provider.of<SizeState>(context).compareByName,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [Text('附件：')],
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
                children: [Expanded(child: Text('${widget.progress.remarks}'))],
              ),
            ),
          ],
        ),
      ),
    );
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
    if (widget.progress.productionProgressOrders != null) {
      widget.progress.productionProgressOrders
          .where(
              (element) => element.status == ProductionProgressOrderStatus.PASS)
          .forEach((entry) {
        entry.entries.forEach((element) {
          OrderNoteEntryModel note = result.firstWhere(
              (val) => val.color == element.color && val.size == element.size,
              orElse: () => null);
          if (note != null) {
            note.quantity += element.quantity;
          } else {
            result.add(OrderNoteEntryModel(
                size: element.size,
                color: element.color,
                quantity: element.quantity));
          }
        });
      });
    }
    return result;
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
