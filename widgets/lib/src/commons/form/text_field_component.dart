import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldComponent extends StatefulWidget {
  final Text leadingText;
  bool isRequired;
  String prefix;
  final String hintText;
  final Text helperText;
  double leadingWidth;
  TextEditingController controller;
  //必传
  final FocusNode focusNode;
  final TextInputType inputType;
  final Widget trailing;
  ValueChanged<String> onChanged;
  VoidCallback onEditingComplete;
  final bool autofocus;
  EdgeInsets padding;
  EdgeInsets dividerPadding;
  bool enabled;
  TextInputAction textInputAction;
  TextAlign textAlign;
  bool hideDivider;
  TextStyle style;
  List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final int maxLength;
  bool isInputBorder;
  bool isSteppedPrice;
  Color dividerColor;

//  final FormFieldValidator<String> _validator;

  TextFieldComponent({
    this.leadingText,
    this.isRequired = false,
    this.prefix,
    this.hintText,
    this.helperText,
    this.leadingWidth = 85,
    this.controller,
    @required this.focusNode,
    this.inputType,
    this.trailing,
    this.onChanged,
    this.onEditingComplete,
    this.autofocus = false,
    this.padding,
    this.dividerPadding,
    this.enabled,
    this.textInputAction,
    this.textAlign = TextAlign.right,
    this.hideDivider = false,
    this.style,
    this.inputFormatters,
    this.maxLength,
    this.maxLines,
    this.isInputBorder = false,
    this.isSteppedPrice = false,
    this.dividerColor,
  });

  TextFieldComponentState createState() => TextFieldComponentState();
}

class TextFieldComponentState extends State<TextFieldComponent> {

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  String formatNum(double num,int postion){
    if((num.toString().length-num.toString().lastIndexOf(".")-1)<postion){
      //小数点后有几位小数
      return num.toStringAsFixed(postion).substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    }else{
      return num.toString().substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    }
  }

  @override
  void initState() {

    if(widget.prefix != null && widget.controller.text != ''){
      if(!widget.controller.text.startsWith(widget.prefix)){
        widget.controller.text = widget.prefix + widget.controller.text;
      }
    }

    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        setState(() {
//          widget.dividerColor == null? widget.dividerColor = Color.fromRGBO(255,214,12, 1):widget.dividerColor = widget.dividerColor;
          if(widget.prefix != null){
//            if(widget.prefix == '￥'){
//              widget.controller.text = formatNum(double.parse(widget.controller.text), 2);
//            }
            widget.controller.text = widget.controller.text.replaceFirst(widget.prefix, '');
          }
        });
      } else {
        setState(() {
//          widget.dividerColor = Color(Constants.DIVIDER_COLOR);
          if(widget.prefix != null && widget.controller.text != ''){
            widget.controller.text = widget.prefix + widget.controller.text;
          }
        });
      }
    });

    if (widget.leadingText == null || widget.leadingText == '') {
      widget.leadingWidth = 0.0;
    } else if (widget.leadingWidth != null) {
      widget.leadingWidth = widget.leadingWidth;
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    if(widget.textAlign == TextAlign.right){
      widget.controller.value = TextEditingValue(
        // 设置内容
        text: widget.controller.text,
        // 保持光标在最后
        selection: TextSelection.fromPosition(
          TextPosition(
            affinity: TextAffinity.upstream,
            offset: widget.controller.text.length,
          ),
        ),
      );
//    }

    return Column(
      children: <Widget>[
        Container(
          padding: widget.padding ??
              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: <Widget>[
              Offstage(
                offstage: widget.leadingText == null,
                child: Container(
                  width: widget.leadingWidth,
                  child: Wrap(
                    children: <Widget>[
                      widget.leadingText ?? Text(''),
                      widget.isRequired ? Text(' *',style: TextStyle(fontSize: widget.leadingText.style?.fontSize ?? 16,color: Colors.red,)) : Text(''),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  style: widget.style ?? TextStyle(color: Colors.grey,fontSize: widget.leadingText?.style == null ? 16 : widget.leadingText.style.fontSize,),
                  controller: widget.controller,
                  keyboardType: widget.inputType ?? TextInputType.text,
                  decoration: InputDecoration(
                    border: widget.isInputBorder?UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey,width: 0.5)):InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: Colors.grey,),
                    contentPadding: EdgeInsets.only()
//                      ,prefixText: '已付定金：',prefixStyle: TextStyle(color: Colors.black87,fontSize: 16)
                  ),
                  autofocus: widget.autofocus,
                  focusNode: widget.focusNode,
                  onChanged: widget.onChanged,
                  enabled: widget.enabled,
                  onEditingComplete: widget.onEditingComplete,
                  textInputAction: widget.textInputAction,
                  textAlign: widget.textAlign,
                  inputFormatters: widget.inputFormatters,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                ),
              ),
              Offstage(
                offstage: widget.trailing == null,
                child: widget.trailing,
              )
            ],
          ),
        ),
        Offstage(
          offstage: widget.hideDivider,
          child: Padding(
            padding: widget.dividerPadding ?? EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(
                  height: 0,
                  color: widget.dividerColor,
                ),
                Offstage(
                  offstage: widget.helperText == null,
                  child: widget.helperText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
