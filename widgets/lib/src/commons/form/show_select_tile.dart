import 'package:flutter/material.dart';

class ShowSelectTile extends StatelessWidget {
  String? leadingText;
  String? tralingText;
  TextStyle? leadingTextStyle;
  TextStyle? tralingTextStyle;
  bool isRequired;
  bool isShowIcon;

  ShowSelectTile({
    this.leadingText,
    this.tralingText,
    this.leadingTextStyle,
    this.tralingTextStyle,
    this.isRequired = false,
    this.isShowIcon = true,
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
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15,),
          child: Row(
            children: <Widget>[
              Expanded(
                child:Wrap(
                  children: <Widget>[
                  Text(
                        leadingText!,
                        style: leadingTextStyle,
                      ) ??
                      Text(''),
                  isRequired
                      ? Text(' *',
                          style: TextStyle(
                            fontSize: leadingTextStyle!.fontSize,
                            color: Colors.red,
                          ))
                      : Text(''),
                ],
              )
              ),
              tralingText != null
                  ? Text(
                tralingText!,
                      style: tralingTextStyle,
                    )
                  : Text(''),
              isShowIcon ? Icon(
                Icons.chevron_right,
                color: Colors.grey[600],
              ):SizedBox(height: 22),
            ],
          ),
        ),
      ],
    );
  }
}
