import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///节点详情页
class ProductionProgressOrderDetailV2Page extends StatefulWidget {
  ///单据
  final ProductionProgressOrderModel model;

  ///工单下单数
  final List<ColorSizeInputEntry> colorSizeEntries;

  const ProductionProgressOrderDetailV2Page({Key key, this.model, this.colorSizeEntries})
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
      appBar: AppBar(
        centerTitle: true,
        title: Text('报工单据明细'),
        elevation: 0.5,
      ),
      bottomNavigationBar: Container(
        height: 50,
        width: double.infinity,
        child: FlatButton(
          onPressed: () => _cancel(),
          color: const Color.fromRGBO(255, 219, 0, 1),
          child: Text(
            '作废',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 10),
        child: ListView(children: <Widget>[
          _InfoRow(
            title: '单据号：',
            val: '${widget.model.id}',
          ),
//          _InfoRow(
//            title: '款号：',
//            val: '${widget.model.belong.belong.skuID}',
//          ),
//          _InfoRow(
//            title: '合作商：',
//            val: '${widget.model.belong.belong.cooperator?.name}',
//          ),
          _InfoRow(
            title: '上报人员：',
            val: '${widget.model.operator?.name}',
          ),
          _InfoRow(
            title: '上报时间',
            val: '${DateFormatUtil.formatYMDHMS(widget.model.reportTime)}'
          ),
          ColorSizeEntryTable(
            data: widget.model.entries?.map((e) => ColorSizeEntryV2Model(color: ColorModel(name: e.color),size: SizeModel(name:e.size),quantity: e.quantity))?.toList() ?? [],
            compareFunction: Provider.of<SizeState>(context).compare,
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

      child: Row(
        children: [

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

  ColorSizeInputTable _buildColorSizeInputTable(BuildContext context) {
    List<String> _colors = [];
    List<String> _sizes = [];
    widget.colorSizeEntries.forEach((element) {
      _colors.add(element.color);
      _sizes.add(element.size);
    });
    return ColorSizeInputTable(
      _colors,
      _sizes,
      compareFunction: Provider.of<SizeState>(context).compareByName,
      entries: [],
      onChanged: (data) {
        data.forEach((entry) {
          print('${entry.color}-${entry.size}:${entry.quantity}');
        });
        widget.model.entries = data.map((e) => OrderNoteEntryModel(color: e.color,size: e.size, quantity: e.quantity ?? 0)).toList();

      },
    );
  }

  GestureDetector _buildReportTime(BuildContext context) {
    return GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '上报时间',
                      style: TextStyle(color: Colors.black),
                    ),
                  ]),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
//                  width: 152,
                    height: 43,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
//                    border: Border.all(color: Colors.black45),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            widget.model.reportTime == null
                                ? '选取'
                                : DateFormatUtil.formatYMD(
                                    widget.model.reportTime),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                            overflow: TextOverflow.ellipsis),
                      ),
                    )),
              )
            ],
          ),
        ),
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: widget.model.reportTime ?? DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime(2999),
          ).then((value) {
            setState(() {
              if (value != null) {
                widget.model.reportTime = value;
              }
            });
          });
        });
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
  void _cancel() async{
    showConfirmDialog(false, message: '是否确认作废？',
        confirm: () async {
          Function cancelFunc =
          BotToast.showLoading(clickClose: false, crossPage: false);
          var result = await ProgressOrderRepository().deleteProductionProgressOrder(widget.model.belong?.id,widget.model.id);
          cancelFunc.call();
          if (result != null) {
            BotToast.showText(text: '作废成功');
            Navigator.pop(context, true);
          } else {
            BotToast.showText(text: '作废失败');
          }
        });
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