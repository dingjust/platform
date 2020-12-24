import 'package:b2b_commerce/src/business/_shared/widgets/progress_time_line_date_form.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/production_progress/production_progress_detail_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

enum ProgressState { BEFORE, CURRENT, AFTER }

///进度工单显示
class ProgressTimeLine extends StatefulWidget {
  final ProgressWorkSheetModel model;

  //是否可操作
  final bool enableEdit;

  //刷新生产工单
  final ValueChanged<bool> onRefreshOrderData;

  const ProgressTimeLine(
      {Key key, this.model, this.enableEdit = false, this.onRefreshOrderData})
      : super(key: key);

  @override
  State createState() => _ProgressTimeLineState();
}

class _ProgressTimeLineState extends State<ProgressTimeLine> {
  Map<ProgressState, Color> _colorStateMap = {
    ProgressState.BEFORE: Colors.green,
    ProgressState.CURRENT: Colors.black,
    ProgressState.AFTER: Colors.grey,
  };

  bool _enableEdit = false;

  ProgressWorkSheetModel _model;

  @override
  void initState() {
    _enableEdit = widget.enableEdit;
//    _model = ProgressWorkSheetModel.fromJson(
//        ProgressWorkSheetModel.toJson(widget.model));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _enableEdit &&
            widget.model.orderStatus == ProductionTaskOrderState.TO_BE_PRODUCED
        ? IntrinsicHeight(
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildPurchaseProductionProgresse(context),
                Opacity(
                  opacity: 0.7,
                  child: Container(
                    color: Colors.black45,
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    dynamic result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProgressTimeLineDateForm(
                                  model: widget.model,
                                )));
                    print(result is bool);
                    if (result != null) {
                      setState(() {
                        widget.onRefreshOrderData(true);
                      });
                    }
                  },
                  child: Text('设置预计完成日期'),
                  color: Colors.white,
                  textColor: Colors.blue,
                )
              ],
            ),
          )
        : _buildPurchaseProductionProgresse(context);
  }

//构建生产进度UI
  Widget _buildPurchaseProductionProgresse(BuildContext context) {
    int _index = 0;
    return widget.model.progresses == null
        ? Container()
        : Container(
            padding: EdgeInsets.only(top: 20, right: 15),
            child: Column(
              children: widget.model.progresses.map((e) {
                ProgressState _currentStatus = ProgressState.AFTER;
                if (e.finishDate != null) {
                  _currentStatus = ProgressState.BEFORE;
                } else if (widget.model.currentPhase != null &&
                    e.progressPhase != null) {
                  if (widget.model.currentPhase.sequence >
                      e.progressPhase.sequence) {
                    _currentStatus = ProgressState.BEFORE;
                  } else if (widget.model.currentPhase.sequence ==
                      e.progressPhase.sequence) {
                    _currentStatus = ProgressState.CURRENT;
                  }
                }

                return _buildProductionProgress(context, _index++, _currentStatus);
              }).toList(),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          );
  }

  //TimeLineUI
  Widget _buildProductionProgress(
      BuildContext context, int index, ProgressState currentStatus) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductionProgressDetailPage(
                    colorSizeEntries: widget.model.colorSizeEntries,
                    progress: widget.model.progresses[index],
                  )));
        },
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: _buildProgressTimeLine(context, index, currentStatus),
            ),
            Positioned(
              top: 3.0,
              bottom: 0.0,
              left: 17.5,
              child: Container(
                height: double.infinity,
                width: 1.3,
                color: _colorStateMap[currentStatus],
              ),
            ),
            Positioned(
              top: 0.0,
              left: 3.0,
              child: ProgressState.BEFORE == currentStatus
                  ? Container(
                width: 30,
                decoration: ShapeDecoration(
                    shape: CircleBorder(
                        side: BorderSide(width: 2, color: Colors.green)),
                    color: Colors.white),
                child: Center(
                    child: Icon(
                      Icons.done,
                      size: 18,
                      color: Colors.green,
                    )),
              )
                  : Container(
                width: 30,
                decoration: ShapeDecoration(
                    shape: CircleBorder(
                        side: BorderSide(
                            width: 2,
                            color: _colorStateMap[currentStatus])),
                    color: Colors.white),
                child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(color: _colorStateMap[currentStatus]),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

//TimeLineUI右边的Card部分
  Widget _buildProgressTimeLine(
      BuildContext context, int index, ProgressState currentStatus) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
//            margin: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
//                widget.model.currentPhase.sequence > widget.model.progresses[index].sequence?
//                  Container(
//                    padding: EdgeInsets.symmetric(horizontal: 5),
//                    margin: EdgeInsets.symmetric(horizontal: 10),
//                    decoration: ShapeDecoration(shape: CircleBorder(side: BorderSide(width: 2,color: Colors.green)),color: Colors.white),
//                    child: Icon(Icons.done,size: 18,color: Colors.green,),
//                  ):
//                  Container(
//                    padding: EdgeInsets.symmetric(horizontal: 5),
//                    margin: EdgeInsets.symmetric(horizontal: 10),
//                    decoration: ShapeDecoration(shape: CircleBorder(side: BorderSide(width: 2)),color: Colors.white),
//                    child: Text('${index+1}'),
//                  ),
                Expanded(
                  child: Text(widget.model.progresses[index].progressPhase.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _colorStateMap[currentStatus],
                          fontSize: 18)),
                ),
                Opacity(
                  opacity: currentStatus != ProgressState.BEFORE ? 1 : 0,
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      '${widget.model.progresses[index].delayedDays > 0 ? '已延期${widget.model.progresses[index].delayedDays}天' : widget.model.progresses[index].delayedDays < 0 ? '倒计时${-widget.model.progresses[index].delayedDays}天' : ''}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
//              Container(
//                padding: const EdgeInsets.only(left: 10),
//                margin: EdgeInsets.symmetric(horizontal: 10),
//                child: Container(height:100,child: VerticalDivider(color: Colors.black,indent: 0,)),
//              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _buildEstimatedDate(
                        context, widget.model.progresses[index], currentStatus),
                    _buildFinishDate(
                        context, widget.model.progresses[index], currentStatus),
//                    _buildQuantity(
//                        context, productionProgress, isCurrentStatus),
//                    _buildProgressRemarks(
//                        context, productionProgress, isCurrentStatus),
                  ],
                ),
              ),
              _enableEdit &&
                  widget.model.orderStatus ==
                      ProductionTaskOrderState.PRODUCING &&
                  currentStatus == ProgressState.CURRENT
                  ? FlatButton(
                onPressed: () async {
                  showConfirmDialog(false, message: '是否确认完成节点？',
                      confirm: () async {
                        BaseMsg msg = await ProgressOrderRepository()
                            .finishProgress(widget.model.code,
                            widget.model.progresses[index].id);
                        if (msg != null) {
                          BotToast.showText(text: msg.msg);
                          //刷新进度工单数据
                          if (index == widget.model.progresses.length - 1) {
                            //完成最后一个节点
                            widget.onRefreshOrderData(true);
                          } else {
                            widget.onRefreshOrderData(false);
                          }
                        } else {
                          BotToast.showText(text: "系统错误");
                        }
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '完成',
                    style: TextStyle(color: Colors.white),
                  ),
                      ),
                      shape:
                          CircleBorder(side: BorderSide(color: Colors.white)),
                      color: Color(0xffffd60c),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatedDate(BuildContext context,
      ProductionProgressModel progress, ProgressState currentStatus) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          GestureDetector(
              child: Text('预计完成时间：',
                  style: TextStyle(color: _colorStateMap[currentStatus])),
              onTap: () {
//                    currentStatus == true &&
//                    widget.model.status == ProgressWorkSheetStatus.IN_PRODUCTION
//                    ? _showDatePicker(progress,context)
//                    : null;
              }),
          GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                    '${DateFormatUtil.formatYMD(progress.estimatedDate)}',
                    style: TextStyle(color: _colorStateMap[currentStatus])),
              ),
              onTap: () {
//                _enableEdit &&
//                    currentStatus == true &&
//                    widget.model.status == ProgressWorkSheetStatus.IN_PRODUCTION
//                    ? _showDatePicker(progress,context)
//                    : null;
              }),
        ],
      ),
    );
  }

  Widget _buildFinishDate(BuildContext context,
      ProductionProgressModel progress, ProgressState currentStatus) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Text('实际完成时间：',
              style: TextStyle(color: _colorStateMap[currentStatus])),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: progress.finishDate == null
                ? Container()
                : Text('${DateFormatUtil.formatYMD(progress.finishDate)}',
                    style: TextStyle(color: _colorStateMap[currentStatus])),
          ),
        ],
      ),
    );
  }
}
