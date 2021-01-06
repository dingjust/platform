import 'package:b2b_commerce/src/business/orders/sales_production/production_progress/production_progress_order_form_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///节点详情页
class ProductionProgressOrderDetailV2Page extends StatefulWidget {
  ///节点
  final ProductionProgressModel progress;

  ///单据
  final ProductionProgressOrderModel model;

  ///工单下单数
  final List<ColorSizeInputEntry> colorSizeEntries;

  const ProductionProgressOrderDetailV2Page(
      {Key key, this.progress, this.model, this.colorSizeEntries})
      : super(key: key);

  @override
  _ProductionProgressOrderDetailV2PageState createState() =>
      _ProductionProgressOrderDetailV2PageState();
}

class _ProductionProgressOrderDetailV2PageState
    extends State<ProductionProgressOrderDetailV2Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.progress?.progressPhase?.name ?? ''}报工单据明细'),
        elevation: 0.5,
      ),
      bottomNavigationBar: Offstage(
        offstage: widget.model.status == ProductionProgressOrderStatus.CANCEL,
        child: Container(
          height: 50,
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  child: FlatButton(
                    onPressed: () => _edit(),
                    color: Color.fromRGBO(255, 219, 0, 1),
                    child: Text(
                      '修改',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: double.infinity,
                  child: FlatButton(
                    onPressed: () => _cancel(),
                    color: Colors.red,
                    child: Text(
                      '作废',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 10),
        child: ListView(children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                Expanded(child: Text('订单状态：')),
                Text(
                  '${ProductionProgressOrderStatusLocalizedMap[widget.model.status]}',
                  style: TextStyle(color: _ORDER_STATUS_COLORS[widget.model.status]),
                )
              ],
            ),
          ),
          _InfoRow(
            title: '单据号：',
            val: '${widget.model.id}',
          ),
          _InfoRow(
            title: '上报人员：',
            val: '${widget.model.operator?.name}',
          ),
          _InfoRow(
              title: '上报时间：',
              val: '${DateFormatUtil.formatYMDHMS(widget.model.reportTime)}'),
          ColorSizeNoteEntryTable(
            compareFunction: Provider.of<SizeState>(context).compare,
            showNeed: false,
            data: widget.model.entries,
          ),
//          _buildColorSizeInputTable(context),
          _buildMedias(),
          EditableAttachments(
            list: widget.model.medias,
            maxNum: 5,
            editable: false,
          ),
          Divider(),
          _buildRemarks(),
        ]),
      ),
    );
  }

  Container _buildRemarks() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
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
                Expanded(child: Text('${widget.model.remarks ?? '暂无备注'}'))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildMedias() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [Text('附件：')],
      ),
    );
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

  //作废
  void _cancel() async {
    showConfirmDialog(false, message: '是否确认作废？', confirm: () async {
      Function cancelFunc =
          BotToast.showLoading(clickClose: false, crossPage: false);
      var result = await ProgressOrderRepository()
          .deleteProductionProgressOrder(widget.progress.id, widget.model.id);
      cancelFunc.call();
      if (result != null) {
        BotToast.showText(text: '作废成功');
        Navigator.pop(context, true);
      } else {
        BotToast.showText(text: '作废失败');
      }
    });
  }

  //修改单据
  _edit() async{
    dynamic result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductionProgressOrderFormPage(
                  progress: widget.progress,
                  model: widget.model,
                  colorSizeEntries: widget.colorSizeEntries,
                  isEditable: true,
                )));
    if(result != null && result){
      Navigator.pop(context, true);
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

///  生产工单状态颜色
const _ORDER_STATUS_COLORS = {
  ProductionProgressOrderStatus.PASS: Colors.green,
  ProductionProgressOrderStatus.CANCEL: Colors.red,
};
