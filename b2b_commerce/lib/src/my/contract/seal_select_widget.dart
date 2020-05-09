import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:b2b_commerce/src/my/contract/webview_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

typedef void ChangeData(SealModel map);
typedef List<Widget> CreateWidgetList();

class SealSelectWidget {
  Function cacel;
  List<SealModel> rightData;
  String code;

  SealSelectWidget({this.cacel, this.rightData, this.code}) {
    if (this.cacel == null) this.cacel = () {};
  }

  void showPicker(BuildContext context, {
    ChangeData selectType,
    ChangeData selectTemplate,
  }) {
    Navigator.push(
      context,
      _sealPickerRoute(
        selectType: selectType,
        selectTemplate: selectTemplate,
        theme: Theme.of(context, shadowThemeOnly: true),
        barrierLabel:
        MaterialLocalizations
            .of(context)
            .modalBarrierDismissLabel,
        cacel: cacel,
        rightData: rightData,
        contractCode: code,
      ),
    );
  }
}

class _sealPickerRoute<T> extends PopupRoute<T> {
  final ThemeData theme;
  final String barrierLabel;
  final List data;
  final ChangeData selectType;
  final ChangeData selectTemplate;
  Function cacel;
  List rightData;
  String contractCode;

  _sealPickerRoute({
    this.theme,
    this.barrierLabel,
    this.data,
    this.selectType,
    this.selectTemplate,
    this.cacel,
    this.rightData,
    this.contractCode,
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
    Widget bottomSheet = MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: _sealPickerWidget(
        route: this,
        data: data,
        selectType: selectType,
        selectTemplate: selectTemplate,
        cacel: cacel,
        rightData: rightData,
        contractCode: contractCode,
      ),
    );
    if (theme != null) {
      bottomSheet = Theme(data: theme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _sealPickerWidget extends StatefulWidget {
  final _sealPickerRoute route;
  final List data;
  final ChangeData selectType;
  final ChangeData selectTemplate;
  Function cacel;
  List rightData;
  String contractCode;

  _sealPickerWidget({
    Key key,
    @required this.route,
    this.data,
    this.selectType,
    this.selectTemplate,
    this.cacel,
    this.rightData,
    this.contractCode,
  });

  @override
  State createState() {
    return _sealPickerState();
  }
}

class _sealPickerState extends State<_sealPickerWidget> {
  FixedExtentScrollController provinceController;
  FixedExtentScrollController cityController;
  SealModel sealModel;
  String type;
  String temp;
  int rIndex = 0;
  List rData = List();

  @override
  void initState() {
    super.initState();
    provinceController = FixedExtentScrollController();
    cityController = FixedExtentScrollController();
    rData = widget.rightData;
  }

  Widget _bottomView() {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: FlatButton(
                          onPressed: widget.cacel,
                          child: Text(
                            '取消',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: FlatButton(
                          onPressed: () {
                            sealModel = rData[rIndex];
                            widget.selectType(sealModel);
                            flowContract(widget.contractCode, sealModel);
                          },
                          child: Text(
                            '确定',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 214, 12, 1),
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ],
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                          BorderSide(color: Colors.grey[200], width: 1))),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    _MyAddressPicker(
                      key: Key('province'),
                      controller: provinceController,
                      createWidgetList: () {
                        return rData.map((v) {
                          return Align(
                            child: Text(
                              v.name != null && v.name != '' ? v.name : '',
//                              textScaleFactor: 1.2,
                            ),
                            alignment: Alignment.center,
                          );
                        }).toList();
                      },
                      changed: (index) {
                        setState(() {
                          rIndex = index;
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

  flowContract(String code, SealModel sealModel) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            ContractRepository().flowContract(code, sealModel.code),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((value) {
      Certification certification = value;
      if (certification != null) {
        if (certification.data != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebviewPage(url: certification.data)),
          );
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return CustomizeDialog(
                  dialogType: DialogType.RESULT_DIALOG,
                  failTips: certification.msg,
                  callbackResult: false,
                  confirmAction: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                );
              });
        }
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                failTips: '签署失败',
                callbackResult: false,
                confirmAction: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _BottomPickerLayout(widget.route.animation.value),
              child: GestureDetector(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    height: 200.0,
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

  _MyAddressPicker({this.createWidgetList, this.key, this.controller, this.changed});

  @override
  State createState() {
    return _MyAddressPickerState();
  }
}

class _MyAddressPickerState extends State<_MyAddressPicker> {
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6.0),
        alignment: Alignment.center,
        height: 100.0,
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
              : [Text('')],
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
    double maxHeight = 150.0;

    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
