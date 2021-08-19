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
            ..._buildPaymentInfo(context)
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

  List<Widget> _buildPaymentInfo(BuildContext context) {
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

    return model.paymentOrders
        .map((e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 3,
                    child: RichText(
                        text: TextSpan(
                            text: (e.batch == 1 ? '定金：' : '尾款：'),
                            style: TextStyle(color: Colors.black87),
                            children: [
                          TextSpan(
                              text: '￥${e.payAmount}',
                              style: TextStyle(color: Colors.red)),
                          TextSpan(
                              text: '(${CmtPaymentStateLocalizedMap[e.state]})',
                              style: TextStyle(
                                  color: e.state == CmtPaymentState.PAID
                                      ? Colors.green
                                      : Colors.orange))
                        ]))),
                e.canPay
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => OrderPaymentPageV2(e)))
                              .then((needRefresh) {
                            //刷新
                            if (needRefresh != null && needRefresh) {
                              if (type == SaleOrderItemType.IMPORT)
                                //外接订单列表刷新
                                Provider.of<ExternalSaleOrdersState>(context,
                                        listen: false)
                                    .clear();
                              else
                                //外发订单列表刷新
                                Provider.of<OutOrdersState>(context,
                                        listen: false)
                                    .clear();
                            }
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.orange,
                                width: 0.5,
                              )),
                          child: Text(
                            '去支付',
                            style:
                                TextStyle(color: Colors.orange, fontSize: 14),
                          ),
                        ),
                      )
                    : Container()
              ],
            ))
        .toList();
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
      padding: EdgeInsets.symmetric(horizontal: 6),
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
