import 'package:flutter/material.dart';

class FormSelectRow extends StatelessWidget {
  final String title;

  final String val;

  final EdgeInsetsGeometry padding;

  final TextStyle titleTextStyle;

  final VoidCallback onTap;

  const FormSelectRow(
      {Key key,
      this.padding = const EdgeInsets.all(0),
      this.titleTextStyle =
          const TextStyle(color: Color(0xff000000), fontSize: 14),
      this.title,
      this.val,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: padding,
        child: Row(
          children: <Widget>[
            Container(
              width: 80,
              child: Text(
                '$title',
                style: titleTextStyle,
              ),
            ),
            Expanded(
                flex: 1,
                child: Text((val != null && val != '') ? '$val' : '请选择',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: (val != null && val != '')
                            ? Color(0xFF222222)
                            : Color(0xff999999)))),
            Icon(
              Icons.chevron_right,
              color: Color(0xFF999999),
            )
          ],
        ),
      ),
    );
  }
}

class FormRow extends StatelessWidget {
  final String title;

  final Widget child;

  final EdgeInsetsGeometry padding;

  final TextStyle titleTextStyle;

  final VoidCallback onTap;

  const FormRow(
      {Key key,
      this.padding = const EdgeInsets.all(0),
      this.titleTextStyle =
          const TextStyle(color: Color(0xff000000), fontSize: 14),
      this.title,
      this.child,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: padding,
        child: Row(
          children: <Widget>[
            Container(
              width: 80,
              child: Text(
                '$title',
                style: titleTextStyle,
              ),
            ),
            Expanded(child: child ?? Container()),
          ],
        ),
      ),
    );
  }
}
