import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

///省市选择器
class RegionCitySelector extends StatefulWidget {
  final Function(RegionModel, List<CityModel>) callBack;

  final VoidCallback cancell;

  const RegionCitySelector({Key key, this.callBack, this.cancell})
      : super(key: key);

  @override
  _RegionCitySelectorState createState() => _RegionCitySelectorState();
}

class _RegionCitySelectorState extends State<RegionCitySelector> {
  RegionModel _regionSelect;
  List<CityModel> _citySelects = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RegionModel>>(
        future: Provider.of<AddressState>(context).getRegions(),
        initialData: [],
        builder:
            (BuildContext context, AsyncSnapshot<List<RegionModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 150,
                        child: ListView(
                          children: snapshot.data.map((region) {
                            return GestureDetector(
                              onTap: () {
                                if (_regionSelect?.isocode == region.isocode) {
                                  _regionSelect = null;
                                  // itemOnTap(null, _citySelects);
                                  return;
                                } else {
                                  _regionSelect = region;
                                  _citySelects.clear();
                                  // itemOnTap(_regionSelect, _citySelects);
                                }
                                setState(() {});
                              },
                              child: Container(
                                  height: 40,
                                  color:
                                      _regionSelect?.isocode == region.isocode
                                          ? Colors.grey[200]
                                          : Colors.white,
                                  alignment: Alignment.center,
                                  child:
                                      _regionSelect?.isocode == region.isocode
                                          ? Text(
                                              '${region.name}',
                                              style: TextStyle(
                                                color: Colors.orange,
                                              ),
                                            )
                                          : Text('${region.name}')),
                            );
                          }).toList(),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.grey[200],
                          child: _regionSelect == null
                              ? Container()
                              : ListView(
                                  children: _regionSelect?.cities?.map((city) {
                                        return Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: FlatButton(
                                                  onPressed: () {
                                                    if (_citySelects
                                                        .contains(city)) {
                                                      _citySelects.remove(city);
                                                    } else {
                                                      _citySelects.add(city);
                                                    }
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        Row(children: <Widget>[
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      _citySelects
                                                              .contains(city)
                                                          ? Text(
                                                              '${city.name}',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                            )
                                                          : Text(
                                                              '${city.name}'),
                                                    ]),
                                                  )),
                                            )
                                          ],
                                        );
                                      })?.toList() ??
                                      [],
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top:
                              BorderSide(width: 0.5, color: Colors.grey[300]))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          widget.cancell();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ),
                      FlatButton(
                          onPressed: () {
                            setState(() {
                              _regionSelect = null;
                              _citySelects = [];
                            });
                            widget.callBack(_regionSelect, _citySelects);
                          },
                          child: Text(
                            '重置',
                            style: TextStyle(color: Colors.grey),
                          )),
                      FlatButton(
                        onPressed: () {
                          widget.callBack(_regionSelect, _citySelects);
                        },
                        child: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        });
  }
}
