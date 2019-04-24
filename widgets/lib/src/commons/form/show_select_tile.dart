import 'package:core/core.dart';
import 'package:flutter/material.dart';

class ShowSelectTile extends StatelessWidget {
  String leadingText;
  String tralingText;
  TextStyle leadingTextStyle;
  TextStyle tralingTextStyle;
  bool isRequired;

  ShowSelectTile({
    this.leadingText,
    this.tralingText,
    this.leadingTextStyle,
    this.tralingTextStyle,
    this.isRequired = false,
  }) {
    leadingTextStyle = TextStyle(
      fontSize: 16,
    );
    tralingTextStyle = TextStyle(
      fontSize: 16,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Expanded(
                child:Wrap(
                  children: <Widget>[
                  Text(
                  leadingText,
                  style: leadingTextStyle,
                ) ?? Text(''),
                    isRequired ? Text(' *',style: TextStyle(fontSize: leadingTextStyle.fontSize,color: Colors.red,)) : Text(''),
                  ],
                )
              ),
              tralingText != null
                  ? Text(
                      tralingText,
                      style: tralingTextStyle,
                    )
                  : Text(''),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[600],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
        ),
      ],
    );
  }
}
