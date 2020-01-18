import 'dart:convert';

import 'package:b2b_commerce/src/business/search/product_search_result.dart';
import 'package:b2b_commerce/src/business/search/proofing_search_result.dart';
import 'package:b2b_commerce/src/business/search/purchase_order_search_result.dart';
import 'package:b2b_commerce/src/business/search/quotes_search_result.dart';
import 'package:b2b_commerce/src/business/search/requirement_search_result.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class SearchModel {
  List<String> historyKeywords;

  SearchModelType searchModelType;

  FactoryCondition factoryCondition;

  ProductCondition productCondition;

  RequirementFilterCondition requirementCondition;

  String route;

  String keyword;

  bool isSelection;

  SearchModel({
    Key key,
    this.keyword,
    this.historyKeywords,
    this.searchModelType,
    this.factoryCondition,
    this.productCondition,
    this.requirementCondition,
    this.route,
    this.isSelection = false,
  });
}

class SearchModelPage extends StatefulWidget {
  SearchModel searchModel;

  SearchModelPage({
    Key key,
    this.searchModel,
  }) : super(key: key);

  _SearchModelPageState createState() => _SearchModelPageState();
}

enum SearchModelType {
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

  //产品选择
  PRODUCT_SELECT,

  //合同
  CONTRACT_SEARCH,
}

class _SearchModelPageState extends State<SearchModelPage> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  String searchText = '';

  List<String> _historyKeywords = [];

  @override
  void initState() {
    _historyKeywords = widget.searchModel.historyKeywords;
    if (widget.searchModel.keyword != null &&
        widget.searchModel.keyword != '') {
      controller.text = widget.searchModel.keyword;
    }
    super.initState();

    if (SearchModelType.EXIST_PRODUCT == widget.searchModel.searchModelType ||
        SearchModelType.PRODUCT == widget.searchModel.searchModelType) {
      searchText = '请输入编码，名称，货号搜索';
    } else if (SearchModelType.FACTORY == widget.searchModel.searchModelType) {
      searchText = '请输入编码，名称搜索';
    } else if (SearchModelType.CONTRACT_SEARCH ==
        widget.searchModel.searchModelType) {
      searchText = '请输入合同编号搜索';
    } else {
      searchText = '请输入订单号，名称，货号搜索';
    }

//    getHistory();
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
                  flex: 1,
                  child: LayoutBuilder(
                    builder: (context, constraints) =>
                        Container(
                          width: constraints.maxWidth,
                          height: 50,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.grey[300], width: 0.5),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  width: constraints.maxWidth,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: TextField(
                                          controller: controller,
                                          focusNode: focusNode,
                                          autofocus: true,
                                          decoration: InputDecoration(
                                            hintText: '${searchText}',
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                            contentPadding: EdgeInsets.all(0),
                                            disabledBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (value) {},
                                        ),
                                      ),
                                      Container(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              controller.text = '';
                                            });
                                          },
                                          child: Icon(
                                            Icons.clear,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                  )),
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
                    onPressed: () async {
                      onSubmit();
                      setState(() {
                        widget.searchModel.keyword = controller.text;
                      });
                    }),
              ),
            ],
          ),
        ),
        body: ListView(
          children: <Widget>[
            _buildHistoryListView(context),
          ],
        ));
  }

  onSubmit() {
    if (widget.searchModel.searchModelType == SearchModelType.PURCHASE_ORDER) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PurchaseOrderSearchResultPage(
                    searchModel: widget.searchModel,
                  )));
      if (controller.text != '') {
        if (widget.searchModel.historyKeywords.contains(controller.text)) {
          widget.searchModel.historyKeywords.remove(controller.text);
        }
        widget.searchModel.historyKeywords.add(controller.text);
        LocalStorage.save(GlobalConfigs.PRODUCT_HISTORY_KEYWORD_KEY,
            json.encode(widget.searchModel.historyKeywords));
      }
    }
    if (widget.searchModel.searchModelType == SearchModelType.QUOTE_ORDER) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  QuoteSearchResultPage(
                    searchModel: widget.searchModel,
                  )));
      if (controller.text != '' && controller.text.isNotEmpty) {
        widget.searchModel.historyKeywords.add(controller.text);
        LocalStorage.save(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
            json.encode(widget.searchModel.historyKeywords));
      }
    }
    if (widget.searchModel.searchModelType ==
        SearchModelType.REQUIREMENT_ORDER) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RequirementSearchResultPage(
                    searchModel: widget.searchModel,
                  )));
      if (controller.text != '' && controller.text.isNotEmpty) {
        widget.searchModel.historyKeywords.add(controller.text);
        LocalStorage.save(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
            json.encode(widget.searchModel.historyKeywords));
      }
    }
    if (widget.searchModel.searchModelType == SearchModelType.PROOFING_ORDER) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProofingSearchResultPage(
                    searchModel: widget.searchModel,
                  )));
      if (controller.text != '' && controller.text.isNotEmpty) {
        widget.searchModel.historyKeywords.add(controller.text);
        LocalStorage.save(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
            json.encode(widget.searchModel.historyKeywords));
      }
    }
    if (widget.searchModel.searchModelType == SearchModelType.PRODUCT) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductSearchResultPage(
                    searchModel: widget.searchModel,
                  )));
      if (controller.text != '' && controller.text.isNotEmpty) {
        _historyKeywords.add(controller.text);
        LocalStorage.save(GlobalConfigs.PRODUCT_HISTORY_KEYWORD_KEY,
            json.encode(widget.searchModel.historyKeywords));
      }
    }
    if (widget.searchModel.searchModelType == SearchModelType.PRODUCT_SELECT) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductSearchResultPage(
                    searchModel: widget.searchModel,
                  )));
      if (controller.text != '' && controller.text.isNotEmpty) {
        _historyKeywords.add(controller.text);
        LocalStorage.save(GlobalConfigs.PRODUCT_SELECT_HISTORY_KEYWORD_KEY,
            json.encode(widget.searchModel.historyKeywords));
      }
    }
    if (widget.searchModel.searchModelType == SearchModelType.FACTORY) {
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
          }).then((value) {
        Navigator.of(context).pop();
        FactoryCondition condition = widget.searchModel.factoryCondition;
        condition.keyword = controller.text;
        FactoryBLoC.instance.clear();
      });
      if (controller.text != '' && controller.text.isNotEmpty) {
        widget.searchModel.historyKeywords.add(controller.text);
        LocalStorage.save(GlobalConfigs.FACTORY_HISTORY_KEYWORD_KEY,
            json.encode(widget.searchModel.historyKeywords));
      }
      Navigator.of(context).pop();
    }
    if (widget.searchModel.searchModelType ==
        SearchModelType.PRODUCTION_ORDER) {
      ProductionBLoC.instance.clear();
      Navigator.of(context).pop(controller.text);
      if (controller.text != '' && controller.text.isNotEmpty) {
        widget.searchModel.historyKeywords.add(controller.text);
        LocalStorage.save(GlobalConfigs.PRODUCTION_HISTORY_KEYWORD_KEY,
            json.encode(widget.searchModel.historyKeywords));
      }
    }
    if (widget.searchModel.searchModelType == SearchModelType.EXIST_PRODUCT) {
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
          }).then((value) {
        ProductCondition condition = widget.searchModel.productCondition;
        condition.keyword = controller.text;
        OrderByProductBLoc.instance.clear();
        OrderByProductBLoc.instance.getData(condition);
        Navigator.of(context).pop();
        if (controller.text != '' && controller.text.isNotEmpty) {
          widget.searchModel.historyKeywords.add(controller.text);
          LocalStorage.save(GlobalConfigs.ORDER_PRODUCT_HISTORY_KEYWORD_KEY,
              json.encode(widget.searchModel.historyKeywords));
        }
      });
      Navigator.of(context).pop();
    }
    if (widget.searchModel.searchModelType ==
        SearchModelType.REQUIREMENT_QUOTE) {
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
          }).then((value) {
        RequirementFilterCondition condition =
            widget.searchModel.requirementCondition;
        condition.keyword = controller.text;
        RequirementPoolBLoC.instance.clear();
        Navigator.of(context).pop();
      });
      if (controller.text != '' && controller.text.isNotEmpty) {
        widget.searchModel.historyKeywords.add(controller.text);
        LocalStorage.save(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
            json.encode(widget.searchModel.historyKeywords));
      }
      Navigator.of(context).pop();
    }
//    if (widget.searchModel.searchModelType == SearchModelType.CONTRACT_SEARCH) {
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//                  ContractSearchResultPage(
//                    searchModel: widget.searchModel,
//                  )));
//      if (controller.text != '' && controller.text.isNotEmpty) {
//        widget.searchModel.historyKeywords.add(controller.text);
//        LocalStorage.save(GlobalConfigs.CONTRACT_HISTORY_KEYWORD_KEY,
//            json.encode(widget.searchModel.historyKeywords));
//      }
//    }
  }

  delayedLoading() {
    //注意！！别删！！
    int a = 1 + 1;
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
                  onPressed: () {
                    setState(() {
                      List<String> historyKeywords = List();
                      _historyKeywords = historyKeywords;
                      LocalStorage.save(widget.searchModel.route,
                          json.encode(_historyKeywords));
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                  label: Text(
                    '清除历史',
                    style: TextStyle(color: Color.fromRGBO(100, 100, 100, 1)),
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
              children: _historyKeywords
                  .map((keyword) =>
                  HistoryTag(
                    value: keyword,
                    onTap: () {
                      setState(() {
                        widget.searchModel.keyword = keyword;
                      });
//                  Navigator.pop(context);
                      if (widget.searchModel.searchModelType ==
                          SearchModelType.PURCHASE_ORDER) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PurchaseOrderSearchResultPage(
                                      searchModel: widget.searchModel,
                                    )));
                      }
                      if (widget.searchModel.searchModelType ==
                          SearchModelType.QUOTE_ORDER) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    QuoteSearchResultPage(
                                      searchModel: widget.searchModel,
                                    )));
                      }
                      if (widget.searchModel.searchModelType ==
                          SearchModelType.REQUIREMENT_ORDER) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RequirementSearchResultPage(
                                      searchModel: widget.searchModel,
                                    )));
                      }
                      if (widget.searchModel.searchModelType ==
                          SearchModelType.PROOFING_ORDER) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProofingSearchResultPage(
                                      searchModel: widget.searchModel,
                                    )));
                      }
                      if (widget.searchModel.searchModelType ==
                          SearchModelType.PRODUCT) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductSearchResultPage(
                                      searchModel: widget.searchModel,
                                    )));
                      }
                      if (widget.searchModel.searchModelType ==
                          SearchModelType.FACTORY) {
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
                            }).then((value) {
                          FactoryCondition condition =
                              widget.searchModel.factoryCondition;
                          condition.keyword = keyword;
                          FactoryBLoC.instance.clear();
                          Navigator.of(context).pop();
                        });
                        Navigator.of(context).pop();
                      }
                      if (widget.searchModel.searchModelType ==
                          SearchModelType.PRODUCTION_ORDER) {
                        ProductionBLoC.instance.clear();
                        Navigator.of(context).pop(keyword);
                      }
                      if (widget.searchModel.searchModelType ==
                          SearchModelType.EXIST_PRODUCT) {
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
                            }).then((value) {
                          ProductCondition condition =
                              widget.searchModel.productCondition;
                          condition.keyword = keyword;
                          OrderByProductBLoc.instance.clear();
                          OrderByProductBLoc.instance.getData(condition);
                          Navigator.of(context).pop();
                        });
                        Navigator.of(context).pop();
                      }
                      if (widget.searchModel.searchModelType ==
                          SearchModelType.REQUIREMENT_QUOTE) {
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
                            }).then((value) {
                          RequirementFilterCondition condition =
                              widget.searchModel.requirementCondition;
                          condition.keyword = keyword;
                          RequirementPoolBLoC.instance.clear();
                          Navigator.of(context).pop();
                        });
                        Navigator.of(context).pop();
                      }
//                  if(widget.searchModel.searchModelType == SearchModelType.CONTRACT_SEARCH) {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) =>
//                                ContractSearchResultPage(
//                                  searchModel: widget.searchModel,
//                                )));
//                  }
                    },
                  ))
                  .toList()),
        )
      ],
    );
  }
}
