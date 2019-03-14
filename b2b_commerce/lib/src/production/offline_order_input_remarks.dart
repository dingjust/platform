import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';


class OfflineOrderInputRemarksPage extends StatefulWidget {
  String field;
  String fieldText;
  TextInputType inputType;

  OfflineOrderInputRemarksPage({this.field, this.fieldText, this.inputType});

  _OfflineOrderInputRemarksPageState createState() => _OfflineOrderInputRemarksPageState();
}

class _OfflineOrderInputRemarksPageState extends State<OfflineOrderInputRemarksPage>{
  FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  String result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('订单备注'),
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
                            color: Color.fromRGBO(255, 214, 12, 1)),
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