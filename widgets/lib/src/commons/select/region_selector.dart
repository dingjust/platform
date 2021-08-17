import 'dart:convert';

import 'package:core/core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';

//省级选择器
class RegionSelector extends StatefulWidget {
  List<RegionModel>? regions;
  List<RegionModel>? regionSelects;
  bool multiple;

  RegionSelector({
    this.regions,
    this.regionSelects,
    this.multiple = false,
  });

  _RegionSelectorState createState() => _RegionSelectorState();
}

class _RegionSelectorState extends State<RegionSelector> {
  List<String> _regionCodeSelects = [];

  @override
  void initState() {
    _regionCodeSelects =
        widget.regionSelects!.map((region) => region.isocode).toList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: widget.multiple ? 360 : 300,
      child: Column(
        children: <Widget>[
          Offstage(
            offstage: !widget.multiple,
            child: Card(
              elevation: 2,
              margin: EdgeInsets.only(bottom: 3),
//                        color: Colors.grey[300],
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        _regionCodeSelects.clear();
                        widget.regionSelects!.clear();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('重置'),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(right: 15),
                    child: ActionChip(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5)),
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
          ),
          Container(
            height: 300,
            child: ListView(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              children: widget.regions!.map((region) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      if (region.isocode == Constants.WHOLE_COUNTRY_ISOCODE) {
                        _regionCodeSelects.clear();
                        widget.regionSelects!.clear();
                      } else {
                        _regionCodeSelects
                            .remove(Constants.WHOLE_COUNTRY_ISOCODE);
                        widget.regionSelects!.removeWhere((reg) =>
                            reg.isocode == Constants.WHOLE_COUNTRY_ISOCODE);
                      }

                      if (_regionCodeSelects
                          .contains(region.isocode)) {
                        _regionCodeSelects.remove(region.isocode);
                        widget.regionSelects!.removeWhere(
                            (reg) => region.isocode == reg.isocode);
                        if (!widget.multiple) {
                          Navigator.pop(context);
                        }
                      } else {
                        if(widget.multiple) {
                          widget.regionSelects!.add(region);
                          _regionCodeSelects.add(region.isocode);
                        } else{
                          widget.regionSelects!.clear();
                          _regionCodeSelects.clear();
                          widget.regionSelects!.add(region);
                          _regionCodeSelects.add(region.isocode);
                          Navigator.pop(context);
                        }

                      }
                    });
                  },
                  child: Container(
                    decoration: ShapeDecoration(
                      shape: region.isocode == Constants.WHOLE_COUNTRY_ISOCODE ? UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 0.5)) : InputBorder.none,
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 15, vertical: 1),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10),
                        color: _regionCodeSelects
                            .contains(region.isocode)
                            ? Color.fromRGBO(
                            255, 214, 12, 1)
                            : Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          Text(region.name),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
