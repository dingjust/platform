import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///进度工单显示
class ProgressTimeLineDateForm extends StatefulWidget {
  final ProgressWorkSheetModel model;

  //是否可操作
  final bool enableEdit;

  //刷新生产工单
  final VoidCallback onRefreshOrderData;

  const ProgressTimeLineDateForm(
      {Key key, this.model, this.enableEdit = false, this.onRefreshOrderData})
      : super(key: key);

  @override
  State createState() => _ProgressTimeLineDateFormState();
}

class _ProgressTimeLineDateFormState extends State<ProgressTimeLineDateForm> {
  ProgressWorkSheetModel _model;

  Map<ProgressPhaseModel, TextEditingController> _controllerMap;

  @override
  void initState() {
    _model = ProgressWorkSheetModel(
        code: widget.model.code,
        progresses: widget.model.progresses,
        priorityLevel: widget.model.priorityLevel);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('设置预计完成日期'),
      ),
      body: ListView(
        children: [
          _buildPriorityLevel(),
          SizedBox(
            height: 20,
          ),
          _buildProgressDateInputs(),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 50,
        child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '保存',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))),
            onPressed: () async {
              if(_model.priorityLevel == null){
                BotToast.showText(text: '请选择优先级');
                return;
              }
              _model.progresses.forEach((element) {
                if(element.estimatedDate == null){
                  BotToast.showText(text: '请完善预计完成时间');
                  throw Exception('请完善预计完成时间');
                }
              });

              showConfirmDialog(false, message: '是否确认保存？',
                  confirm: () async {
                    Function cancelFunc =
                    BotToast.showLoading(clickClose: false, crossPage: false);
                    BaseMsg msg = await ProgressWorkSheetRepository()
                        .updateProgressesEstimatedDate(_model);
                    cancelFunc.call();
                    if (msg != null && msg.code == 1) {
                      BotToast.showText(text: '保存成功');
                      Navigator.pop(context, true);
                    } else {
                      BotToast.showText(text: '保存失败');
                    }
                  });
            }),
      ),
    );
  }

  Container _buildPriorityLevel() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '优先级',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(fontSize: 16, color: Colors.red),
              )
            ]),
          ),
          Row(
            children: <Widget>[
              PopupMenuButton<EnumModel>(
                onCanceled: () {},
                onSelected: (val) {
                  print(val);
                  setState(() {
                    _model.priorityLevel = int.parse(val.code);
                  });
                },
                itemBuilder: (BuildContext context) =>
                    PriorityLevelEnum.map((item) => PopupMenuItem<EnumModel>(
                          value: item,
                          child: Text('${item.name}'),
                        )).toList(),
                child: Text(
                  '${_model.priorityLevel != null ? enumMap(PriorityLevelEnum, _model.priorityLevel.toString()) : '选择优先级'}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressDateInputs() {
    return Column(
      children: _model.progresses.map((e) {
        return Container(
          padding: EdgeInsets.all(15),
          color: Colors.white,
          child: _buildProgressDateInput(e),
        );
      }).toList(),
    );
  }

  //生成日期选择器
  Future<Null> _selectDate(ValueChanged<DateTime> callback) async {
    DateTime nowDate = DateTime.now();
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: nowDate,
        firstDate: nowDate,
        lastDate: DateTime(2999));

    callback(_picked);
  }

  //交货日期
  Widget _buildProgressDateInput(ProductionProgressModel progress) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: '${progress.progressPhase.name}',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(fontSize: 16, color: Colors.red),
              )
            ]),
          ),
        ),
        Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                _selectDate((date) {
                  setState(() {
                    progress.estimatedDate = date;
                  });
                });
              },
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
                          progress.estimatedDate == null
                              ? '选取'
                              : DateFormatUtil.formatYMD(
                                  progress.estimatedDate),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                          overflow: TextOverflow.ellipsis),
                    )),
              ),
            ))
      ],
    );
  }
}
