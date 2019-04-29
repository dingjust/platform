import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';

class ProductionAreasField extends StatefulWidget {
  RequirementOrderModel item;

  ProductionAreasField(this.item);

  ProductionAreasFieldState createState() => ProductionAreasFieldState();
}

class ProductionAreasFieldState extends State<ProductionAreasField> {
  List<RegionModel> _regionSelects = [];
  List<String> _regionCodeSelects = [];
  List<RegionModel> _regions = [];

  @override
  void initState() {
    //获取所有省份
    rootBundle.loadString('data/province.json').then((v) {
      List data = json.decode(v);
      _regions = data
          .map<RegionModel>((region) => RegionModel.fromJson(region))
          .toList();
    });
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
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, mSetState) {
                return Container(
                  color: Colors.white,
                  height: 360,
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 3),
//                        color: Colors.grey[300],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                mSetState(() {
                                  _regionCodeSelects.clear();
                                  _regionSelects.clear();
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text('重置'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: ActionChip(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                ),
                                label: Text('确定'),
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 300,
                        child: ListView(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          children: _regions.map((region) {
                            return InkWell(
                              onTap: () {
                                mSetState(() {
                                  if (_regionCodeSelects
                                      .contains(region.isocode)) {
                                    _regionCodeSelects.remove(region.isocode);
                                    _regionSelects.removeWhere(
                                        (reg) => region.isocode == reg.isocode);
                                  } else {
                                    _regionSelects.add(region);
                                    _regionCodeSelects.add(region.isocode);
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _regionCodeSelects
                                          .contains(region.isocode)
                                      ? Color.fromRGBO(255, 214, 12, 1)
                                      : Colors.white,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(region.name),
//                                    Offstage(
//                                      offstage: !_regionCodeSelects
//                                          .contains(region.isocode),
//                                      child: Icon(
//                                        Icons.done,
//                                        size: 12,
//                                      ),
//                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              });
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
  }
}
