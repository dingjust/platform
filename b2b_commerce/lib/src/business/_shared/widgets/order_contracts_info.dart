import 'package:b2b_commerce/src/helper/contract_helper.dart';
import 'package:b2b_commerce/src/helper/doc_signature_helper.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

///订单合同信息显示
class OrderContractsBlock extends StatelessWidget {
  final List<ContractModel> agreements;

  final String label;

  final String hintText;

  const OrderContractsBlock(
      {Key key, this.agreements, this.label = '合同', this.hintText = '未创建合同'})
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
