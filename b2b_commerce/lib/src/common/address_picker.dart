import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void ChangeData(Map<String, dynamic> map);
typedef List<Widget> CreateWidgetList();

class AddressPicker {
  Function cacel;

  AddressPicker({this.cacel}){
    if(this.cacel == null) this.cacel = (){};
  }

  void showAddressPicker(BuildContext context, {
    ChangeData selectProvince,
    ChangeData selectCity,
    ChangeData selectArea,
  }) {
    rootBundle.loadString('data/province.json').then((v) {
      List data = json.decode(v);
      Navigator.push(
        context,
        new _AddressPickerRoute(
          data: data,
          selectProvince: selectProvince,
          selectCity: selectCity,
          selectArea: selectArea,
          theme: Theme.of(context, shadowThemeOnly: true),
          barrierLabel:
          MaterialLocalizations
              .of(context)
              .modalBarrierDismissLabel,
          cacel:cacel,
        ),
      );
    });
  }
}

class _AddressPickerRoute<T> extends PopupRoute<T> {
  final ThemeData theme;
  final String barrierLabel;
  final List data;
  final ChangeData selectProvince;
  final ChangeData selectCity;
  final ChangeData selectArea;
  Function cacel;

  _AddressPickerRoute({
    this.theme,
    this.barrierLabel,
    this.data,
    this.selectProvince,
    this.selectCity,
    this.selectArea,
    this.cacel,
  });

  @override
  Duration get transitionDuration => Duration(milliseconds: 2000);

  @override
  @override
  Color get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Widget bottomSheet = new MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: new _AddressPickerWidget(
          route: this,
          data: data,
          selectProvince: selectProvince,
          selectCity: selectCity,
          selectArea: selectArea,
          cacel:cacel,
      ),
    );
    if (theme != null) {
      bottomSheet = new Theme(data: theme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _AddressPickerWidget extends StatefulWidget {
  final _AddressPickerRoute route;
  final List data;
  final ChangeData selectProvince;
  final ChangeData selectCity;
  final ChangeData selectArea;
  Function cacel;

  _AddressPickerWidget({Key key,
    @required this.route,
    this.data,
    this.selectProvince,
    this.selectCity,
    this.selectArea,
    this.cacel,
  });

  @override
  State createState() {
    return new _AddressPickerState();
  }
}

class _AddressPickerState extends State<_AddressPickerWidget> {
  FixedExtentScrollController provinceController;
  FixedExtentScrollController cityController;
  FixedExtentScrollController areaController;
  int provinceIndex = 0,
      cityIndex = 0,
      areaIndex = 0;
  List province = new List();
  List city = new List();
  List area = new List();

  @override
  void initState() {
    super.initState();
    provinceController = new FixedExtentScrollController();
    cityController = new FixedExtentScrollController();
    areaController = new FixedExtentScrollController();
    setState(() {
      province = widget.data;
      city = widget.data[provinceIndex]['cities'];
      area = widget.data[provinceIndex]['cities'][cityIndex]['districts'];
    });
  }

  Widget _bottomView() {
    return WillPopScope(
      onWillPop: () {
//        Map<String, dynamic> provinceMap = {
//          "code": province[provinceIndex]['code'],
//          "name": province[provinceIndex]['name']
//        };
//        Map<String, dynamic> cityMap = {
//          "code": province[provinceIndex]['sub'][cityIndex]
//          ['code'],
//          "name": province[provinceIndex]['sub'][cityIndex]
//          ['name']
//        };
//        Map<String, dynamic> areaMap = {
//          "code": province[provinceIndex]['sub'][cityIndex]['sub']
//          [areaIndex]['code'],
//          "name": province[provinceIndex]['sub'][cityIndex]['sub']
//          [areaIndex]['name']
//        };
//        if (widget.selectProvince != null) {
//          widget.selectProvince(provinceMap);
//        }
//        if (widget.selectCity != null) {
//          widget.selectCity(cityMap);
//        }
//        if (widget.selectArea != null) {
//          widget.selectArea(areaMap);
//        }
        Navigator.pop(context);
        return Future.value(false);
      },
      child: new Container(
          width: double.infinity,
          color: Colors.white,
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new Row(
                  children: <Widget>[
                    FlatButton(
                      onPressed: widget.cacel,
                      child: new Text(
                        '取消',
                        style: new TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Map<String, dynamic> provinceMap = {
                          "isocode": province[provinceIndex]['isocode'],
                          "name": province[provinceIndex]['name']
                        };
                        Map<String, dynamic> cityMap;
                        if(city != null && city.isNotEmpty){
                          cityMap = {
                            "code": province[provinceIndex]['cities'][cityIndex]
                            ['code'],
                            "name": province[provinceIndex]['cities'][cityIndex]
                            ['name']
                          };
                        }

                        Map<String, dynamic> areaMap;
                        if(area != null && area.isNotEmpty){
                          areaMap = {
                            "code": province[provinceIndex]['cities'][cityIndex]['districts']
                            [areaIndex]['code'],
                            "name": province[provinceIndex]['cities'][cityIndex]['districts']
                            [areaIndex]['name']
                          };
                        }

                        if (widget.selectProvince != null) {
                          widget.selectProvince(provinceMap);
                        }
                        if (widget.selectCity != null) {
                          widget.selectCity(cityMap);
                        }
                        if (widget.selectArea != null) {
                          widget.selectArea(areaMap);
                        }
                        Navigator.pop(context);
                      },
                      child: new Text(
                        '确定',
                        style: new TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                flex: 1,
              ),
              new Row(
                children: <Widget>[
                  new _MyAddressPicker(
                    key: Key('province'),
                    controller: provinceController,
                    createWidgetList: () {
                      return province.map((v) {
                        return new Align(
                          child: new Text(
                            v['name'],
                            textScaleFactor: 0.8,
                          ),
                          alignment: Alignment.centerLeft,
                        );
                      }).toList();
                    },
                    changed: (index) {
                      setState(() {
                        provinceIndex = index;
                        cityIndex = 0;
                        areaIndex = 0;
                        cityController.jumpToItem(0);
                        areaController.jumpToItem(0);
                        city = widget.data[provinceIndex]['cities'];
                        if(city.isEmpty){
                          area = [];
                        }else{
                          area =
                          widget.data[provinceIndex]['cities'][cityIndex]['districts'];
                        }
                      });
                    },
                  ),
                  new _MyAddressPicker(
                    key: Key('city'),
                    controller: cityController,
                    createWidgetList: () {
                      return city.map((v) {
                        return new Align(
                          child: new Text(
                            v['name'],
                            textScaleFactor: 0.8,
                          ),
                          alignment: Alignment.centerLeft,
                        );
                      }).toList();
                    },
                    changed: (index) {
                      setState(() {
                        cityIndex = index;
                        areaIndex = 0;
                        areaController.jumpToItem(0);
                        area =
                        widget.data[provinceIndex]['cities'][cityIndex]['districts'];
                      });
                    },
                  ),
                  new _MyAddressPicker(
                    key: Key('area'),
                    controller: areaController,
                    createWidgetList: () {
                      return area.map((v) {
                        return new Align(
                          child: new Text(
                            v['name'],
                            textScaleFactor: 0.8,
                          ),
                          alignment: Alignment.centerLeft,
                        );
                      }).toList();
                    },
                    changed: (index) {
                      setState(() {
                        areaIndex = index;
                      });
                    },
                  ),
                ],
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          return new ClipRect(
            child: new CustomSingleChildLayout(
              delegate: new _BottomPickerLayout(widget.route.animation.value),
              child: new GestureDetector(
                child: new Material(
                  color: Colors.transparent,
                  child: new Container(
                    width: double.infinity,
                    height: 260.0,
                    child: _bottomView(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MyAddressPicker extends StatefulWidget {
  final CreateWidgetList createWidgetList;
  final Key key;
  final FixedExtentScrollController controller;
  final ValueChanged<int> changed;

  _MyAddressPicker(
      {this.createWidgetList, this.key, this.controller, this.changed});

  @override
  State createState() {
    return new _MyAddressPickerState();
  }
}

class _MyAddressPickerState extends State<_MyAddressPicker> {
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: new Container(
        padding: const EdgeInsets.all(6.0),
        alignment: Alignment.center,
        height: 220.0,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          scrollController: widget.controller,
          key: widget.key,
          itemExtent: 30.0,
          onSelectedItemChanged: (index) {
            if (widget.changed != null) {
              widget.changed(index);
            }
          },
          children: widget
              .createWidgetList()
              .length > 0
              ? widget.createWidgetList()
              : [new Text('')],
        ),
      ),
      flex: 1,
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {this.itemCount, this.showTitleActions});

  final double progress;
  final int itemCount;
  final bool showTitleActions;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = 300.0;

    return new BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
