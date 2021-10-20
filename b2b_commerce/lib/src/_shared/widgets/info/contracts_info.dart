import 'package:b2b_commerce/src/helper/contract_helper.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'info_widgets.dart';

///订单合同信息显示
class ContractsCard extends StatelessWidget {
  final List<ContractModel> agreements;

  final String label;

  final String hintText;

  ///点击前事件
  final VoidCallback beforeTap;

  const ContractsCard(
      {Key key,
      this.agreements,
      this.label = '合同',
      this.hintText = '暂无合同',
      this.beforeTap})
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
                ],
              ),
            ),
            ..._buildRows(context)
          ],
        ));
  }

  List<Widget> _buildRows(BuildContext context) {
    if (agreements != null && agreements.length > 0) {
      List<Widget> widgets = [];
      for (int i = 0; i < agreements.length; i++) {
        widgets.add(_buildRow(context, agreements[i]));
        if (i != agreements.length - 1) {
          widgets.add(InfoDivider(
            height: 28,
          ));
        }
      }
      return widgets;
    } else {
      return [
        Center(
          child: Text(
            '$hintText',
            style: TextStyle(color: Colors.grey),
          ),
        )
      ];
    }
  }

  Widget _buildRow(
    BuildContext context,
    ContractModel model,
  ) {
    return GestureDetector(
      onTap: () {
        beforeTap?.call();
        ContractHelper.open(context: context, model: model);
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
                '${ContractStatusLocalizedMap[model.state]}',
                style: TextStyle(color: Colors.grey),
              )
            ],
          )),
    );
  }
}
