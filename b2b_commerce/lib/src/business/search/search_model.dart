import 'dart:convert';

import 'package:b2b_commerce/src/business/search/product_search_result.dart';
import 'package:b2b_commerce/src/business/search/proofing_search_result.dart';
import 'package:b2b_commerce/src/business/search/purchase_order_search_result.dart';
import 'package:b2b_commerce/src/business/search/quotes_search_result.dart';
import 'package:b2b_commerce/src/business/search/requirement_search_result.dart';
import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class SearchModelPage extends StatefulWidget {
  List<String> historyKeywords;

  SearchModel searchModel;

  FactoryCondition factoryCondition;

  ProductCondition productCondition;

  RequirementFilterCondition requirementCondition;

  SearchModelPage({
    Key key,
    this.keyword,
    this.historyKeywords,
    this.searchModel,
    this.factoryCondition,
    this.productCondition,
    this.requirementCondition,
  }) : super(key: key);

  _SearchModelPageState createState() => _SearchModelPageState();

  String keyword;
}

enum SearchModel {
  /// 生产订单管理
  PURCHASE_ORDER,

  /// 生产页面
  PRODUCTION_ORDER,

  //报价单
  QUOTE_ORDER,

  //需求订单
  REQUIREMENT_ORDER,

  //打样订单
  PROOFING_ORDER,

  //产品
  PRODUCT,

  //工厂
  FACTORY,

  //现款产品
  EXIST_PRODUCT,

  //需求报价
  REQUIREMENT_QUOTE,

}

class _SearchModelPageState extends State<SearchModelPage> {

  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    if(widget.keyword != null && widget.keyword != ''){
      controller.text = widget.keyword;
    }
    super.initState();
//    getHistory();
  }

  //获取本地搜索历史记录
  void getHistory() async {
    //解析
    String jsonStr =
    await LocalStorage.get(GlobalConfigs.PRODUCTION_HISTORY_KEYWORD_KEY);
    if (jsonStr != null && jsonStr != '') {
      List<dynamic> list = json.decode(jsonStr);
      widget.historyKeywords = list.map((item) => item as String).toList();
      print(widget.historyKeywords);
    } else {
      widget.historyKeywords = [];
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: '请输入订单号，名称，货号搜索',
                            hintStyle: TextStyle(
                              color: Colors.grey
                            ),
                            contentPadding: EdgeInsets.all(0),
                            disabledBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                          ),
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
                    Navigator.pop(context);
                    onSubmit();
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

  onSubmit() async{
    if(widget.searchModel == SearchModel.PURCHASE_ORDER) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PurchaseOrderSearchResultPage(
                    keyword: controller.text,
                  )));
        if (controller.text != '' && controller.text.isNotEmpty) {
          widget.historyKeywords.add(controller.text);
          LocalStorage.save(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
              json.encode(widget.historyKeywords));
        }
    }
    if (widget.searchModel == SearchModel.QUOTE_ORDER) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  QuoteSearchResultPage(
                    keyword: controller.text,
                  )));
        if (controller.text != '' && controller.text.isNotEmpty) {
          widget.historyKeywords.add(controller.text);
          LocalStorage.save(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
              json.encode(widget.historyKeywords));
        }
    }
    if (widget.searchModel == SearchModel.REQUIREMENT_ORDER) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RequirementSearchResultPage(
                    keyword: controller.text,
                  )));
        if (controller.text != '' && controller.text.isNotEmpty) {
          widget.historyKeywords.add(controller.text);
          LocalStorage.save(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
              json.encode(widget.historyKeywords));
        }
    }
    if (widget.searchModel == SearchModel.PROOFING_ORDER) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProofingSearchResultPage(
                    keyword: controller.text,
                  )));
        if (controller.text != '' && controller.text.isNotEmpty) {
          widget.historyKeywords.add(controller.text);
          LocalStorage.save(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
              json.encode(widget.historyKeywords));
        }
    }
    if(widget.searchModel == SearchModel.PRODUCT){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductSearchResultPage(
                    keyword: controller.text,
                  )));
        if (controller.text != '' && controller.text.isNotEmpty) {
          widget.historyKeywords.add(controller.text);
          LocalStorage.save(GlobalConfigs.PRODUCT_HISTORY_KEYWORD_KEY,
              json.encode(widget.historyKeywords));
        }
    }
    if(widget.searchModel == SearchModel.FACTORY){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: delayedLoading(),
              outsideDismiss: false,
              loadingText: '加载中。。。',
              entrance: '',
            );
          }
      ).then((value){
        FactoryCondition condition = widget.factoryCondition;
        condition.keyword = controller.text;
        FactoryBLoC.instance.clear();
      });
        if (controller.text != '' && controller.text.isNotEmpty) {
          widget.historyKeywords.add(controller.text);
          LocalStorage.save(GlobalConfigs.FACTORY_HISTORY_KEYWORD_KEY,
              json.encode(widget.historyKeywords));
        }
      Navigator.of(context).pop();
    }
    if(widget.searchModel == SearchModel.PRODUCTION_ORDER){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: ProductionBLoC.instance.refreshData(controller.text),
              outsideDismiss: false,
              loadingText: '加载中。。。',
              entrance: '',
            );
          }
      ).then((value){
        if (controller.text != '' && controller.text.isNotEmpty) {
          widget.historyKeywords.add(controller.text);
          LocalStorage.save(GlobalConfigs.PRODUCTION_HISTORY_KEYWORD_KEY,
              json.encode(widget.historyKeywords));
        }
      });
    }
    if(widget.searchModel == SearchModel.EXIST_PRODUCT){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: delayedLoading(),
              outsideDismiss: false,
              loadingText: '加载中。。。',
              entrance: '',
            );
          }
      ).then((value){
        ProductCondition condition = widget.productCondition;
        condition.keyword = controller.text;
        OrderByProductBLoc.instance.clear();
        OrderByProductBLoc.instance.getData(condition);

        if (controller.text != '' && controller.text.isNotEmpty) {
          widget.historyKeywords.add(controller.text);
          LocalStorage.save(GlobalConfigs.ORDER_PRODUCT_HISTORY_KEYWORD_KEY,
              json.encode(widget.historyKeywords));
        }
      });
      Navigator.of(context).pop();
    }
    if(widget.searchModel == SearchModel.REQUIREMENT_QUOTE){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: delayedLoading(),
              outsideDismiss: false,
              loadingText: '加载中。。。',
              entrance: '',
            );
          }
      ).then((value){
        RequirementFilterCondition condition = widget.requirementCondition;
        condition.keyword = controller.text;
        RequirementPoolBLoC.instance.clear();
      });
      if (controller.text != '' && controller.text.isNotEmpty) {
        widget.historyKeywords.add(controller.text);
        LocalStorage.save(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
            json.encode(widget.historyKeywords));
      }
      Navigator.of(context).pop();
    }
  }

  delayedLoading(){
    //注意！！别删！！
    int a = 1+1;
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
                        widget.historyKeywords = [];
                        LocalStorage.save(GlobalConfigs.PRODUCTION_HISTORY_KEYWORD_KEY,
                            json.encode(widget.historyKeywords));
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
              children: widget.historyKeywords.map((keyword) => HistoryTag(
                value: keyword,
                onTap: () {
                  Navigator.pop(context);
                  if(widget.searchModel == SearchModel.PURCHASE_ORDER) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PurchaseOrderSearchResultPage(
                                  keyword: keyword,
                                )));
                  }
                  if (widget.searchModel == SearchModel.QUOTE_ORDER) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QuoteSearchResultPage(
                                  keyword: keyword,
                                )));
                  }
                  if (widget.searchModel == SearchModel.REQUIREMENT_ORDER) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RequirementSearchResultPage(
                                  keyword: keyword,
                                )));
                  }
                  if (widget.searchModel == SearchModel.PROOFING_ORDER) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProofingSearchResultPage(
                                  keyword: keyword,
                                )));
                  }
                  if(widget.searchModel == SearchModel.PRODUCT){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductSearchResultPage(
                                  keyword: keyword,
                                )));
                  }
                  if(widget.searchModel == SearchModel.FACTORY){
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return RequestDataLoading(
                            requestCallBack: delayedLoading(),
                            outsideDismiss: false,
                            loadingText: '加载中。。。',
                            entrance: '',
                          );
                        }
                    ).then((value){
                      FactoryCondition condition = widget.factoryCondition;
                      condition.keyword = keyword;
                      FactoryBLoC.instance.clear();
                    });
                    Navigator.of(context).pop();
                  }
                  if(widget.searchModel == SearchModel.PRODUCTION_ORDER){
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return RequestDataLoading(
                            requestCallBack: ProductionBLoC.instance.refreshData(keyword),
                            outsideDismiss: false,
                            loadingText: '加载中。。。',
                            entrance: '',
                          );
                        }
                    );

                  }
                  if(widget.searchModel == SearchModel.EXIST_PRODUCT){
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return RequestDataLoading(
                            requestCallBack: delayedLoading(),
                            outsideDismiss: false,
                            loadingText: '加载中。。。',
                            entrance: '',
                          );
                        }
                    ).then((value){
                      ProductCondition condition = widget.productCondition;
                      condition.keyword = keyword;
                      OrderByProductBLoc.instance.clear();
                      OrderByProductBLoc.instance.getData(condition);

                    });
                    Navigator.of(context).pop();
                  }
                  if(widget.searchModel == SearchModel.REQUIREMENT_QUOTE){
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return RequestDataLoading(
                            requestCallBack: delayedLoading(),
                            outsideDismiss: false,
                            loadingText: '加载中。。。',
                            entrance: '',
                          );
                        }
                    ).then((value){
                      RequirementFilterCondition condition = widget.requirementCondition;
                      condition.keyword = keyword;
                      RequirementPoolBLoC.instance.clear();
                    });
                    Navigator.of(context).pop();
                  }
                },
              ))
                  .toList()),
        )
      ],
    );
  }

}

