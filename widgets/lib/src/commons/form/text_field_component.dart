import 'package:flutter/material.dart';

class TextFieldComponent extends StatefulWidget {
  final String leadingText;
  final String hintText;
  double leadingWidth;
  TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType inputType;
  final Widget trailing;
  Function onChanged;

//  final FormFieldValidator<String> _validator;

  TextFieldComponent({
    this.leadingText,
    this.hintText,
    this.leadingWidth,
    this.controller,
    @required this.focusNode,
    this.inputType,
    this.trailing,
    this.onChanged,
  });

  TextFieldComponentState createState() => TextFieldComponentState();
}

class TextFieldComponentState extends State<TextFieldComponent> {
  Color _dividerColor = Colors.grey[400];
  double _width = 75;

  @override
  void initState() {
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        setState(() {
          _dividerColor = Colors.orange;
        });
      } else {
        setState(() {
          _dividerColor = Colors.grey[400];
        });
      }
    });

    if(widget.leadingText == null || widget.leadingText == ''){
      _width = 0.0;
    }else if(widget.leadingWidth != null){
      _width = widget.leadingWidth;
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
    return Column(
      children: <Widget>[
        widget.trailing == null
            ? ListTile(
                leading: Container(
                  width: _width,
                  child: Text(
                    widget.leadingText ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                title: TextField(
                  controller: widget.controller,
                  keyboardType: widget.inputType ?? TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: Colors.grey[400]),
//              suffixIcon: Icon(Icons.close),
                  ),
                  focusNode: widget.focusNode,
                  onChanged: widget.onChanged,
                )
              )
            : ListTile(
                leading: Container(
                  width: widget.leadingWidth ?? 80,
                  child: Text(
                    widget.leadingText,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                title: TextField(
                  controller: widget.controller,
                  keyboardType: widget.inputType ?? TextInputType.text,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: Colors.grey[400]),
//              suffixIcon: Icon(Icons.close),
                  ),
                  focusNode: widget.focusNode,
                ),
                trailing: widget.trailing ?? Text(''),
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
