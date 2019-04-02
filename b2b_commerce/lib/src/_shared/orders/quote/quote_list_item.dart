import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import '../../widgets/image_factory.dart';
import '../../../business/orders/quote_order_detail.dart';

/// 拒绝报价
typedef void QuoteRejectingCallback();

/// 确认报价
typedef void QuoteConfirmingCallback();

/// 修改报价
typedef void QuoteUpdatingCallback();

/// 重新报价
typedef void QuoteAgainCallback();

/// 创建打样订单
typedef void ProofingCreatingCallback();

/// 创建生产订单
typedef void ProductionOrderCreatingCallback();

/// 报价单行
class QuoteListItem extends StatelessWidget {
  QuoteListItem({
    Key key,
    this.model,
    this.onQuoteRejecting,
    this.onQuoteConfirming,
    this.onQuoteUpdating,
    this.onQuoteAgain,
    this.onProofingCreating,
    this.onProductionOrderCreating,
    this.isSupplier = false,
  }) : super(key: ObjectKey(model));

  final QuoteModel model;
  final bool isSupplier;

  final QuoteRejectingCallback onQuoteRejecting;
  final QuoteConfirmingCallback onQuoteConfirming;
  final QuoteUpdatingCallback onQuoteUpdating;
  final QuoteAgainCallback onQuoteAgain;
  final ProofingCreatingCallback onProofingCreating;
  final ProductionOrderCreatingCallback onProductionOrderCreating;

  static Map<QuoteState, MaterialColor> _statusColors = {
    QuoteState.SELLER_SUBMITTED: Colors.red,
    QuoteState.BUYER_APPROVED: Colors.green,
    QuoteState.BUYER_REJECTED: Colors.grey
  };

  @override
  Widget build(BuildContext context) {
    void _onQuoteDetails() async {
      // 查询明细
      QuoteModel detailModel = await QuoteOrderRepository().getQuoteDetails(model.code);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => QuoteOrderDetailPage(item: detailModel)),
      );
    }

    return GestureDetector(
      onTap: _onQuoteDetails,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildEntries(),
            Offstage(
              offstage: isSupplier,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: _buildSummary(context),
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
                      text: '${model.unitPrice}',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              Text(
                QuoteStateLocalizedMap[model.state],
                style: TextStyle(
                  color: _statusColors[model.state],
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
                  '${model.supplier?.name}',
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  '${DateFormatUtil.format(model.creationTime)}',
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
          ImageFactory.buildThumbnailImageForList(model.requirementOrder.details?.pictures),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  model.requirementOrder.details?.productName != null
                      ? Text(
                          model.requirementOrder.details.productName,
                          style: const TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          ' ',
                          style: const TextStyle(fontSize: 15, color: Colors.red),
                        ),
                  model.requirementOrder.details?.productSkuID != null
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '货号：${model.requirementOrder.details.productSkuID}',
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
                      "${model.requirementOrder.details?.majorCategoryName()}   ${model.requirementOrder.details?.category?.name}   ${model.totalQuantity ?? 0}件",
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

  Widget _buildSummary(BuildContext context) {
    List<Widget> buttons;

    //品牌端显示
    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
      if (model.state == QuoteState.SELLER_SUBMITTED) {
        buttons = <Widget>[
          FlatButton(
            onPressed: onQuoteRejecting,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text(
              '拒绝报价',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          FlatButton(
            onPressed: onQuoteConfirming,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Color.fromRGBO(255, 214, 12, 1),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text(
              '确认报价',
              style: TextStyle(color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
            ),
          ),
        ];
      }
    } //工厂端显示
    else {
      if (model.state == QuoteState.SELLER_SUBMITTED) {
        buttons = [
          Container(),
          FlatButton(
            onPressed: onQuoteUpdating,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color.fromRGBO(255, 45, 45, 1)),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text(
              '修改报价',
              style: TextStyle(color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
            ),
          ),
        ];
      } else if (model.state == QuoteState.BUYER_APPROVED) {
        buttons = <Widget>[
          FlatButton(
            onPressed: onProofingCreating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Color.fromRGBO(255, 214, 12, 1),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text(
              '创建打样订单',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          FlatButton(
            onPressed: onProductionOrderCreating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Color.fromRGBO(255, 214, 12, 1),
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Text(
              '创建生产订单',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
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
            ),
          ),
        ];
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttons ?? [],
      ),
    );
  }
}
