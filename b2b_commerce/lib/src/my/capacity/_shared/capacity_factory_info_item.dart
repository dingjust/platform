import 'package:b2b_commerce/src/_shared/widgets/info/info_widgets.dart';
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
            _InfoRow(label: '空闲日期', val: _buildDateStr()),
            InfoDivider(height: 1),
            Container(height: 14),
            ..._buildItems(context)
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    if (model.categoryCapacities != null) {
      return model.categoryCapacities.map((e) {
        String title = '';
        String val1 = '';
        if (model.categoryCapacities.first.id == e.id) {
          title = '产能';
        }
        val1 = e.category == null
            ? ''
            : '${e.category.parent == null ? '' : e.category.parent.name + '-'}' +
                '${e.category.name}';
        return _InfoRow(
          label: '$title',
          val: '$val1',
          val2: '${e.capacityRange}件/天',
        );
      }).toList();
    }

    return [];
  }

  String _buildDateStr() {
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
          '${model?.dateStartPoint?.month}.${model?.dateStartPoint?.day}~${model?.dateEndPoint?.month}.${model?.dateEndPoint?.day}';
    }

    return dateStr;
  }
}

class _InfoRow extends StatelessWidget {
  final String label;

  final String val;

  final String val2;

  const _InfoRow({Key key, this.label, this.val, this.val2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(
              '$label',
              style: TextStyle(color: Color(0xFF999999), fontSize: 14),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            child: Text(
              '${val ?? ''}',
              style: TextStyle(color: Color(0xFF222222), fontSize: 14),
            ),
          ),
          Expanded(
              child: Text(
            '${val2 ?? ''}',
            style: TextStyle(color: Color(0xFFFF4D4F), fontSize: 14),
          ))
        ],
      ),
    );
  }
}
