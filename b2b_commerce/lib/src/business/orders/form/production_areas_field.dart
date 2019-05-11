import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ProductionAreasField extends StatefulWidget {
  RequirementOrderModel item;

  ProductionAreasField(this.item);

  ProductionAreasFieldState createState() => ProductionAreasFieldState();
}

class ProductionAreasFieldState extends State<ProductionAreasField> {
  List<RegionModel> _regionSelects;
  List<RegionModel> _regions = [];

  @override
  void initState() {
    _regionSelects = widget.item.details.productiveOrientations ?? [];
    // TODO: implement initState
    super.initState();
  }

  //格式选中的地区（多选）
  String formatAreaSelectsText(List<RegionModel> selects, int count) {
    String text = '';

    for (int i = 0; i < selects.length; i++) {
      if (i > count - 1) {
        text += '...';
        break;
      }

      if (i == selects.length - 1) {
        text += selects[i].name;
      } else {
        text += selects[i].name + '、';
      }
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '生产地区',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            trailing: Text(
              widget.item.details?.productiveOrientations == null
                  ? '选取'
                  : formatAreaSelectsText(_regionSelects, 2),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
          //获取所有省份
          rootBundle.loadString('data/province.json').then((v) {
            List data = json.decode(v);
            _regions = data
                .map<RegionModel>((region) => RegionModel.fromJson(region))
                .toList();
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return RegionSelector(
                  regions: _regions,
                  regionSelects: _regionSelects,
                  multiple: true,
                );
              },
            ).then((val) {
              setState(() {
                if (_regionSelects.length > 0) {
                  widget.item.details.productiveOrientations = _regionSelects.map((region) => RegionModel(isocode: region.isocode,name: region.name,)).toList();
                } else {
                  widget.item.details.productiveOrientations = null;
                }
              });
            });
          });

        });
  }
}
