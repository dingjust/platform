import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/common/order_payment_page.dart';
import 'package:b2b_commerce/src/helper/cooperator_helper.dart';
import 'package:common_utils/common_utils.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

///外接订单块
class ExternalSaleOrderItem extends StatelessWidget {
  final SalesProductionOrderModel model;

  final SaleOrderItemType type;

  const ExternalSaleOrderItem(this.model,
      {Key key, this.type = SaleOrderItemType.IMPORT})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 12),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _Header(
              model: model,
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 16),
              child: Divider(
                thickness: 1,
                height: 1,
                color: Color(0xFFE7E7E7),
              ),
            ),
            _Info(
              label: '总数量',
              val: '${model.totalQuantity}',
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 17),
              child: _Info(
                label: '款数',
                val: '${model.entrySize}',
              ),
            ),
            _Amount(model),
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 14),
              child: Divider(
                thickness: 1,
                height: 1,
                color: Color(0xFFE7E7E7),
              ),
            ),
            _Bottom(model),
            _buildPaymentInfo(context)
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onTap: () async {
        //回调true刷新
        Navigator.of(context)
            .pushNamed(AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS_DETAIL, arguments: {
          'id': model.id,
          'title': type == SaleOrderItemType.IMPORT ? '外接订单明细' : '外发订单明细'
        }).then((needRefresh) {
          if (needRefresh != null && needRefresh) {
            if (type == SaleOrderItemType.IMPORT)
              //外接订单列表刷新
              Provider.of<ExternalSaleOrdersState>(context, listen: false)
                  .clear();
            else
              //外发订单列表刷新
              Provider.of<OutOrdersState>(context, listen: false).clear();
          }
        });
      },
    );
  }

  Widget _buildPaymentInfo(context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          ..._buildCMTPayOrders(context),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                margin: EdgeInsets.only(right: 10),
                child: Text('订单金额',
                    style: TextStyle(color: Color(0xFF666666), fontSize: 14)),
              ),
              Expanded(
                  child: RichText(
                      text: TextSpan(
                          text: '￥',
                          style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                          children: [
                    TextSpan(
                        text: '${model.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14)),
                  ]))),
            ],
          ),
          _builPayBtn(context),
        ],
      ),
    );
  }

  List<Widget> _buildCMTPayOrders(BuildContext context) {
    //判断甲乙方，乙方不支付
    if (isTarget) {
      return [];
    }

    //线下支付
    if (model.payOnline == null ||
        (!model.payOnline) ||
        ObjectUtil.isEmptyList(model.paymentOrders)) {
      return [];
    }

    model.paymentOrders..sort((o1, o2) => o1.batch - o2.batch);

    return model.paymentOrders
        .map((e) => Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                        (e.batch == 1 && model.paymentOrders.length > 1)
                            ? '定金'
                            : '尾款',
                        style:
                            TextStyle(color: Color(0xFF666666), fontSize: 14)),
                  ),
                  Expanded(
                      child: RichText(
                          text: TextSpan(
                              text: '￥',
                              style: TextStyle(
                                  color: Color(0xFF222222),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                              children: [
                        TextSpan(
                            text: '${e.payAmount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 14)),
                        TextSpan(
                            text: '  (${CmtPaymentStateLocalizedMap[e.state]})',
                            style: TextStyle(
                                color: e.state == CmtPaymentState.PAID
                                    ? Color(0xFF222222)
                                    : Color(0xFFFF4D4F),
                                fontSize: 14))
                      ]))),
                ],
              ),
            ))
        .toList();
  }

  Widget _builPayBtn(BuildContext context) {
    CmtPayOrderData data = model.paymentOrders
        .firstWhere((element) => element.canPay, orElse: () => null);
    if (data != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => OrderPaymentPageV2(data)))
                  .then((needRefresh) {
                //刷新
                if (needRefresh != null && needRefresh) {
                  if (type == SaleOrderItemType.IMPORT)
                    //外接订单列表刷新
                    Provider.of<ExternalSaleOrdersState>(context, listen: false)
                        .clear();
                  else
                    //外发订单列表刷新
                    Provider.of<OutOrdersState>(context, listen: false).clear();
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              margin: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFA7E1E), Color(0xFFF53C3C)])),
              child: Text(
                '去支付',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          )
        ],
      );
    }
    return Container();
  }

  ///来源方
  bool get isOrigin {
    if (model.originCompany != null) {
      return model?.originCompany?.uid ==
          UserBLoC.instance.currentUser.companyCode;
    }
    return false;
  }

  ///是否接单方
  bool get isTarget {
    if (model.targetCooperator != null) {
      return model?.targetCooperator?.partner?.uid ==
          UserBLoC.instance.currentUser.companyCode;
    }
    return false;
  }
}

class _Header extends StatelessWidget {
  final SalesProductionOrderModel model;

  final TextStyle textStyle;

  const _Header({
    Key key,
    this.model,
    this.textStyle = const TextStyle(
        fontSize: 13, color: Color(0xff222222), fontWeight: FontWeight.bold),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 24,
          height: 24,
          margin: EdgeInsets.only(right: 8),
          child: CircleAvatar(
            backgroundImage: CooperatorHelper.getCooperatorImage(
                model.targetCooperator, model.originCompany),
            radius: 24,
          ),
        ),
        Expanded(
            child: Text(
          '${CooperatorHelper.getCooperatorName(model.targetCooperator, model.originCompany, model.originCooperator) ?? ''}',
          style: textStyle,
          overflow: TextOverflow.ellipsis,
        )),
        Text(
          '${SalesProductionOrderStateLocalizedMap[model.state]}',
          textAlign: TextAlign.end,
          style: textStyle,
        )
      ],
    );
  }
}

class _Info extends StatelessWidget {
  final String label;

  final String val;

  final EdgeInsetsGeometry margin;

  const _Info({Key key, this.label, this.val, this.margin = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Container(
            width: 66,
            child: Text(
              '$label',
              style: TextStyle(color: Color(0xff666666), fontSize: 14),
            ),
          ),
          Expanded(
              child: Text(
                '$val',
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF222222),
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}

class _Amount extends StatelessWidget {
  final SalesProductionOrderModel model;

  const _Amount(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          B2BV2Image.money(width: 18, height: 18),
          Container(
            margin: EdgeInsets.only(left: 4, right: 8),
            child: Text('订单金额'),
          ),
          RichText(
              text: TextSpan(
                  text: '￥',
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xffFF4D4F),
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: '${model.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14))
                  ]))
        ],
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  final SalesProductionOrderModel model;

  final TextStyle textStyle;

  const _Bottom(this.model,
      {Key key,
        this.textStyle = const TextStyle(
            color: Color(0xff666666), fontSize: 13)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          children: [
            Expanded(
                child: Row(
                  children: [
                    Text(
                      '${model.code}',
                      style: textStyle,
                    ),
                    _buildTag()
                  ],
                )),
            Text(
              '${DateFormatUtil.formatYMD(model.creationtime)}',
              style: textStyle,
            ),
          ],
        ));
  }

  Widget _buildTag() {
    bool isDone = model.agreements != null
        ? model.agreements
            .any((element) => element.state == ContractStatus.COMPLETE)
        : false;

    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 2),
      margin: EdgeInsets.only(left: 8),
      child: Center(
        child: Text(
          isDone ? '已签合同' : '未签合同',
          style: TextStyle(
              color: isDone ? Colors.white : Color(0xFF222222), fontSize: 10),
        ),
      ),
      decoration: BoxDecoration(
          color: isDone ? Color(0xffFF4D4F) : Color(0xFFD8D8D8),
          borderRadius: BorderRadius.circular(12)),
    );
  }
}

///类型
enum SaleOrderItemType {
  ///外接
  IMPORT,

  ///外发
  EXPORT
}
