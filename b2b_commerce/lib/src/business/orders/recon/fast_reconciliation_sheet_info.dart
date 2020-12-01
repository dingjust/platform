import 'package:b2b_commerce/src/business/orders/sales_production/out_order/form/form_components.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/doc_signature_helper.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

///快速对账单信息显示
class FastReconSheetBlock extends StatelessWidget {
  final FastReconciliationSheetModel sheet;

  final String label;

  final String hintText;

  const FastReconSheetBlock(
      {Key key, this.sheet, this.label = '对账单', this.hintText = '未创建对账单'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [FormLabel('$label：')],
                ),
              ),
              ...sheet != null ? _buildMain(context) : [_buildNoData()]
            ],
          )),
    );
  }

  List<Widget> _buildMain(BuildContext context) {
    return [
      Row(
        children: [
          Expanded(
            child: Text(
              '单号：${sheet.code}',
              style: TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildStateText()
        ],
      ),
      Divider(),
      Row(children: [
        for (DocSignatureModel doc in sheet?.docSignatures ?? [])
          _buildBtn(context, doc)
      ])
    ];
  }

  ///对账单状态
  Widget _buildStateText() {
    if (sheet.state == FastReconciliationSheetState.PENDING_B_SIGN) {
      return Text('待签署', style: TextStyle(color: Colors.blueAccent));
    } else if (sheet.state == FastReconciliationSheetState.COMPLETED) {
      return Text('完成', style: TextStyle(color: Colors.green));
    }
    return Container();
  }

  Widget _buildNoData() {
    return Center(
      child: Text(
        '$hintText',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildBtn(BuildContext context, DocSignatureModel model,
      {double height = 85, double width = 80}) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            DocSignatureHelper.open(context: context, model: model);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                B2BIcons.agreement,
                color: Color(0xffffca3a),
                size: 40,
              ),
              Text(
                '${DocSignatureStateLocalizedMap[model.state]}',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) async {
    Navigator.of(context)
        .pushNamed(AppRoutes.ROUTE_RECONCILIATION_ORDER_DETAIL, arguments: {
      'id': sheet.id,
    }).then((needRefresh) {
      // if (needRefresh != null && needRefresh) {
      //   Provider.of<DeliveryOrdersState>(context).clear();
      // }
    });
  }
}
