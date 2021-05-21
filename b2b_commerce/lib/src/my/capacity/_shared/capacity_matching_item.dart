import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/_shared/widgets/factory_widget.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CapacityMatchingItem extends StatelessWidget {
  final FactoryCapacityModel model;

  const CapacityMatchingItem({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //点击量
        // ItemRepository().onDetail(model.id);
        Navigator.of(context).pushNamed(AppRoutes.ROUTE_FACTORY_INTRODUCTION,
            arguments: {'uid': model.belongTo.uid});
      },
      child: Container(
        height: 162,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildTitleRow(),
            _buildMain(context),
            _buildBottomRow()
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              '${model.title}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildDateItem()
        ],
      ),
    );
  }

  Widget _buildMain(BuildContext context) {
    return Row(
      children: <Widget>[
        ImageFactory.buildThumbnailImage(model.belongTo.profilePicture,
            size: 40, containerSize: 50),
        Container(
          width: 10,
        ),
        Expanded(child: _buildFactoryCategoryCapacitiesWrap(context)),
      ],
    );
  }

  Widget _buildFactoryCategoryCapacitiesWrap(BuildContext context) {
    double horizonSpacing = 20.0;
    double verticalSpacing = 10.0;

    List<Widget> children = model.categoryCapacities
        .map((capacity) => LayoutBuilder(
              builder: (context, constraints) => Container(
                width: constraints.maxWidth / 2 - horizonSpacing,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                        child: Text(
                      '${capacity.category.name}',
                      style: TextStyle(fontSize: 10),
                    )),
                    Expanded(
                      child: Container(
                          child: Text(
                        '${capacity.capacityRange}件/天',
                        style: TextStyle(color: Colors.red, fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      )),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
              ),
            ))
        .toList();

    //只有一个时
    if (children.length == 1) {
      children.add(LayoutBuilder(
        builder: (context, constraints) =>
            Container(
              width: constraints.maxWidth / 2 - horizonSpacing,
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.only(bottom: 5),
            ),
      ));
    }

    return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        //沿主轴方向居中
        spacing: horizonSpacing,
        runSpacing: verticalSpacing,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: children);
  }

  Widget _buildBottomRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            '${model.belongTo.name}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ApprovedTag(model: model.belongTo)
      ],
    );
  }

  Widget _buildDateItem() {
    String dateStr = '';
    if (model.longTerm ?? false) {
      dateStr = '长期有效';
    } else if (model.dateStartPoint == null) {
      dateStr = '长期有效';
    } else if (model.dateStartPoint != null && model.dateEndPoint == null) {
      dateStr =
      '${model?.dateStartPoint?.month}.${model?.dateStartPoint?.day}~长期有效';
    } else {
      dateStr =
      '${model?.dateStartPoint?.month}.${model?.dateStartPoint?.day}~${model
          ?.dateEndPoint?.month}.${model?.dateEndPoint?.day}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          dateStr,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          '空闲日期',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
