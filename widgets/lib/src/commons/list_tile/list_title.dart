import 'package:flutter/material.dart';
import 'package:core/core.dart';

class B2BListTitle extends StatelessWidget {

  final Widget prefix;

  final Widget suffix;

  final bool isRequired;

  final VoidCallback onTap;

  const B2BListTitle({Key key,
    this.prefix,
    this.suffix,
    this.isRequired = false,
    this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Row(
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      prefix ?? Text(''),
                      isRequired ? Text(' *',style: TextStyle(fontSize: 16,color: Colors.red,)) : Text(''),
                    ],
                  ),
                  Expanded(child: suffix == null? Text('') : suffix),
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
