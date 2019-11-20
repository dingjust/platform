import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/home/factory/factory_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CapacityFactoryInfoItem extends StatelessWidget {
  final FactoryCapacityModel model;

  const CapacityFactoryInfoItem({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO跳转工厂主页
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildFactoryCategoryCapacitiesWrap(context),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _buildBottomRow(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            '${model.title}',
            style: TextStyle(fontSize: 18),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFactoryCategoryCapacitiesWrap(BuildContext context) {
    double horizonSpacing = 10.0;
    double verticalSpacing = 10.0;

    return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
        //沿主轴方向居中
        spacing: horizonSpacing,
        runSpacing: verticalSpacing,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: model.categoryCapacities
            .map((capacity) => LayoutBuilder(
                  builder: (context, constraints) => Container(
                    width: (constraints.maxWidth - horizonSpacing) / 2,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    margin: EdgeInsets.only(bottom: 5),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                              child: Text(
                                capacity.category == null ? '' : '${capacity.category.parent == null ? '' : capacity.category.parent.name + '-'}'+'${capacity.category.name}',
                                  overflow: TextOverflow.ellipsis
                          )),
                        ),
                        Container(
                            child: Text(
                          '${capacity.capacityRange}/天',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        )),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100],
                    ),
                  ),
                ))
            .toList());
  }

  Widget _buildBottomRow() {
    return _buildDateItem();
  }

  Widget _buildFactoryItem() {
    return Expanded(
        flex: 1,
        child: Row(
          children: <Widget>[
            ImageFactory.buildThumbnailImage(model.belongTo.profilePicture,
                size: 50, containerSize: 60),
            Expanded(
              flex: 1,
              child: Container(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${model.belongTo.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      StarLevelAndOrdersCountText(
                        model: model.belongTo,
                      )
                    ],
                  )),
            )
          ],
        ));
  }

  Widget _buildDateItem() {
    String dateStr = '';
    if (model.longTerm ?? false) {
      dateStr = '长期有效';
    } else {
      dateStr =
          '${model?.dateStartPoint?.month}.${model?.dateStartPoint?.day}~${model?.dateEndPoint?.month}.${model?.dateEndPoint?.day}';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          '空闲日期',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          dateStr,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
