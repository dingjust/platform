import 'package:b2b_commerce/src/business/orders/form/proofing_order_form.dart';
import 'package:b2b_commerce/src/business/orders/quote_order_detail.dart';
import 'package:b2b_commerce/src/home/pool/requirement_quote_order_from.dart';
import 'package:b2b_commerce/src/production/production_online_order_from.dart';
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

  QuoteItem(
      {Key key,
      this.model,
      @required this.onRefresh,
      @required this.pageContext})
      : super(key: key);

  _QuoteItemState createState() => _QuoteItemState();
}

class _QuoteItemState extends State<QuoteItem> {
  static Map<QuoteState, MaterialColor> _statusColors = {
    QuoteState.SELLER_SUBMITTED: Colors.green,
    QuoteState.BUYER_APPROVED: Colors.blue,
    QuoteState.BUYER_REJECTED: Colors.red
  };

  TextEditingController rejectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //查询明细
        QuoteModel detailModel =
            await QuoteOrderRepository().getquoteDetail(widget.model.code);
        if (detailModel != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuoteOrderDetailPage(item: detailModel)));
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildMain(),
            widget.model.state == QuoteState.SELLER_SUBMITTED &&
                    UserBLoC.instance.currentUser.type == UserType.BRAND
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
                          RichText(
                            text: TextSpan(
                                text: '历史接单',
                                style: TextStyle(color: Colors.black54),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '214',
                                      style: TextStyle(color: Colors.red)),
                                  TextSpan(
                                      text: '单',
                                      style: TextStyle(color: Colors.black54)),
                                ]),
                          ),
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
                text: TextSpan(
                    text: '报价：',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '￥',
                          style: TextStyle(fontSize: 14, color: Colors.red)),
                      TextSpan(
                          text:
                              '${widget.model.unitPriceOfFabric + widget.model.unitPriceOfExcipients + widget.model.unitPriceOfProcessing + widget.model.costOfSamples + widget.model.costOfOther}',
                          style: TextStyle(color: Colors.red)),
                    ]),
              ),
              Text(QuoteStateLocalizedMap[widget.model.state],
                  style: TextStyle(
                      color: _statusColors[widget.model.state], fontSize: 18))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${widget.model.belongTo.name}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  '报价时间：${DateFormatUtil.format(widget.model.creationTime)}',
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
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
              onPressed: onReject,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '拒绝报价',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
          FlatButton(
              onPressed: onApprove,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 214, 12, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '确认报价',
                style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
              )),
        ],
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
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                int statusCode = await QuoteOrderRepository()
                    .quoteReject(widget.model.code, rejectController.text);
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
              child: Text('否'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('是'),
              onPressed: () async {
                int statusCode = await QuoteOrderRepository()
                    .quoteApprove(widget.model.code);
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

class QuoteManageItem extends StatefulWidget {
  final QuoteModel model;

  /// 更新方法
  final VoidCallback onRefresh;

  /// 顶级页面context
  final BuildContext pageContext;

  QuoteManageItem(
      {Key key,
      this.model,
      @required this.onRefresh,
      @required this.pageContext})
      : super(key: key);

  _QuoteManageItemState createState() => _QuoteManageItemState();
}

class _QuoteManageItemState extends State<QuoteManageItem> {
  static Map<QuoteState, MaterialColor> _statusColors = {
    QuoteState.SELLER_SUBMITTED: Colors.green,
    QuoteState.BUYER_APPROVED: Colors.blue,
    QuoteState.BUYER_REJECTED: Colors.red
  };

  TextEditingController rejectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //查询明细
        QuoteModel detailModel =
            await QuoteOrderRepository().getquoteDetail(widget.model.code);
        if (detailModel != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuoteOrderDetailPage(item: detailModel)));
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildEntries(),
            Row(
              children: <Widget>[
                Container(
                  width: 80,
                ),
                Expanded(
                  flex: 1,
                  child: _buildSummary(),
                )
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
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
                text: TextSpan(
                    text: '报价：',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '￥',
                          style: TextStyle(fontSize: 14, color: Colors.red)),
                      TextSpan(
                          text: '${widget.model.unitPrice}',
                          style: TextStyle(color: Colors.red)),
                    ]),
              ),
              Text(QuoteStateLocalizedMap[widget.model.state],
                  style: TextStyle(
                      color: _statusColors[widget.model.state], fontSize: 18))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${widget.model.belongTo.name}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  '报价时间：${DateFormatUtil.format(widget.model.creationTime)}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntries() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          widget.model.requirementOrder.details?.pictures != null &&
                  widget.model.requirementOrder.details.pictures.isNotEmpty
              ? Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(
                            '${GlobalConfigs.IMAGE_BASIC_URL}${widget.model.requirementOrder.details.pictures[0].url}'),
                        fit: BoxFit.cover,
                      )),
                )
              : Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromRGBO(243, 243, 243, 1)),
                  child: Icon(
                    B2BIcons.noPicture,
                    color: Color.fromRGBO(200, 200, 200, 1),
                    size: 25,
                  ),
                ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.model.requirementOrder.details?.productName != null
                      ? Text(
                          widget.model.requirementOrder.details.productName,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          '暂无产品',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                  widget.model.requirementOrder.details?.productSkuID != null
                      ? Container(
                          padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '货号：${widget.model.requirementOrder.details.productSkuID}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "${widget.model.requirementOrder.details.majorCategory?.name}   ${widget.model.requirementOrder.details.category?.name}   ${widget.model.totalQuantity ?? 0}件",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(255, 133, 148, 1)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummary() {
    List<Widget> buttons;

    //品牌端显示
    if (widget.model.state == QuoteState.SELLER_SUBMITTED &&
        UserBLoC.instance.currentUser.type == UserType.BRAND) {
      buttons = <Widget>[
        FlatButton(
            onPressed: onReject,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text(
              '拒绝报价',
              style: TextStyle(color: Colors.white, fontSize: 16),
            )),
        FlatButton(
            onPressed: onApprove,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Color.fromRGBO(255, 214, 12, 1),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text(
              '确认报价',
              style:
                  TextStyle(color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
            )),
      ];
    } //工厂端显示
    else if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      if (widget.model.state == QuoteState.SELLER_SUBMITTED) {
        buttons = [
          Container(),
          FlatButton(
              onPressed: onUpdateQuote,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color.fromRGBO(255, 45, 45, 1)),
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '修改报价',
                style: TextStyle(
                    color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
              )),
        ];
      } else if (widget.model.state == QuoteState.BUYER_APPROVED) {
        buttons = <Widget>[
          FlatButton(
              onPressed: onCreateProofings,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 245, 193, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '打样订单',
                style: TextStyle(
                    color: Color.fromRGBO(255, 169, 0, 1), fontSize: 16),
              )),
          FlatButton(
              onPressed: onCreateProduction,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 214, 12, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '生产订单',
                style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
              )),
        ];
      } else {
        buttons = [
          Container(),
          FlatButton(
              onPressed: onQuoteAgain,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 70, 70, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '重新报价',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ];
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: buttons),
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
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                int statusCode = await QuoteOrderRepository()
                    .quoteReject(widget.model.code, rejectController.text);
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
              child: Text('否'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('是'),
              onPressed: () async {
                int statusCode = await QuoteOrderRepository()
                    .quoteApprove(widget.model.code);
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

  void onQuoteAgain() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequirementQuoteOrderFrom(
              model: widget.model.requirementOrder,
              quoteModel: widget.model,
            )));
  }

  void onUpdateQuote() async {
    //等待操作回调
    bool isSuccessfule = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequirementQuoteOrderFrom(
              model: widget.model.requirementOrder,
              quoteModel: widget.model,
              update: true,
            )));
    //成功调用列表页传递的更新函数刷新页面
    if (isSuccessfule) {
      widget.onRefresh();
    }
  }

  void onCreateProofings() async {
    //查询明细
    QuoteModel detailModel =
        await QuoteOrderRepository().getquoteDetail(widget.model.code);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProofingOrderForm(
              quoteModel: detailModel,
            )));
  }

  void onCreateProduction() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductionOnlineOrderFrom(
                  quoteModel: widget.model,
                )));
  }
}
