import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';


class RequirementOrderInputPage extends StatefulWidget {
  String field;
  String fieldText;
  TextInputType inputType;

  RequirementOrderInputPage({this.field, this.fieldText, this.inputType});

  _RequirementOrderInputPageState createState() => _RequirementOrderInputPageState();
}

class _RequirementOrderInputPageState extends State<RequirementOrderInputPage>{
  FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  String result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('输入${widget.fieldText}'),
            elevation: 0.5,
            brightness: Brightness.light,
            centerTitle: true,
            actions: <Widget>[
              GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Center(
                      child: Text(
                        '确定',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 149, 22, 1)),
                      ),
                    ),
                  ),
                  onTap: () async {
                    //带值返回上一页
                    Navigator.of(context).pop(result);
                  }
              )
            ]
        ),
        body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                _buildFactoryInfo(context),
              ],
            ))
    );
  }

  Widget _buildFactoryInfo(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              focusNode: _focusNode,
              controller: _controller,
              inputType: widget.inputType,
              autofocus:true,
              leadingText: Text('${widget.fieldText}',style: TextStyle(fontSize: 16,)),
              hintText: '请输入${widget.fieldText}',
                  onChanged: (value){
                    result = value;
                  },
            ),
          ),
        ],
      ),
    );
  }

}