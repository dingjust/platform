import 'dart:convert';

import 'package:b2b_commerce/src/business/products/product_search.dart';
import 'package:b2b_commerce/src/my/contract/contract_search_result.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class HistorySearch extends StatefulWidget {
  String hintText;
  String historyKey;
  String keyword;

  HistorySearch({
    this.historyKey = '',
    this.hintText = '',
    this.keyword = '',
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
    controller.text = widget.keyword;

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
                                  color: Colors.grey,
                                fontSize: 12
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
                child: FlatButton(
                    child: Text(
                      '搜索',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    onPressed: () => onSearch(context),
                ),
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

  void onSearch(BuildContext context) {
    setState(() {
      if(controller.text != ''){
        if(_historywords.contains(controller.text)){
         _historywords.remove(controller.text);
        }
        _historywords.add(controller.text);
        LocalStorage.save(widget.historyKey, json.encode(_historywords));
      }
    });
      switch(widget.historyKey){
        case GlobalConfigs.PRODUCT_HISTORY_KEYWORD_KEY:
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductSearchPage(
            keyword: controller.text,
          )));
          break;
        case GlobalConfigs.PRODUCT_SELECT_HISTORY_KEYWORD_KEY:
          Navigator.pop(context,controller.text);
          break;
//        case GlobalConfigs.ORDER_PRODUCT_HISTORY_KEYWORD_KEY:
//          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductSearchPage(
//            keyword: controller.text,
//          )));
//          break;
        case GlobalConfigs.CONTRACT_HISTORY_KEYWORD_KEY:
          Navigator.push(context, MaterialPageRoute(builder: (context) => ContractSearchResultPage(
            keyword: controller.text,
          )));
          break;
        default :
          Navigator.pop(context,controller.text);
          break;
      }

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
                return GestureDetector(
                  onTap: (){
                    controller.text = word;
                    this.onSearch(context);
                  },
                  child: Chip(
                    backgroundColor: Color.fromRGBO(245, 245, 245, 1),
                    label: Text(
                      word,
                      style: TextStyle(),
                    ),
                  ),
                );;
              }).toList()
          )
        )
      ],
    );
  }
}
