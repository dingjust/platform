import 'package:flutter/material.dart';

class B2BListTitle extends StatelessWidget {
  final BorderSide bottomBorderSide;

  final Widget prefix;

  final Widget suffix;

  final bool isRequired;

  final VoidCallback onTap;

  const B2BListTitle({Key key,
    this.bottomBorderSide = const BorderSide(color: Colors.grey, width: 0.3),
    this.prefix,
    this.suffix,
    this.isRequired = false,
    this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration:
              BoxDecoration(border: Border(bottom: bottomBorderSide)),
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child:Wrap(
                        children: <Widget>[
                          suffix ?? Text(''),
                          isRequired ? Text(' *',style: TextStyle(fontSize: 16,color: Colors.red,)) : Text(''),
                        ],
                      )
                  ),
                  suffix == null? Text('') : suffix,
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
