import 'package:b2b_commerce/src/business/orders/quote_order_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class QuoteItem extends StatefulWidget {
  final QuoteModel model;

  /// 更新方法
  final VoidCallback onRefresh;

  /// 顶级页面context
  final BuildContext pageContext;

  bool isSupplier;

  QuoteItem({Key key, this.model, this.isSupplier = false, @required this.onRefresh, @required this.pageContext})
      : super(key: key);

  _QuoteItemState createState() => _QuoteItemState();
}

class _QuoteItemState extends State<QuoteItem> {
  static Map<QuoteState, MaterialColor> _statusColors = {
    QuoteState.SELLER_SUBMITTED: Colors.red,
    QuoteState.BUYER_APPROVED: Colors.green,
    QuoteState.BUYER_REJECTED: Colors.grey
  };

  TextEditingController rejectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //查询明细
        QuoteModel detailModel = await QuoteOrderRepository().getQuoteDetails(widget.model.code);
        if (detailModel != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuoteOrderDetailPage(item: detailModel)));
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildMain(),
            widget.model.state == QuoteState.SELLER_SUBMITTED && UserBLoC.instance.currentUser.type == UserType.BRAND
                ? _buildSummary()
                : Container(),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildMain() {
    return Container(
      child: InkWell(
        onTap: () {},
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Stars(
                            starLevel: widget.model.belongTo.starLevel ?? 1,
                            color: Color.fromRGBO(255, 183, 0, 1),
                            highlightOnly: false,
                          ),
//                          RichText(
//                            text: TextSpan(text: '历史接单', style: TextStyle(color: Colors.black54), children: <TextSpan>[
//                              TextSpan(text: '214', style: TextStyle(color: Colors.red)),
//                              TextSpan(text: '单', style: TextStyle(color: Colors.black54)),
//                            ]),
//                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(text: '报价：', style: TextStyle(fontSize: 18, color: Colors.black), children: <TextSpan>[
                  TextSpan(text: '￥', style: TextStyle(fontSize: 14, color: Colors.red)),
                  TextSpan(
                      text:
                          '${widget.model.unitPrice}',
                      style: TextStyle(color: Colors.red)),
                ]),
              ),
              Text(QuoteStateLocalizedMap[widget.model.state],
                  style: TextStyle(color: _statusColors[widget.model.state], fontSize: 18))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
//                Text(
//                  '${widget.model?.supplier.name}',
//                  style: TextStyle(fontSize: 15),
//                ),
                Text(
                  '${DateFormatUtil.format(widget.model.creationTime)}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Offstage(
      offstage: widget.isSupplier,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
                onPressed: onReject,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  '拒绝报价',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
            FlatButton(
                onPressed: onApprove,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Color.fromRGBO(255, 214, 12, 1),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  '确认报价',
                  style: TextStyle(color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }

  void alertMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text(message)],
            ),
          ),
    );
  }

  void onReject() {
    showDialog<void>(
      context: widget.pageContext,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入拒绝原因?'),
          content: TextField(
            controller: rejectController,
            autofocus: true,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '取消',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                int statusCode = await QuoteOrderRepository().quoteReject(widget.model.code, rejectController.text);
                Navigator.of(context).pop();
                if (statusCode == 200) {
                  //触发刷新
                  widget.onRefresh();
                } else {
                  alertMessage('拒绝失败');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void onApprove() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('是否确认?'),
          actions: <Widget>[
            FlatButton(
              child: Text('否', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('是', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                int statusCode = await QuoteOrderRepository().quoteApprove(widget.model.code);
                Navigator.of(context).pop();
                if (statusCode == 200) {
                  //触发刷新
                  widget.onRefresh();
                } else {
                  alertMessage('确认失败');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
