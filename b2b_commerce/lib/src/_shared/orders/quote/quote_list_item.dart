import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import '../../../../b2b_commerce.dart';
import '../../../business/orders/quote_order_detail.dart';
import '../../widgets/image_factory.dart';

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

/// 创建销售订单
typedef void SalesOrderCreatingCallback();

/// 报价单行
class QuoteListItem extends StatelessWidget {
  QuoteListItem({
    Key key,
    @required this.model,
    this.onQuoteRejecting,
    this.onQuoteConfirming,
    this.onQuoteUpdating,
    this.onQuoteAgain,
    this.onProofingCreating,
    this.onProductionOrderCreating,
    this.showActions = true,
    this.companyUid,
    this.onSalesOrderCreating,
  }) : super(key: ObjectKey(model));

  final QuoteModel model;
  final bool showActions;
  final String companyUid;

  final QuoteRejectingCallback onQuoteRejecting;
  final QuoteConfirmingCallback onQuoteConfirming;
  final QuoteUpdatingCallback onQuoteUpdating;
  final QuoteAgainCallback onQuoteAgain;
  final ProofingCreatingCallback onProofingCreating;
  final ProductionOrderCreatingCallback onProductionOrderCreating;
  final SalesOrderCreatingCallback onSalesOrderCreating;

  @override
  Widget build(BuildContext context) {
    void _onQuoteDetails() async {
      // 查询明细
//      QuoteModel detailModel =
//          await QuoteOrderRepository().getQuoteDetails(model.code);
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => QuoteOrderDetailPage(
                  model.code,
                )),
      );
    }

    return GestureDetector(
      onTap: _onQuoteDetails,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.only(top: 12),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildEntries(),
            Offstage(
              offstage: !showActions,
              child: Row(children: <Widget>[
                Expanded(flex: 1, child: _buildActions(context))
              ]),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  '${model.requirementOrder.belongTo.name}',
                  style: TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                QuoteStateLocalizedMap[model.state],
                style: TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEntries() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 4),
      child: Row(
        children: <Widget>[
          ImageFactory.buildThumbnailImageForList(
              model.requirementOrder.details?.pictures),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildRow1(),
                  _buildRow2(),
                  _buildRow3(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow1() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(model?.requirementOrder?.details?.productName ?? '',
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildRow2() {
    return Container(
      margin: EdgeInsets.only(top: 2, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
                "${model.requirementOrder.details.majorCategoryName()} ${model
                    .requirementOrder.details.category?.name} ${model
                    .requirementOrder.details.expectedMachiningQuantity}件",
                style: const TextStyle(
                    fontSize: 13,
                    color: const Color(0xff666666),
                    fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
  }

  Widget _buildRow3() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Text('报价： ${model?.unitPrice ?? 0}',
                  style: const TextStyle(
                      color: Color(0xFFFF4D4F),
                      fontSize: 14,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    List<Widget> buttons;

    //品牌端显示

    if (UserBLoC.instance.currentUser.companyCode ==
        model.requirementOrder.belongTo.uid) {
      if (model.state == QuoteState.SELLER_SUBMITTED) {
        buttons = <Widget>[
          Container(
            height: 30,
            child: Row(
              children: <Widget>[
                GestureDetector(
                    child: Icon(
                      Icons.phone,
                      color: Colors.green,
                      size: 20,
                    ),
                    onTap: () => _toFactory(context)),
                FlatButton(
                  onPressed: () => _toFactory(context),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    '联系工厂',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: onQuoteConfirming,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xffFA7E1E), Color(0xFFF53C3C)],
                ),
              ),
              child: const Text('确认工厂',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ),
          )
        ];
      } else {
        buttons = <Widget>[
          Container(
            height: 30,
            child: Row(
              children: <Widget>[
                GestureDetector(
                    child: Icon(
                      Icons.phone,
                      color: Colors.green,
                      size: 20,
                    ),
                    onTap: () => _toFactory(context)),
                FlatButton(
                  onPressed: () => _toFactory(context),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    '联系工厂',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          Container(),
        ];
      }
    } //工厂端显示
    else if (UserBLoC.instance.currentUser.companyCode == model.belongTo.uid) {
      if (model.state == QuoteState.SELLER_SUBMITTED) {
        buttons = [
          Expanded(
              child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 4),
                child: B2BV2Image.message(width: 20, height: 18),
              ),
              (model?.newestFeedback?.content != null &&
                  model?.newestFeedback?.content != '')
                  ? Container(
                  child: Text(
                    '${model.newestFeedback.content}',
                    style: TextStyle(
                      color: Color(0xff222222),
                      fontSize: 12,
                    ),
                  ))
                  : Container(
                child: Text(
                        '暂无反馈',
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 12,
                        ),
                      ),
                    ),
            ],
          )),
          GestureDetector(
            onTap: onQuoteUpdating,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xffFA7E1E), Color(0xFFF53C3C)],
                ),
              ),
              child: const Text('修改报价',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ),
          )
        ];
      } else if (model.requirementOrder.status ==
          RequirementOrderStatus.PENDING_QUOTE) {
        buttons = [
          Container(),
          GestureDetector(
            onTap: onQuoteAgain,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Color(0xffFA7E1E), Color(0xFFF53C3C)],
                ),
              ),
              child: const Text('重新报价',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ),
          )
        ];
      }
    }

    return Container(
      // padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: buttons ?? [],
      ),
    );
  }

  void _toFactory(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.ROUTE_FACTORY_INTRODUCTION,
        arguments: {'uid': model.belongTo.uid});
  }
}
