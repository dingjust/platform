import 'package:flutter/material.dart';

class TextFieldComponent extends StatefulWidget {
  final String leadingText;
  final String hintText;
  double leadingWidth;
  TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType inputType;

//  final FormFieldValidator<String> _validator;

  TextFieldComponent({
    @required this.leadingText,
    this.hintText,
    this.leadingWidth,
    this.controller,
    @required this.focusNode,
    this.inputType,
  });

  TextFieldComponentState createState() => TextFieldComponentState();
}

class TextFieldComponentState extends State<TextFieldComponent> {
  Color _dividerColor = Colors.grey[400];

  @override
  void initState() {
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        setState(() {
          _dividerColor = Colors.orange;
        });
      }else{
        setState(() {
          _dividerColor = Colors.grey[400];
        });
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        ListTile(
          leading: Container(
            width: widget.leadingWidth ?? 80,
            child: Text(
              widget.leadingText,
              style: TextStyle(fontSize: 16),
            ),
          ),
          title: TextFormField(
            controller: widget.controller,
            keyboardType: widget.inputType ?? TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
            focusNode: widget.focusNode,
            /*validator: (v) {
              return v.trim().length > 0 ? null : widget.leadingText + '不能为空';
            },*/
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            height: 0,
            color: _dividerColor,
          ),
        ),
      ],
    );
  }
}
