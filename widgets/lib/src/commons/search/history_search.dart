import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

class HistorySearch extends StatefulWidget {
  String hintText;
  String historyKey;

  HistorySearch({
    this.historyKey = '',
    this.hintText = '',
  });

  @override
  _HistorySearchState createState() => _HistorySearchState();
}

class _HistorySearchState extends State<HistorySearch> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<String> _historywords = [];

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  }

  //获取本地搜索历史记录
  void getHistory() async {
    //解析
    String jsonStr =
    await LocalStorage.get(widget.historyKey);
    if (jsonStr != null && jsonStr != '') {
      List<dynamic> list = json.decode(jsonStr);
      _historywords = list.map((item) => item as String).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    getHistory();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300], width: 0.5),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: controller,
                            focusNode: focusNode,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: '${widget.hintText}',
                              hintStyle: TextStyle(
                                  color: Colors.grey
                              ),
                              contentPadding: EdgeInsets.all(0),
                              disabledBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none,
                            ),
                            onChanged: (value){
                            },
                          ),
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                controller.text = '';
                              });
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                width: 70,
                height: 32,
                child: RaisedButton(
                    color: Color.fromRGBO(255, 214, 12, 1),
                    child: Text(
                      '搜  索',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    onPressed: () async {
                      setState(() {
                        if(controller.text != ''){
                          if(_historywords.contains(controller.text)){
                           _historywords.remove(controller.text);
                          }
                          _historywords.add(controller.text);
                          LocalStorage.save(widget.historyKey, json.encode(_historywords));
                        }
                      });
                      Navigator.pop(context,controller.text);
                    }),
              ),
            ],
          ),
        ),
        body: ListView(
          children: <Widget>[
            _buildHistoryListView(context),
          ],
        )
    );
  }

  //历史搜索部分
  Widget _buildHistoryListView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '历史搜索',
                  style: TextStyle(
                      color: Color.fromRGBO(100, 100, 100, 1), fontSize: 18),
                ),
              ),
              Container(
                child: FlatButton.icon(
                  onPressed: (){
                    setState(() {
                      _historywords.clear();
                      LocalStorage.remove(widget.historyKey);
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                  label: Text(
                    '清除历史',
                    style: TextStyle(
                        color: Color.fromRGBO(100, 100, 100, 1)
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
          child: Wrap(
              spacing: 8.0, // 主轴(水平)方向间距
              runSpacing: 4.0, // 纵轴（垂直）方向间距
              alignment: WrapAlignment.start, //沿主轴方向居中
              children:_historywords.map((word){
                return Text(word);
              }).toList()
          )
        )
      ],
    );
  }
}
