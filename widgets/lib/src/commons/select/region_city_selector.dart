import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';

class RegionCitySelector extends StatefulWidget {
  List<RegionModel> regions;
  RegionModel regionSelect;
  List<CityModel> citySelects;
  bool multiple;

  RegionCitySelector({this.regions,
    this.regionSelect,
    this.citySelects,
    this.multiple = true});

  _RegionCitySelectorState createState() => _RegionCitySelectorState();
}

class _RegionCitySelectorState extends State<RegionCitySelector> {
  List<String> _cityCodeSelects = [];
//  RegionModel _regionModel = RegionModel();

  @override
  void initState() {
//    _regionModel = widget.regions.firstWhere((region) => widget.regionSelect.isocode == region.isocode,orElse: () => null);

    _cityCodeSelects = widget.citySelects.map((city) => city.code).toList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 353,
      child: Column(
        children: <Widget>[
          Container(
            height: 51,
            child: Card(
              elevation: 2,
              margin: EdgeInsets.only(bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        widget.regionSelect.isocode = null;
                        widget.regionSelect.name = null;
                        widget.regionSelect.id = null;
                        widget.regionSelect.cities = null;
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
                        borderRadius: BorderRadius.all(Radius.circular(5)),
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
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width / 2,
                child: ListView(
                  children: widget.regions.map((region) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.regionSelect.isocode = region.isocode;
                          widget.regionSelect.name = region.name;
                          widget.regionSelect.id = region.id;
                          widget.regionSelect.cities = region.cities;
                          _cityCodeSelects.clear();
                          widget.citySelects.clear();
                        });
                      },
                      child: Container(
                        color: widget.regionSelect != null &&
                                widget.regionSelect.isocode == region.isocode
                            ? Colors.white
                            : Colors.grey[350],
                        height: 30,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Center(child: Text(region.name)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width / 2,
                child: ListView(
                  children: widget.regionSelect.cities?.map((city) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_cityCodeSelects.contains(city.code)) {
                            _cityCodeSelects.remove(city.code);
                            widget.citySelects.removeWhere(
                                    (city1) => city.code == city1.code);
                          } else {
                            if (!widget.multiple) {
                              widget.citySelects.clear();
                                  widget.citySelects.add(city);
                              _cityCodeSelects.clear();
                                  _cityCodeSelects.add(city.code);
                            } else {
                              widget.citySelects.add(city);
                              _cityCodeSelects.add(city.code);
                            }
                          }
                        });
                      },
                      child: Container(
                        color: _cityCodeSelects.contains(city.code)
                            ? Colors.white
                            : Colors.grey[300],
                        height: 30,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 2,
                        child: Center(child: Text(city.name)),
                      ),
                    );
                  })?.toList() ??
                      [],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
