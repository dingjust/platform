import 'package:flutter/material.dart';

//按钮一动作
typedef void ButtonAction();

class FloatSelectPage extends StatefulWidget {
  String buttonText1;
  String buttonText2;
  Color buttonColor1;
  Color buttonColor2;
  ButtonAction action1;
  ButtonAction action2;

  FloatSelectPage({
    this.buttonText1,
    this.buttonText2,
    this.buttonColor1 : Colors.white,
    this.buttonColor2 : Colors.white,
    this.action1,
    this.action2,
});

  _FloatSelectPageState createState() => _FloatSelectPageState();
}

class _FloatSelectPageState extends State<FloatSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Center(
            child: Container(
              height: 300,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildSelectButton(widget.buttonText1,widget.buttonColor1,widget.action1),
                  _buildSelectButton(widget.buttonText2,widget.buttonColor2,widget.action2),
                ],
              ),
            ),
        ));
  }

  Widget _buildSelectButton(String buttonText,Color buttonColor, ButtonAction action) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
        width: 200,
        child: FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: action,
      child: Text('${buttonText}'),
    ),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
