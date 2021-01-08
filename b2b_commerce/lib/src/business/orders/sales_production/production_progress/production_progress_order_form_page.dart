import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///节点详情页
class ProductionProgressOrderFormPage extends StatefulWidget {
  ///节点
  final ProductionProgressModel progress;

  ///单据
  final ProductionProgressOrderModel model;

  ///工单下单数
  final List<ColorSizeInputEntry> colorSizeEntries;

  final bool isEditable;

  const ProductionProgressOrderFormPage(
      {Key key,
      this.progress,
      this.model,
      this.colorSizeEntries,
      this.isEditable = false})
      : super(key: key);

  @override
  _ProductionProgressOrderFormPageState createState() =>
      _ProductionProgressOrderFormPageState();
}

class _ProductionProgressOrderFormPageState
    extends State<ProductionProgressOrderFormPage> {
  List<ColorSizeInputEntry> _colorSizeEntries = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.isEditable && widget.model.entries != null) {
      //回显颜色尺码数量
      Map<String, int> entriesMap = new Map();

      _colorSizeEntries = widget.model.entries.map((e) => ColorSizeInputEntry(color: e.color,size: e.size,quantity: e.quantity)).toList();
//      widget.model.entries.forEach((element) {
//        entriesMap['${element.color}-${element.size}'] = element.quantity;
//      });
//
//      widget.colorSizeEntries.forEach((element) {
//        element.quantity = entriesMap['${element.color}-${element.size}'];
//      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            '${widget.progress?.progressPhase?.name ?? ''}报工${widget.isEditable
                ? '编辑'
                : ''}'),
        elevation: 0.5,
      ),
      bottomNavigationBar: Container(
        height: 50,
        width: double.infinity,
        child: FlatButton(
          onPressed: () => _save(),
          color: const Color.fromRGBO(255, 219, 0, 1),
          child: Text(
            '保存',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(bottom: 10),
        child: ListView(children: <Widget>[
          _InfoRow(
            title: '工单号：',
            val: '${widget.progress.id}',
          ),
          _InfoRow(
            title: '上报人员：',
            val: '${widget.model.operator?.name}',
          ),
          _buildReportTime(context),
          _buildColorSizeInputTable(context),
          _buildMedias(),
          EditableAttachments(
            list: widget.model.medias,
            maxNum: 5,
            editable: true,
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

  ColorSizeInputTable _buildColorSizeInputTable(BuildContext context) {
    List<String> _colors = [];
    List<String> _sizes = [];
    widget.colorSizeEntries.forEach((element) {
      if (!_colors.contains(element.color)) {
        _colors.add(element.color);
      }

      if (!_sizes.contains(element.size)) {
        _sizes.add(element.size);
      }
    });
    return ColorSizeInputTable(
      _colors,
      _sizes,
      compareFunction: Provider.of<SizeState>(context).compareByName,
      entries: _colorSizeEntries,
      onChanged: onEntriesChange,
    );
  }

  void onEntriesChange(List<ColorSizeInputEntry> data) {
    widget.model.entries = data
        .map((e) =>
        OrderNoteEntryModel(
            color: e.color, size: e.size, quantity: e.quantity ?? 0))
        .toList();
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
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    )
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

  //保存
  void _save() async {
    if (widget.model.reportTime == null) {
      BotToast.showText(text: '请填写上报时间');
      return;
    }
    int totalQuantity = 0;
    for (var entry in widget.model.entries) {
      totalQuantity += entry.quantity ?? 0;
    }
    if (totalQuantity <= 0) {
      BotToast.showText(text: '上报数量不能为空');
      return;
    }

    showConfirmDialog(false, message: '是否确认保存？', confirm: () async {
      int id = widget.progress.id;
      var result;
      if (widget.isEditable) {
        result = await ProgressOrderRepository()
            .updateProductionProgressOrder(id, widget.model.id, widget.model);
      } else {
        result = await ProgressOrderRepository()
            .createProductionProgressOrder(id, widget.model);
      }

      if (result != null) {
        BotToast.showText(text: '保存成功');
        Navigator.pop(context, true);
      } else {
        BotToast.showText(text: '保存失败');
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
