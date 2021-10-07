import 'package:b2b_commerce/src/business/orders/reconciliation/form/reconciliation_order_form.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'info_widgets.dart';

///对账单信息显示
class ReconciliationOrderCard extends StatelessWidget {
  final List<FastReconciliationSheetModel> sheets;

  final String label;

  final String hintText;

  final VoidCallback beforeTap;

  final VoidCallback callback;

  final SalesProductionOrderModel order;

  // BuildContext

  const ReconciliationOrderCard(
      {Key key,
      this.sheets,
      this.label = '对账单',
      this.hintText = '暂无对账单',
      this.callback,
      this.beforeTap,
      this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              margin: EdgeInsets.only(bottom: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '$label',
                      style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                    ),
                  ),
                  Container(
                    child: canCreate()
                        ? GestureDetector(
                            onTap: () => onCreate(context),
                            child: Row(
                              children: [
                                Text(
                                  '创建对账单',
                                  style: TextStyle(
                                      color: Color(0xFFFF4D4F), fontSize: 14),
                                ),
                                Icon(Icons.chevron_right,
                                    color: Color(0xFFFF4D4F))
                              ],
                            ),
                          )
                        : Container(),
                  )
                ],
              ),
            ),
            ..._buildRows()
          ],
        ));
  }

  List<Widget> _buildRows() {
    //账单行
    List<Widget> widgets = [];
    if (filterSheets != null && filterSheets.length > 0) {
      for (int i = 0; i < filterSheets.length; i++) {
        widgets.add(_ReconciliationRow(
          filterSheets[i],
          beforeTap: beforeTap,
          callback: callback,
        ));
        if (i != filterSheets.length - 1) {
          widgets.add(InfoDivider(
            height: 28,
          ));
        }
      }
    }
    return widgets;
  }

  ///有效对账单
  List<FastReconciliationSheetModel> get filterSheets {
    if (sheets != null) {
      return sheets
          .where((element) =>
              element.state != FastReconciliationSheetState.CANCELLED)
          .toList();
    }
    return [];
  }

  bool signDisable(FastReconciliationSheetModel order) {
    return order.state == FastReconciliationSheetState.PENDING_APPROVAL ||
        order.state == FastReconciliationSheetState.CANCELLED;
  }

  ///能否创建对账单
  bool canCreate() {
    if (order != null) {
      return order.originCooperator != null && order.targetCooperator != null;
    }
    return false;
  }

  void onCreate(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => ReconciliationOrderForm(
                  order: order,
                )))
        .then((value) {
      // if (value) {
      callback?.call();
      // }
    });
  }

  ///更新
  void onEdit(BuildContext context, FastReconciliationSheetModel model) async {
    //获取详情
    Function cancelFunc =
        BotToast.showLoading(crossPage: false, clickClose: false);
    FastReconciliationSheetModel old =
        await ReconciliationOrderRespository.getDetail(model.id);
    cancelFunc.call();

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(
            builder: (context) => ReconciliationOrderForm(
                  order: order,
                  model: old,
                )))
        .then((value) {
      callback?.call();
    });
  }
}

class _ReconciliationRow extends StatelessWidget {
  final FastReconciliationSheetModel model;
  final VoidCallback beforeTap;

  final VoidCallback callback;

  const _ReconciliationRow(this.model, {Key key, this.callback, this.beforeTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        beforeTap?.call();
        Navigator.of(context)
            .pushNamed(AppRoutes.ROUTE_RECONCILIATION_ORDER_DETAIL, arguments: {
          'id': model.id,
        }).then((needRefresh) {
          callback?.call();
        });
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 24,
                margin: EdgeInsets.only(right: 4),
                child: Image.asset(
                  'img/icons/b2b-v2/my/account@3x.png',
                  package: 'assets',
                  width: 24,
                ),
              ),
              Expanded(child: Text('${model.title}')),
              Text(
                '${FastReconciliationSheetStateLocalizedMap[model.state]}',
                style: TextStyle(color: Color(0xFFFF4D4F), fontSize: 14),
              ),
              Icon(Icons.chevron_right, color: Color(0xFFFF4D4F))
            ],
          )),
    );
  }
}
