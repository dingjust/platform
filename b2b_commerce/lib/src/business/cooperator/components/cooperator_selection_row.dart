import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class CooperatorSelectionRow extends StatelessWidget {
  final Widget titleText;

  final String hintText;

  final String buttonText;

  final TextEditingController controller;

  final bool enabled;

  final Widget trailing;

  final FocusNode focusNode;

  final ValueChanged onChanged;

  final VoidCallback onPressed;

  const CooperatorSelectionRow(
      {Key key,
      this.controller,
      this.enabled = false,
      this.trailing,
      this.focusNode,
      this.onChanged,
      this.onPressed,
      this.titleText,
      this.hintText = '填写',
      this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 2, 0, 0),
      child: Column(
        children: [
          Row(children: [titleText]),
          Row(
            children: [
              Expanded(
                child: TextFieldBorderComponent(
                  padding: EdgeInsets.all(0),
                  hideDivider: true,
                  isRequired: true,
                  textAlign: TextAlign.left,
                  hintText: hintText,
                  controller: controller,
                  enabled: enabled,
                  trailing: trailing,
                  focusNode: focusNode,
                  onChanged: (v) {
                    onChanged(v);
                  },
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(left: 10),
                child: FlatButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  onPressed: onPressed,
                  child: Text(
                    buttonText,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
