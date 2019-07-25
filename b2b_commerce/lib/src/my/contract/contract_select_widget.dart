import 'dart:convert';

import 'package:b2b_commerce/src/my/contract/contract_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';

typedef void ChangeData(Map<String, dynamic> map);
typedef List<Widget> CreateWidgetList();

const contractTypes = <EnumModel>[
  EnumModel('1', '框架协议'),
  EnumModel('2', '附件合同'),
  EnumModel('3', '采购合同'),
  EnumModel('4', '意向合同'),
];

class ContractSelectWidget {
  Function cacel;

  ContractSelectWidget({this.cacel}){
    if(this.cacel == null) this.cacel = (){};
  }

  void showAddressPicker(BuildContext context, {
    ChangeData selectType,
    ChangeData selectTemplate,
  }) {
    rootBundle.loadString('data/province.json').then((v) {
      List data = json.decode(v);
      Navigator.push(
        context,
         _AddressPickerRoute(
          data: data,
          selectProvince: selectType,
          selectCity: selectTemplate,
          theme: Theme.of(context, shadowThemeOnly: true),
          barrierLabel:
          MaterialLocalizations
              .of(context)
              .modalBarrierDismissLabel,
          cacel:cacel,
           leftData: contractTypes,
           rightData: ContractData().getConList(),
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
  List leftData;
  List rightData;

  _AddressPickerRoute({
    this.theme,
    this.barrierLabel,
    this.data,
    this.selectProvince,
    this.selectCity,
    this.selectArea,
    this.cacel,
    this.leftData,
    this.rightData,
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
    Widget bottomSheet =  MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child:  _AddressPickerWidget(
        route: this,
        data: data,
        selectProvince: selectProvince,
        selectCity: selectCity,
        selectArea: selectArea,
        cacel:cacel,
        leftData: leftData,
        rightData: rightData,
      ),
    );
    if (theme != null) {
      bottomSheet =  Theme(data: theme, child: bottomSheet);
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
  List<EnumModel> leftData;
  List<Contract> rightData;

  _AddressPickerWidget({Key key,
    @required this.route,
    this.data,
    this.selectProvince,
    this.selectCity,
    this.selectArea,
    this.cacel,
    this.rightData,
    this.leftData,
  });

  @override
  State createState() {
    return  _AddressPickerState();
  }
}

class _AddressPickerState extends State<_AddressPickerWidget> {
  FixedExtentScrollController provinceController;
  FixedExtentScrollController cityController;
  int provinceIndex = 0,
      cityIndex = 0;
  List lData =  List();
  List rData =  List();

  String parent = '1';

  @override
  void initState() {
    super.initState();
    provinceController =  FixedExtentScrollController();
    cityController =  FixedExtentScrollController();
    setState(() {
      lData = widget.leftData;

      for (int i = 0; i < widget.rightData.length; i++) {
        if (parent == widget.rightData[i].parent) {
          rData.add(widget.rightData[i]);
        }
      }
    });
  }

  Widget _bottomView() {
    return WillPopScope(
      onWillPop: () {
//        Navigator.pop(context);
        return Future.value(false);
      },
      child:  Container(
          width: double.infinity,
          color: Colors.white,
          child:  Column(
            children: <Widget>[
               Expanded(
                child:  Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: FlatButton(
                          onPressed: widget.cacel,
                          child:  Text(
                            '取消',
                            style:  TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child:  Text(
                            '确定',
                            style:  TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 214, 12, 1),
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                    ],
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[200],width: 1))
                  ),
                ),
              ),
               Container(
                 child: Row(
                  children: <Widget>[
                     _MyAddressPicker(
                      key: Key('province'),
                      controller: provinceController,
                      createWidgetList: () {
                        return lData.map((v) {
                          return  Align(
                            child:  Text(
                              v.name,
                              textScaleFactor: 1.2,
                            ),
                            alignment: Alignment.center,
                          );
                        }).toList();
                      },
                      changed: (index) {
                        setState(() {
                          parent = lData[index].code;
                          print(parent);
                          rData.clear();
                          for (int i = 0; i < widget.rightData.length; i++) {
                            if (parent == widget.rightData[i].parent) {
                              rData.add(widget.rightData[i]);
                            }
                          }
                          cityController.jumpToItem(0);
                        });
                      },
                    ),
                     _MyAddressPicker(
                      key: Key('city'),
                      controller: cityController,
                      createWidgetList: () {
                        return rData.map((v) {
                          return  Align(
                            child:  Text(
                              v.name,
                              textScaleFactor: 1.2,
                            ),
                            alignment: Alignment.center,
                          );
                        }).toList();
                      },
                       changed: (index) {
                         setState(() {
                           Contract temp = rData[index];
                           print(temp.name);
                         });
                       },
                    ),
                  ],
              ),
               )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      child:  AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          return  ClipRect(
            child:  CustomSingleChildLayout(
              delegate:  _BottomPickerLayout(widget.route.animation.value),
              child:  GestureDetector(
                child:  Material(
                  color: Colors.transparent,
                  child:  Container(
                    width: double.infinity,
                    height: 400.0,
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
    return  _MyAddressPickerState();
  }
}

class _MyAddressPickerState extends State<_MyAddressPicker> {
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child:  Container(
        padding: const EdgeInsets.all(6.0),
        alignment: Alignment.center,
        height: 250.0,
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
              : [ Text('')],
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

    return  BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return  Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
