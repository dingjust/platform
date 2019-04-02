import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../../business/orders/form/proofing_order_form.dart';
import '../../../business/orders/quote_order_detail.dart';
import '../../../home/pool/requirement_quote_order_from.dart';
import '../../../production/production_online_order_from.dart';

/// 报价单行
class QuoteListItem extends StatefulWidget {
  QuoteListItem({
    Key key,
    this.model,
    this.isSupplier = false,
    @required this.onRefresh,
    @required this.pageContext,
  }) : super(key: key);

  final QuoteModel model;
  final bool isSupplier;

  /// 更新方法
  final VoidCallback onRefresh;

  /// 顶级页面context
  final BuildContext pageContext;

  _QuoteListItemState createState() => _QuoteListItemState();
}

class _QuoteListItemState extends State<QuoteListItem> {
  static Map<QuoteState, MaterialColor> _statusColors = {
    QuoteState.SELLER_SUBMITTED: Colors.red,
    QuoteState.BUYER_APPROVED: Colors.green,
    QuoteState.BUYER_REJECTED: Colors.grey
  };

  final TextEditingController rejectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //查询明细
        QuoteModel detailModel = await QuoteOrderRepository().getquoteDetail(widget.model.code);
        if (detailModel != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => QuoteOrderDetailPage(item: detailModel)));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildEntries(),
            Offstage(
              offstage: widget.isSupplier,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: _buildSummary(),
                  )
                ],
              ),
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
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                    TextSpan(
                      text: '${widget.model.unitPrice}',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              Text(
                QuoteStateLocalizedMap[widget.model.state],
                style: TextStyle(
                  color: _statusColors[widget.model.state],
                  fontSize: 18,
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${widget.model?.supplier?.name}',
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  '${DateFormatUtil.format(widget.model.creationTime)}',
                  style: const TextStyle(fontSize: 15),
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
                    ),
                  ),
                )
              : Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color.fromRGBO(243, 243, 243, 1),
                  ),
                  child: const Icon(
                    B2BIcons.noPicture,
                    color: const Color.fromRGBO(200, 200, 200, 1),
                    size: 60,
                  ),
                ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.model.requirementOrder.details?.productName != null
                      ? Text(
                          widget.model.requirementOrder.details.productName,
                          style: const TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          ' ',
                          style: const TextStyle(fontSize: 15, color: Colors.red),
                        ),
                  widget.model.requirementOrder.details?.productSkuID != null
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '货号：${widget.model.requirementOrder.details.productSkuID}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        )
                      : Container(),
                  Container(
                    padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 243, 243, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${widget.model.requirementOrder.details?.majorCategoryName()}   ${widget.model.requirementOrder.details?.category?.name}   ${widget.model.totalQuantity ?? 0}件",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromRGBO(255, 133, 148, 1),
                      ),
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
    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
      if (widget.model.state == QuoteState.SELLER_SUBMITTED) {
        buttons = <Widget>[
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
        ];
      }
    } //工厂端显示
    else {
      if (widget.model.state == QuoteState.SELLER_SUBMITTED) {
        buttons = [
          Container(),
          FlatButton(
              onPressed: onUpdateQuote,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color.fromRGBO(255, 45, 45, 1)), borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '修改报价',
                style: TextStyle(color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
              )),
        ];
      } else if (widget.model.state == QuoteState.BUYER_APPROVED) {
        buttons = <Widget>[
          FlatButton(
              onPressed: onCreateProofings,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 214, 12, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '创建打样订单',
                style: TextStyle(color: Colors.black, fontSize: 16),
              )),
          FlatButton(
              onPressed: onCreateProduction,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 214, 12, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '创建生产订单',
                style: TextStyle(color: Colors.black, fontSize: 16),
              )),
        ];
      } else {
        buttons = [
          Container(),
          FlatButton(
              onPressed: onQuoteAgain,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: buttons ?? []),
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
              child: Text('取消', style: TextStyle(color: Colors.grey)),
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
    if (isSuccessfule != null && isSuccessfule) {
      widget.onRefresh();
    }
  }

  void onCreateProofings() async {
    //查询明细
    QuoteModel detailModel = await QuoteOrderRepository().getquoteDetail(widget.model.code);

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
