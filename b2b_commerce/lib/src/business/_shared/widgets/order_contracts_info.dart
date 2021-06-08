import 'package:b2b_commerce/src/business/doc/doc_signature_tag.dart';
import 'package:b2b_commerce/src/helper/contract_helper.dart';
import 'package:b2b_commerce/src/helper/doc_signature_helper.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

///订单合同信息显示
class OrderContractsBlock extends StatelessWidget {
  final List<ContractModel> agreements;

  final String label;

  final String hintText;

  ///点击前事件
  final VoidCallback beforeTap;

  const OrderContractsBlock(
      {Key key,
      this.agreements,
      this.label = '合同',
      this.hintText = '暂无合同',
      this.beforeTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '$label',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            (agreements != null && agreements.length > 0)
                ? Wrap(
              children: [
                for (UserAgreementModel e in agreements ?? [])
                  _buildBtn(context, e)
              ],
            )
                : Center(
              child: Text(
                '$hintText',
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ));
  }

  Widget _buildBtn(BuildContext context, ContractModel model,
      {double height = 85, double width = 80}) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            beforeTap?.call();
            ContractHelper.open(context: context, model: model);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DocSignatureHelper.getDocTypeIcon(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${model.title}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              Text(
                '${ContractStatusLocalizedMap[model.state]}',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}

///对账单信息显示
class DocSignaturesBlock extends StatelessWidget {
  final List<FastReconciliationSheetModel> sheets;

  final String label;

  final String hintText;

  final VoidCallback beforeTap;

  final VoidCallback callback;

  const DocSignaturesBlock({Key key,
    this.sheets,
    this.label = '对账单',
    this.hintText = '暂无对账单',
    this.callback,
    this.beforeTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '$label',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            (sheets != null && sheets.length > 0)
                ? Wrap(
              children: [
                for (FastReconciliationSheetModel e in sheets ?? [])
                  _buildBtn(context, e)
              ],
            )
                : Center(
              child: Text(
                '$hintText',
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ));
  }

  Widget _buildBtn(BuildContext context, FastReconciliationSheetModel model,
      {double height = 80, double width = 80}) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            beforeTap?.call();
            DocSignatureHelper.open(
                context: context,
                model: model.docSignatures.first,
                disable: signDisable(model))
                .then((value) {
              //需要刷新
              // if (value != null && value) {
              callback?.call();
              // }
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DocSignatureHelper.getDocTypeIcon(
                  signMethod: model.docSignatures.first.signMethod),
              Expanded(
                child: Text('${model.title}'),
                flex: 1,
              ),
              DocSignatureTag(doc: model.docSignatures.first)
            ],
          ),
        ),
      ),
    );
  }

  bool signDisable(FastReconciliationSheetModel order) {
    return order.state == FastReconciliationSheetState.PENDING_APPROVAL ||
        order.state == FastReconciliationSheetState.CANCELLED;
  }
}
