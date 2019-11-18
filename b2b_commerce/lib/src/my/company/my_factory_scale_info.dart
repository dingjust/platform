import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class MyFactoryScaleInfo extends StatefulWidget {
  MyFactoryScaleInfo(
    this.factory, {
    Key key,
    this.isSupplier,
  }) : super(key: key);

  final FactoryModel factory;
  final bool isSupplier;

  @override
  State createState() => MyFactoryScaleInfoState();
}

class MyFactoryScaleInfoState extends State<MyFactoryScaleInfo> {
  final double TITLE_WIDTH = 90;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    String _equipment = '';

    widget.factory.cuttingDepartment?.forEach((item){
      _equipment += enumMap(CuttingDepartmentsEnum, item);
      _equipment += ',';
    });
    widget.factory.productionWorkshop?.forEach((item) {
      _equipment += enumMap(ProductionWorkshopsEnum, item);
      _equipment += ',';
    });
    widget.factory.lastDepartment?.forEach((item) {
      _equipment += enumMap(LastDepartmentsEnum, item);
      _equipment += ',';
    });

    if(_equipment.contains(',')){
      _equipment = _equipment.substring(0,_equipment.length-1);
    }

    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                children: <Widget>[
                  Text('工厂规模',style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: (ScreenUtil.getScreenW(context) - 15)/2,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          child: Text(
                            '人数',
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            PopulationScaleLocalizedMap[widget.factory.populationScale] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: (ScreenUtil.getScreenW(context) - 15)/2,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          child: Text(
                            '产线',
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${widget.factory.productionLineQuantity == null ? '0' : widget.factory.productionLineQuantity.toString()}条',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: (ScreenUtil.getScreenW(context) - 15)/2,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          child: Text(
                            '厂房',
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                        Text(
                          '${widget.factory.factoryBuildingsQuantity == null ? '0' : widget.factory.factoryBuildingsQuantity.toString()}间',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: (ScreenUtil.getScreenW(context) - 15)/2,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          child: Text(
                            '产值',
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                        Text(
                          "${ScaleRangesLocalizedMap[widget.factory.scaleRange] ?? ''}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: TITLE_WIDTH,
                    child: Text(
                      '生产模式',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Text(
                    "${enumMap(ProductionModesEnum, widget.factory.productionMode) ?? ''}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: TITLE_WIDTH,
                    child: Text(
                      '设备',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${_equipment ?? ''}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

}
