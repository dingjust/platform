import 'package:flutter/material.dart';

class MessageDialog extends Dialog {
  Widget title;
  Widget message;
  String? negativeText;
  String? positiveText;
  Function onCloseEvent;
  Function? onPositivePressEvent;

  MessageDialog({
    Key? key,
    required this.title,
    required this.message,
    this.negativeText,
    this.positiveText,
    this.onPositivePressEvent,
    required this.onCloseEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Material(
        type: MaterialType.transparency,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              margin: const EdgeInsets.all(12.0),
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: new Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: <Widget>[
                        new Center(
                          child: title
                        ),
//                        new GestureDetector(
//                          onTap: this.onCloseEvent,
//                          child: new Padding(
//                            padding: const EdgeInsets.all(5.0),
//                            child: new Icon(
//                              Icons.close,
//                              color: Color(0xffe0e0e0),
//                            ),
//                          ),
//                        ),
                      ],
                    ),
                  ),
//                  new Container(
//                    color: Color(0xffe0e0e0),
//                    height: 1.0,
//                  ),
                  new Container(
//                    constraints: BoxConstraints(minHeight: 180.0),
                    child: new Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: new IntrinsicHeight(
                        child: message
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: this._buildBottomButtonGroup(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonGroup() {
    var widgets = <Widget>[];
    if (negativeText != null && negativeText!.isNotEmpty)
      widgets.add(_buildBottomCancelButton());
    if (positiveText != null && positiveText!.isNotEmpty)
      widgets.add(_buildBottomPositiveButton());
    return new Flex(
      direction: Axis.horizontal,
      children: widgets,
    );
  }

  Widget _buildBottomCancelButton() {
    return new Flexible(
      fit: FlexFit.tight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: new FlatButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: Color(0xffffd60c),
          onPressed: onCloseEvent as void Function()?,
          child: new Text(
            negativeText!,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPositiveButton() {
    return new Flexible(
      fit: FlexFit.tight,
      child: new FlatButton(
        onPressed: onPositivePressEvent as void Function()?,
        child: new Text(
          positiveText!,
          style: TextStyle(
            color: Color(Colors.teal.value),
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}