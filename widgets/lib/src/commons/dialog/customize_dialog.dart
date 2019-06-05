import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';


//确认按钮点击动作
typedef void ConfirmAction();
//取消按钮点击动作
typedef void CancelAction();
//跳过的动作
typedef void JumpAction();


class CustomizeDialog extends StatefulWidget {
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
  //输入框Controller 3
  TextEditingController inputController3;
  //只显示用
  FocusNode focusNode;
  //输入框焦点1
  FocusNode focusNode1;
  //输入框焦点2
  FocusNode focusNode2;
  //输入框焦点3
  FocusNode focusNode3;
  //输入类型1
  TextInputType inputType1;
  //输入类型2
  TextInputType inputType2;
  //跳过的动作
  JumpAction jumpAction;
  //预计完成时间1
  DateTime estimatedDate1;
  //预计完成时间2
  DateTime estimatedDate2;
  //预计完成时间3
  DateTime estimatedDate3;
  //预计完成时间4
  DateTime estimatedDate4;
  //预计完成时间5
  DateTime estimatedDate5;
  //生产订单
  PurchaseOrderModel orderModel;
  //当前节点序号
  int currentNode;


  CustomizeDialog({
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
    this.inputController3,
    this.focusNode1,
    this.focusNode2,
    this.focusNode3,
    this.inputType1,
    this.inputType2,
    this.inputController,
    this.focusNode,
    this.jumpAction,
    this.estimatedDate1,
    this.estimatedDate2,
    this.estimatedDate3,
    this.estimatedDate4,
    this.estimatedDate5,
    this.orderModel,
    this.currentNode,
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

  //弹框输入预计完成时间
  ESTIMATED_DATE

}

class _CustomizeDialogPageState extends State<CustomizeDialog> {

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
      return buildManyInputsBalanceDialog(context);
    }else if(widget.dialogType == DialogType.ESTIMATED_DATE){
      return WillPopScope(
        child: buildEstimatedDateDialog(context),
        onWillPop: (){
          if(widget.estimatedDate1 != null && widget.estimatedDate2 != null
              && widget.estimatedDate3 != null && widget.estimatedDate4 != null
              && widget.estimatedDate5 != null){
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          }
        },
      );
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
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 13),
                              child: Text(
                                '${widget.title == null || widget.title == ''
                                    ? ''
                                    : widget.title}',
                                style: TextStyle(
                                      fontSize: 18,
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
                                    if(widget.inputController1.text == ''){
                                      widget.inputController1.text = '￥0';
                                    }
                                    if(widget.inputController2.text == ''){
                                      widget.inputController2.text = '￥0';
                                    }
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

  //尾款
  Widget buildManyInputsBalanceDialog(BuildContext context){
    return GestureDetector(
      onTap: widget.outsideDismiss ? _dismissDialog : null,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: 300.0,
            height: 350.0,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 0, 5),
                                child: Icon(
                                  Icons.edit,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                                child: Text(
                                  '无需付款直接跳过 >>',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                            ),
                            onTap: widget.jumpAction,
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
                                autofocus: false,
                                inputType: TextInputType.number,
                                hideDivider: true,
                                enabled: false,
                                prefix: '￥',
                                leadingText: Text('已付定金：',style: TextStyle(fontSize: 16),),
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
                                enabled: false,
                                prefix: '￥',
                                leadingText: Text('应付尾款：',style: TextStyle(fontSize: 16),),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextFieldComponent(
                                textAlign: TextAlign.left,
                                focusNode: widget.focusNode3,
                                controller: widget.inputController3,
                                autofocus: true,
                                inputType: TextInputType.number,
                                hintText: '请输入尾款金额',
                                hideDivider: true,
                                isInputBorder: true,
                                prefix: '￥',
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
                                    if(widget.inputController3.text == ''){
                                      widget.inputController1.text = '￥0';
                                    }
                                    Navigator.of(context).pop(widget.inputController3.text);
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

  Widget buildEstimatedDateDialog(BuildContext context){
    return GestureDetector(
      onTap: null,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: 300.0,
            height: 400.0,
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 0, 5),
                                child: Icon(
                                  Icons.edit,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Center(
                                child: Text(
                                  '预计排产日期',
                                  style: TextStyle(
                                    fontSize: 18
                                  ),
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
                            GestureDetector(
                              onTap: (){
                                if(widget.currentNode <= 0) {
                                  _showDatePicker(widget.estimatedDate1, 0);
                                }
                              },
                              child: Row(
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                        text: '',
                                        style: TextStyle(
                                            color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '备料',
                                            style: TextStyle(
                                                color: Colors.black
                                            ),
                                          ),
                                          TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: Colors.red,
                                              )
                                          ),
                                        ]
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 35,
                                      margin: const EdgeInsets.all(10),
                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300], width: 0.5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${widget.estimatedDate1 == null ? '点击选取时间':DateFormatUtil.formatYMD(widget.estimatedDate1)}',
                                          style: TextStyle(
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                if (widget.currentNode <= 1) {
                                  _showDatePicker(widget.estimatedDate2, 1);
                                }
                              },
                              child: Row(
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                        text: '',
                                        style: TextStyle(
                                            color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '裁剪',
                                            style: TextStyle(
                                                color: Colors.black
                                            ),
                                          ),
                                          TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: Colors.red,
                                              )
                                          ),
                                        ]
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 35,
                                      margin: const EdgeInsets.all(10),
                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300], width: 0.5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${widget.estimatedDate2 == null ? '点击选取时间':DateFormatUtil.formatYMD(widget.estimatedDate2)}',
                                          style: TextStyle(
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                if (widget.currentNode <= 2) {
                                  _showDatePicker(widget.estimatedDate3, 2);
                                }
                              },
                              child: Row(
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                        text: '',
                                        style: TextStyle(
                                            color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '车缝',
                                            style: TextStyle(
                                                color: Colors.black
                                            ),
                                          ),
                                          TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: Colors.red,
                                              )
                                          ),
                                        ]
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 35,
                                      margin: const EdgeInsets.all(10),
                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300], width: 0.5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${widget.estimatedDate3 == null ? '点击选取时间':DateFormatUtil.formatYMD(widget.estimatedDate3)}',
                                          style: TextStyle(
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                if (widget.currentNode <= 3) {
                                  _showDatePicker(widget.estimatedDate4, 3);
                                }
                              },
                              child: Row(
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                        text: '',
                                        style: TextStyle(
                                            color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '后整',
                                            style: TextStyle(
                                                color: Colors.black
                                            ),
                                          ),
                                          TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: Colors.red,
                                              )
                                          ),
                                        ]
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 35,
                                      margin: const EdgeInsets.all(10),
                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300], width: 0.5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${widget.estimatedDate4 == null ? '点击选取时间':DateFormatUtil.formatYMD(widget.estimatedDate4)}',
                                          style: TextStyle(
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                if (widget.currentNode <= 4) {
                                  _showDatePicker(widget.estimatedDate5, 4);
                                }
                              },
                              child: Row(
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                        text: '',
                                        style: TextStyle(
                                            color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: '验货',
                                            style: TextStyle(
                                                color: Colors.black
                                            ),
                                          ),
                                          TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: Colors.red,
                                              )
                                          ),
                                        ]
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 35,
                                      margin: const EdgeInsets.all(10),
                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300], width: 0.5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${widget.estimatedDate5 == null ? '点击选取时间':DateFormatUtil.formatYMD(widget.estimatedDate5)}',
                                          style: TextStyle(
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          '提交所有生产节点排期，才可进行生产报工',
                          style: TextStyle(
                            color: Colors.red,
                          ),
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
                                      '取消',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    onPressed: (){

//                                        Navigator.of(context).popUntil(ModalRoute.withName('/'));
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
                                    '提交',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  onPressed: (){
                                    onSubmitDate();
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

  //打开日期选择器
  void _showDatePicker(DateTime date,int index) {
    _selectDate(context,date,index);
  }
  //生成日期选择器
  Future<Null> _selectDate(BuildContext context,DateTime date,int index) async {
    DateTime nowTime = DateTime.now();
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: nowTime,
        firstDate: nowTime,
        lastDate: DateTime(2999)
    );

    setState(() {
      if (index == 0) {
        widget.estimatedDate1 = _picked;
      } else if (index == 1) {
        widget.estimatedDate2 = _picked;
      } else if (index == 2) {
        widget.estimatedDate3 = _picked;
      } else if (index == 3) {
        widget.estimatedDate4 = _picked;
      } else if (index == 4) {
        widget.estimatedDate5 = _picked;
      }

    });
  }

  onSubmitDate() {
    if (widget.estimatedDate1 != null && widget.estimatedDate2 != null
        && widget.estimatedDate3 != null && widget.estimatedDate4 != null
        && widget.estimatedDate5 != null) {

      if(widget.orderModel != null){
        print(widget.estimatedDate1);
        ProductionProgressModel model1 = widget.orderModel.progresses[0];
        model1.estimatedDate = widget.estimatedDate1;
        model1.updateOnly = true;

        ProductionProgressModel model2 = widget.orderModel.progresses[1];
        model2.estimatedDate = widget.estimatedDate2;
        model2.updateOnly = true;

        ProductionProgressModel model3 = widget.orderModel.progresses[2];
        model3.estimatedDate = widget.estimatedDate3;
        model3.updateOnly = true;

        ProductionProgressModel model4 = widget.orderModel.progresses[3];
        model4.estimatedDate = widget.estimatedDate4;
        model4.updateOnly = true;

        ProductionProgressModel model5 = widget.orderModel.progresses[4];
        model5.estimatedDate = widget.estimatedDate5;
        model5.updateOnly = true;

        for(int i=0;i<widget.orderModel.progresses.length;i++){
          if(widget.orderModel.progresses[i].phase == ProductionProgressPhase.MATERIAL_PREPARATION){
            model1.estimatedDate = widget.orderModel.progresses[i].estimatedDate;
          }else if(widget.orderModel.progresses[i].phase == ProductionProgressPhase.CUTTING){
            model2.estimatedDate = widget.orderModel.progresses[i].estimatedDate;
          }else if(widget.orderModel.progresses[i].phase == ProductionProgressPhase.STITCHING){
            model3.estimatedDate = widget.orderModel.progresses[i].estimatedDate;
          }else if(widget.orderModel.progresses[i].phase == ProductionProgressPhase.AFTER_FINISHING){
            model4.estimatedDate = widget.orderModel.progresses[i].estimatedDate;
          }else if(widget.orderModel.progresses[i].phase == ProductionProgressPhase.INSPECTION){
            model5.estimatedDate = widget.orderModel.progresses[i].estimatedDate;
          }
        }

        List<ProductionProgressModel> modelList = List();
        modelList.add(model1);
        modelList.add(model2);
        modelList.add(model3);
        modelList.add(model4);
        modelList.add(model5);

        try{
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return RequestDataLoading(
                  requestCallBack: PurchaseOrderRepository().progressEstimatedDateUploads(widget.orderModel.code,model5.id.toString(),modelList),
                  outsideDismiss: false,
                  loadingText: '保存中。。。',
                  entrance: '',
                );
              }
          );
        }catch(e){
          print(e);
        }
        Navigator.of(context).pop(widget.orderModel);
      }
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
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
          );
        }
    );
  }
}