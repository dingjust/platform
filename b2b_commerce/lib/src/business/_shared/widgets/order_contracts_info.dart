import 'package:b2b_commerce/src/helper/contract_helper.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

///订单合同信息显示
class OrderContractsBlock extends StatelessWidget {
  final List<ContractModel> agreements;

  const OrderContractsBlock({Key key, this.agreements}) : super(key: key);

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
                  '合同',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            (agreements != null && agreements.length > 0)
                ? Row(
                    children: [
                      for (UserAgreementModel e in agreements ?? [])
                        _buildBtn(context, e)
                    ],
                  )
                : Center(
                    child: Text(
                      '未创建合同',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
          ],
        ));
  }

  Widget _buildBtn(BuildContext context, ContractModel model,
      {double height = 80, double width = 60}) {
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
              Icon(
                B2BIcons.agreement,
                color: Color(0xffffca3a),
                size: 40,
              ),
              Text('${model.title}'),
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
