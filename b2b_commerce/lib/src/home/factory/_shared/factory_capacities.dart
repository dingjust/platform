import 'package:b2b_commerce/src/my/capacity/_shared/capacity_factory_info_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class FactoryCapacities extends StatelessWidget {
  final FactoryModel model;

  const FactoryCapacities({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (model.capacities == null || model.capacities.isEmpty)
      return Container(
        color: Colors.grey[50],
        padding: EdgeInsets.only(top: 50),
        child: Text(
          '未发布空闲产能',
          textAlign: TextAlign.center,
        ),
      );

    return Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: model.capacities
            .map((e) => Container(
                margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
                padding: EdgeInsets.fromLTRB(12, 14, 12, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: CapacityFactoryInfoItem(
                  model: e,
                )))
            .toList(),
      ),
    );
  }
}
