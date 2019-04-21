import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class TextFieldWidget extends StatefulWidget {
  final bool isShowInputText;
  final String leadText;
  TextEditingController controller;
  String callbackValue;
  final TextInputType inputType;
  FocusNode focusNode;

  TextFieldWidget({
    this.isShowInputText:false,
    this.leadText,
    this.callbackValue,
    this.inputType,
    this.controller,
    this.focusNode,
  });

_TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> with WidgetsBindingObserver{
  String inputText;
  bool inputTextHide = false;
  bool autoInputTextFocus = false;

  @override
  void initState() {
//    widget.focusNode.addListener(() {
//      if(!widget.focusNode.hasFocus){
//        setState(() {
//          inputText = widget.controller.text;
//          inputTextHide = false;
//          autoInputTextFocus = false;
//        });
//      }
//    });
    super.initState();
    widget.focusNode.addListener(_focusNodeListener);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  Future<Null> _focusNodeListener() async {  // 用async的方式实现这个listener
    if (widget.focusNode.hasFocus){
      print('TextField got the focus');
    } else {
      setState(() {
        inputText = widget.controller.text;
        inputTextHide = false;
        autoInputTextFocus = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: inputTextHide?
      _buildInputTextField(context):
      _buildListTile(context),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return GestureDetector(
        child: Container(
          color: Colors.white,
          child: ListTile(
            leading: Text(
              widget.leadText,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            trailing: Text(
              widget.controller.text == null || widget.controller.text == ''
                  ? '填写'
                  : widget.controller.text,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          setState(() {
            FocusScope.of(context).autofocus(FocusNode());
            inputTextHide = true;
            autoInputTextFocus = true;
            widget.focusNode.hasFocus;
          });
        }
    );
  }

  Widget _buildInputTextField(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFieldComponent(
        padding: EdgeInsets.symmetric(vertical: 10),
        dividerPadding: EdgeInsets.only(),
        focusNode: widget.focusNode,
        autofocus: true,
        inputType: TextInputType.number,
        textAlign: TextAlign.right,
        leadingText: '${widget.leadText}',
        hintText: '填写',
        controller: widget.controller,
        onEditingComplete: () {
          setState(() {
            inputText = widget.controller.text;
            inputTextHide = false;
            autoInputTextFocus = false;
          });
        },
      ),
    );
  }

}