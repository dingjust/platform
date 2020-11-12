import 'package:flutter/material.dart';

class FormTitle extends StatelessWidget {
  final String title;

  const FormTitle(
    this.title, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('$title'),
      ],
    );
  }
}

class FormLabel extends StatelessWidget {
  final String label;

  final bool require;

  const FormLabel(this.label, {Key key, this.require = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
          '$label',
          style:
              TextStyle(color: Color(0xff455a64), fontWeight: FontWeight.bold),
        ))
      ],
    );
  }
}

class FormBlock extends StatelessWidget {
  final List<Widget> children;

  const FormBlock({Key key, @required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: children,
      ),
    );
  }
}
