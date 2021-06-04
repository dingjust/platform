import 'package:b2b_commerce/src/_shared/widgets/order_status_color.dart';
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
        // height: 120,
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _Header(
              model: model,
            ),
            _Row1(
              model: model,
              type: type,
            ),
            _End(model: model),
            _Row2(model: model),
            ..._buildPaymentInfo(context)
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
              Provider.of<ExternalSaleOrdersState>(context).clear();
            else
              //外发订单列表刷新
              Provider.of<OutOrdersState>(context).clear();
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
                            text: e.batch == 1 ? '定金：' : '尾款：',
                            style: TextStyle(color: Colors.black87),
                            children: [
                          TextSpan(
                              text: '${CmtPaymentStateLocalizedMap[e.state]}',
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
                              Provider.of<ExternalSaleOrdersState>(context)
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

  const _Header({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(
            '单号：${model.code}',
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        _buildTag(),
        Expanded(
          flex: 1,
          child: Container(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${SalesProductionOrderStateLocalizedMap[model.state]}',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 18,
                    color: getSalesProductionStateColor(model.state),
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  Widget _buildTag() {
    //自创外接订单无originCompany
    return model.originCompany == null
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Constants.THEME_COLOR_MAIN)),
            child: Center(
              child: Text(
                '自创',
                style:
                    TextStyle(color: Constants.THEME_COLOR_MAIN, fontSize: 10),
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: Color.fromRGBO(68, 138, 255, 1))),
            child: Center(
              child: Text(
                '线上',
                style: TextStyle(
                    color: Color.fromRGBO(68, 138, 255, 1), fontSize: 10),
              ),
            ),
          );
  }
}

class _Row1 extends StatelessWidget {
  final SalesProductionOrderModel model;

  final SaleOrderItemType type;

  const _Row1({Key key, this.model, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.only(right: 5),
          child: CircleAvatar(
            backgroundImage: CooperatorHelper.getCooperatorImage(
                model.targetCooperator, model.originCompany),
            radius: 20,
          ),
        ),
        Expanded(
            child: Text(
          '${CooperatorHelper.getCooperatorName(model.targetCooperator, model.originCompany, model.originCooperator)}',
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        )),
        _buildTypeTag(),
        _buildTag()
      ],
    );
  }

  Widget _buildTag() {
    bool isDone = model.agreements != null
        ? model.agreements
            .any((element) => element.state == ContractStatus.COMPLETE)
        : false;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Center(
        child: Text(
          isDone ? '已签合同' : '未签合同',
          style: TextStyle(
              color: isDone ? Color.fromRGBO(103, 194, 58, 1) : Colors.black54,
              fontSize: 10),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(
              color:
              isDone ? Color.fromRGBO(225, 243, 216, 1) : Colors.grey[200],
              width: 0.5),
          color: isDone ? Color.fromRGBO(240, 249, 235, 1) : Colors.grey[200]),
    );
  }

  ///合作方式
  Widget _buildTypeTag() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Center(
        child: Text(
          '${CooperationModeLocalizedMap[model.cooperationMode]}',
          style: TextStyle(color: Colors.black54, fontSize: 10),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black54, width: 0.5),
          borderRadius: BorderRadius.circular(10)),
    );
  }
}

class _Row2 extends StatelessWidget {
  final SalesProductionOrderModel model;

  const _Row2({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 3,
            child: RichText(
                text: TextSpan(
                    text: '产品数：',
                    style: TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(
                          text: '${model.entrySize}',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 102, 102, 1)))
                    ]))),
        Text(
          '${DateFormatUtil.formatYMD(model.creationtime)}',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        )
      ],
    );
  }
}

class _End extends StatelessWidget {
  final SalesProductionOrderModel model;

  const _End({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 4,
            child: RichText(
                text: TextSpan(
                    text: '订单数量：',
                    style: TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(
                          text: '${model.totalQuantity}',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 102, 102, 1)))
                    ]))),
        Expanded(
            flex: 6,
            child: RichText(
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: '订单金额：',
                    style: TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(
                          text: '￥${model.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Color.fromRGBO(255, 102, 102, 1)))
                    ]))),
      ],
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
