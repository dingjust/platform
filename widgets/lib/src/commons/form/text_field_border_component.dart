import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldBorderComponent extends StatefulWidget {
  final Widget? leadingText;
  bool isRequired;
  String? prefix;
  final String? hintText;
  final Text? helperText;
  double leadingWidth;
  TextEditingController? controller;

  //必传
  final FocusNode focusNode;
  final TextInputType? inputType;
  final Widget? trailing;
  ValueChanged<String>? onChanged;
  VoidCallback? onEditingComplete;
  final bool autofocus;
  EdgeInsets? padding;
  bool? enabled;
  TextInputAction? textInputAction;
  TextAlign textAlign;
  bool hideDivider;
  TextStyle? style;
  List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? maxLength;
  bool isInputBorder;
  bool isSteppedPrice;
  bool isCursorEnd;

//  final FormFieldValidator<String> _validator;

  TextFieldBorderComponent({
    this.leadingText,
    this.isRequired = false,
    this.prefix,
    this.hintText,
    this.helperText,
    this.leadingWidth = 85,
    this.controller,
    required this.focusNode,
    this.inputType,
    this.trailing,
    this.onChanged,
    this.onEditingComplete,
    this.autofocus = false,
    this.padding,
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
    this.isCursorEnd = false,
  });

  _TextFieldBorderComponentState createState() => _TextFieldBorderComponentState();
}

class _TextFieldBorderComponentState extends State<TextFieldBorderComponent> {

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void initState() {
    if (widget.prefix != null && widget.controller!.text != '') {
      if (!widget.controller!.text.startsWith(widget.prefix!)) {
        widget.controller!.text = widget.prefix! + widget.controller!.text;
      }
    }

    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        setState(() {
          if (widget.prefix != null) {
            widget.controller!.text =
                widget.controller!.text.replaceFirst(widget.prefix!, '');
          }
        });
      } else {
        setState(() {
          if (widget.prefix != null && widget.controller!.text != '') {
            widget.controller!.text = widget.prefix! + widget.controller!.text;
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
    widget.controller!.value = TextEditingValue(
      // 设置内容
      text: widget.controller!.text,
      // 保持光标在最后
      selection: TextSelection.fromPosition(
        TextPosition(
          affinity: TextAffinity.upstream,
          offset: widget.controller!.text.length,
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
                      widget.isRequired ? Text(' *',style: TextStyle(fontSize: 16,color: Colors.red,)) : Text(''),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  style: widget.style ?? TextStyle(color: Colors.grey,fontSize: 16),
                  controller: widget.controller,
                  keyboardType: widget.inputType ?? TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffffd60c),width: 0.5)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 0.5,style: BorderStyle.none)),
                    fillColor: Colors.grey[50],
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: Colors.grey),
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
      ],
    );
  }
}
