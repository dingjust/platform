import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 枚举选择器
class SingleEnumSelectPage extends StatefulWidget {
  SingleEnumSelectPage({
    this.title,
    this.items,
    this.code,
    this.count = 4,
  });

  //页面title
  final String title;
  //全部枚举的集合
  final List<dynamic> items;
  //被选中的枚举的code
  String code;
  //一行显示多少个
  final int count;

  SingleEnumSelectPageState createState() => SingleEnumSelectPageState();
}

class SingleEnumSelectPageState extends State<SingleEnumSelectPage> {
  String _code;

  @override
  void initState() {
    _code = widget.code;
      // TODO: implement initState
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> _items = widget.items.map((item) {
      return Container(
        width: MediaQuery.of(context).size.width / widget.count,
        child: ChoiceChip(
          selectedColor: Color.fromRGBO(255,214,12, 1),
          label: Text(item.name,style: TextStyle(color: Colors.black),),
          selected: _code == item.code,
          onSelected: (value) {
            setState(() {
              if(value){
                _code = item.code;
              }
            });
          },
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text(widget.title),
        leading: IconButton(icon: Text('取消',style: TextStyle(color: Colors.grey,),), onPressed: () {
           Navigator.pop(context);
        }),
        actions: <Widget>[
          IconButton(
            icon: Text('确定',style: TextStyle(),),
            onPressed: () {
              Navigator.pop(context,_code);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            child: Wrap(
              spacing: 0,
              children: _items,
            ),
          ),
        ],
      )
    );
  }

}
