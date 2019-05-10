import 'package:b2b_commerce/src/business/orders/production_progresses.dart';
import 'package:b2b_commerce/src/business/orders/proofing_order_detail.dart';
import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:b2b_commerce/src/business/orders/quote_order_detail.dart';
import 'package:b2b_commerce/src/business/proofing_orders.dart';
import 'package:b2b_commerce/src/business/purchase_orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';


//确认按钮点击动作
typedef void ConfirmAction();
//取消按钮点击动作
typedef void CancelAction();


class CustomizeDialogPage extends StatefulWidget {
  //是否允许点击空白处关闭dialog
  bool outsideDismiss;
  //回调结果
  bool callbackResult;
  //内容的WidgetList，List越大dialog的高度要越大
  List<Widget> contentWidgetList;
  //标题
  String title;
  //整个dialog的高度
  double dialogHeight;
  //整个dialog的宽度
  double dialogWidth;
  //标题样式
  TextStyle titleStyle;
  //内容样式（输入框方式不适用）
  TextStyle contentStyle;
  //操作成功时提示
  String successTips;
  //操作失败时提示
  String failTips;
  //是否需要确认按钮
  bool isNeedConfirmButton;
  //是否需要取消按钮
  bool isNeedCancelButton;
  //确认按钮的文本
  String confirmButtonText;
  //取消按钮的文本
  String cancelButtonText;
  //确认按钮点击动作
  ConfirmAction confirmAction;
  //取消按钮点击动作
  CancelAction cancelAction;
  //弹窗类型样式
  DialogType dialogType;
  //内容文本1
  String contentText1;
  //内容文本2
  String contentText2;
  //内容文本1字体样式
  TextStyle contentTextStyle1;
  //内容文本2字体样式
  TextStyle contentTextStyle2;
  //只显示用
  TextEditingController inputController;
  //输入框Controller 1
  TextEditingController inputController1;
  //输入框Controller 2
  TextEditingController inputController2;
  //只显示用
  FocusNode focusNode;
  //输入框焦点1
  FocusNode focusNode1;
  //输入框焦点2
  FocusNode focusNode2;
  //输入类型1
  TextInputType inputType1;
  //输入类型2
  TextInputType inputType2;

  CustomizeDialogPage({
    Key key,
    this.outsideDismiss = true,
    this.confirmAction,
    this.callbackResult=false,
    this.contentWidgetList,
    this.title,
    this.contentStyle,
    this.dialogHeight,
    this.dialogWidth,
    this.failTips,
    this.successTips,
    this.titleStyle,
    this.cancelAction,
    this.cancelButtonText,
    this.confirmButtonText,
    this.isNeedCancelButton=false,
    this.isNeedConfirmButton=false,
    @required this.dialogType,
    this.contentText1,
    this.contentTextStyle2,
    this.contentTextStyle1,
    this.contentText2,
    this.inputController1,
    this.inputController2,
    this.focusNode1,
    this.focusNode2,
    this.inputType1,
    this.inputType2,
    this.inputController,
    this.focusNode,
    })
      : super(key: key);

  @override
  _CustomizeDialogPageState createState() => _CustomizeDialogPageState();
}

enum DialogType {
  /// 带确认按钮的弹窗
  CONFIRM_DIALOG,

  /// 带确认取消按钮结果弹窗
  RESULT_DIALOG,

  // 输入框弹窗
  INPUTS_DIALOG,

  //定金/单价修改弹窗
  PRICE_INPUT_DIALOG,

  //尾款修改弹窗
  BALANCE_INPUT_DIALOG,

}

class _CustomizeDialogPageState extends State<CustomizeDialogPage> {

  _dismissDialog() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.dialogType == DialogType.CONFIRM_DIALOG) {
      return buildConfirmDialog(context);
    }else if(widget.dialogType == DialogType.RESULT_DIALOG) {
      return buildResultDialog(context);
    }else if(widget.dialogType == DialogType.INPUTS_DIALOG){
      return buildInputsDialog(context);
    }else if(widget.dialogType == DialogType.PRICE_INPUT_DIALOG){
      return buildManyInputsDialog(context);
    }else if(widget.dialogType == DialogType.BALANCE_INPUT_DIALOG){
      return buildManyInputsDialog(context);
    }
  }


  Widget buildConfirmDialog(BuildContext context){
    return GestureDetector(
      onTap: widget.outsideDismiss ? _dismissDialog : null,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: widget.dialogWidth == null || widget.dialogWidth <300?300.0:widget.dialogWidth,
            height: widget.dialogHeight == null || widget.dialogHeight <150?150.0:widget.dialogHeight,
            child: Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5),
                      height: 40,
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: Icon(
                              Icons.error,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${widget.title == null || widget.title == ''
                                    ? ''
                                    : widget.title}',
                                style: TextStyle(

                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        padding: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                '${widget.contentText1 == null || widget.contentText1 == ''? '':widget.contentText1}',
                                style: widget.contentTextStyle1 != null ?
                                widget.contentTextStyle1:null,
                              ),
                            ),
                            widget.contentText2 != null && widget.contentText2 != ''?
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                '${widget.contentText2}',
                                style: widget.contentTextStyle2 != null  ?
                                widget.contentTextStyle2:null,
                              ),
                            ):
                                Container()
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: widget.isNeedCancelButton?MainAxisAlignment.center:MainAxisAlignment.start,
                        children: <Widget>[
                          widget.isNeedCancelButton?Center(
                            child: Container(
                                child: FlatButton(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 55),
                                    child: Text(
                                      '${widget.cancelButtonText==null||widget.cancelButtonText==''?'取消':widget.cancelButtonText}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(15))),
                                    onPressed: widget.cancelAction
                                )
                            ),
                          ):Container(),
                          widget.isNeedConfirmButton?
                          Center(
                            child: Container(
                              child: widget.isNeedCancelButton? FlatButton(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 55),
                                  child: Text(
                                    '${widget.confirmButtonText==null||widget.confirmButtonText==''?'确定':widget.confirmButtonText}',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  onPressed: widget.confirmAction
                              ):FlatButton(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 133),
                                  child: Text(
                                    '${widget.confirmButtonText==null||widget.confirmButtonText==''?'确定':widget.confirmButtonText}',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))),
                                  onPressed:  widget.confirmAction,
                              ),
                              decoration: BoxDecoration(
                                  border: Border(left: BorderSide(color: Colors.grey,width: 0.5))
                              ),
                            ),
                          ):Container(),
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey,width: 0.5))
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildResultDialog(BuildContext context){
    return GestureDetector(
      onTap: null,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: 300.0,
            height: 150.0,
            child: Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5),
                      height: 10,
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            child: widget.callbackResult
                                ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 30,
                            ) : Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${widget.title == null || widget.title == ''
                                    ? ''
                                    : widget.title}',
                                style: widget.titleStyle == null ?
                                null : widget.titleStyle,
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      padding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      height: 80,
                      child: Center(
                        child: Text(
                          widget.callbackResult
                              ? '${widget.successTips == null ||
                              widget.successTips == '' ? '成功' : widget
                              .successTips}'
                              : '${widget.failTips == null ||
                              widget.failTips == '' ? '失败' : widget.failTips}',
                          style: widget.contentStyle == null ?
                          null : widget.contentStyle,
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Container(
                          child: FlatButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 100),
                              child: Text(
                                '${widget.confirmButtonText==null||widget.confirmButtonText==''?'确定':widget.confirmButtonText}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15))),
                              onPressed: widget.confirmAction == null ? () {
                                Navigator.of(context).pop();
                              } : widget.confirmAction),
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey,width: 0.5))
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputsDialog(BuildContext context){
    return GestureDetector(
      onTap: widget.outsideDismiss ? _dismissDialog : null,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: 300.0,
            height: 180.0,
            child: Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(
                          horizontal: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 0, 5),
                            child: Icon(
                              Icons.edit,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${widget.title == null || widget.title == ''
                                    ? ''
                                    : widget.title}',
                                style: TextStyle(

                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 5, vertical: 0),
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: 5),
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: TextFieldComponent(
                                textAlign: TextAlign.left,
                                focusNode: widget.focusNode1,
                                controller: widget.inputController1,
                                autofocus: true,
                                inputType: widget.inputType1,
                                hideDivider: true,
                                maxLength: 120,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                                child: FlatButton(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 55),
                                    child: Text(
                                      '${widget.cancelButtonText==null||widget.cancelButtonText==''?'取消':widget.cancelButtonText}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    onPressed: widget.cancelAction
                                )
                            ),
                          ),
                          Center(
                            child: Container(
                              child: FlatButton(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 55),
                                  child: Text(
                                    '${widget.confirmButtonText==null||widget.confirmButtonText==''?'确定':widget.confirmButtonText}',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  onPressed: (){
                                    Navigator.of(context).pop(widget.inputController1.text);
                                  }
                              ),
                              decoration: BoxDecoration(
                                  border: Border(left: BorderSide(
                                      color: Colors.grey, width: 0.5))
                              ),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 0.5))
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildManyInputsDialog(BuildContext context){
    return GestureDetector(
      onTap: widget.outsideDismiss ? _dismissDialog : null,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: 300.0,
            height: 280.0,
            child: Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(
                          horizontal: 5),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 0, 5),
                            child: Icon(
                              Icons.edit,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${widget.title == null || widget.title == ''
                                    ? ''
                                    : widget.title}',
                                style: TextStyle(

                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 5, vertical: 0),
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: 5),
//                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextFieldComponent(
                                textAlign: TextAlign.left,
                                focusNode: widget.focusNode,
                                controller: widget.inputController,
                                autofocus: false,
                                inputType: widget.inputType1,
                                hideDivider: true,
                                enabled: false,
                                prefix: '￥',
                                leadingText: Text('订单总额：',style: TextStyle(fontSize: 16),),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextFieldComponent(
                                textAlign: TextAlign.left,
                                focusNode: widget.focusNode1,
                                controller: widget.inputController1,
                                autofocus: true,
                                inputType: TextInputType.number,
                                hideDivider: true,
                                isInputBorder: true,
                                prefix: '￥',
                                leadingText: Text('        定金：',style: TextStyle(fontSize: 16),),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextFieldComponent(
                                textAlign: TextAlign.left,
                                focusNode: widget.focusNode2,
                                controller: widget.inputController2,
                                autofocus: false,
                                inputType: TextInputType.number,
                                hideDivider: true,
                                isInputBorder: true,
                                prefix: '￥',
                                leadingText: Text('        单价：',style: TextStyle(fontSize: 16),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                                child: FlatButton(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 55),
                                    child: Text(
                                      '${widget.cancelButtonText==null||widget.cancelButtonText==''?'取消':widget.cancelButtonText}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    }
                                )
                            ),
                          ),
                          Center(
                            child: Container(
                              child: FlatButton(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 55),
                                  child: Text(
                                    '${widget.confirmButtonText==null||widget.confirmButtonText==''?'确定':widget.confirmButtonText}',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  onPressed: (){
                                    Navigator.of(context).pop(widget.inputController1.text+','+widget.inputController2.text);
                                  }
                              ),
                              decoration: BoxDecoration(
                                  border: Border(left: BorderSide(
                                      color: Colors.grey, width: 0.5))
                              ),
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.grey, width: 0.5))
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  doSomething(){
    print('按按钮了！');
    if (widget.confirmAction != null) {
      widget.confirmAction;
      print('11111');
//          .then((value) {
//        Navigator.of(context).pop(value);
//      });
    }else{
      Navigator.of(context).pop();
    }
  }


}

class DialogAttribute {
  //是否允许点击空白处关闭dialog
  bool outsideDismiss;
  //回调结果
  bool callbackResult;
  //内容的WidgetList，List越大dialog的高度要越大
  List<Widget> contentWidgetList;
  //标题
  String title;
  //整个dialog的高度
  double dialogHeight;
  //整个dialog的宽度
  double dialogWidth;
  //标题样式
  TextStyle titleStyle;
  //内容样式（输入框方式不适用）
  TextStyle contentStyle;
  //操作成功时提示
  String successTips;
  //操作失败时提示
  String failTips;
  //是否需要确认按钮
  bool isNeedConfirmButton;
  //是否需要取消按钮
  bool isNeedCancelButton;
  //确认按钮的文本
  String confirmButtonText;
  //取消按钮的文本
  String cancelButtonText;
  //确认按钮点击动作
  ConfirmAction confirmAction;
  //取消按钮点击动作
  CancelAction cancelAction;
  //弹窗类型样式
  DialogType dialogType;

  DialogAttribute({
    Key key,
    this.outsideDismiss = true,
    this.confirmAction,
    this.callbackResult=false,
    this.contentWidgetList,
    this.title,
    this.contentStyle,
    this.dialogHeight,
    this.dialogWidth,
    this.failTips,
    this.successTips,
    this.titleStyle,
    this.cancelAction,
    this.cancelButtonText,
    this.confirmButtonText,
    this.isNeedCancelButton=false,
    this.isNeedConfirmButton=false,
    @required this.dialogType,
  });
}


class DialogUtil {
  static Future dialog(BuildContext context,DialogAttribute attribute,) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialogPage(
            dialogType: DialogType.CONFIRM_DIALOG,
          );
        }
    );
  }
}