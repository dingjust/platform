import 'dart:convert';

import 'package:b2b_commerce/src/_shared/products/apparel_product_list.dart';
import 'package:b2b_commerce/src/_shared/products/product_search_delegate_page.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'products/apparel_product_form.dart';

class ApparelProductsPage extends StatefulWidget {
//  final List<ApparelProductModel> items = <ApparelProductModel>[];
  final bool isSelectOption;
  final ApparelProductModel item;
  String keyword;

  ApparelProductsPage({this.isSelectOption = false, this.item,this.keyword});

  _ApparelProductsPageState createState() => _ApparelProductsPageState();
}

class _ApparelProductsPageState extends State<ApparelProductsPage> with SingleTickerProviderStateMixin{

  final List<EnumModel> _statuses = UserBLoC.instance.currentUser.type == UserType.FACTORY ? <EnumModel>[
    EnumModel('approved', '上架产品'),
    EnumModel('unapproved', '下架产品'),
  ] : [
    EnumModel('ALL', '全部产品'),
  ];


  TabController _tabController;
  bool isChangeTab = false;
  List<String> historyKeywords;

  @override
  void initState() {
    _tabController = TabController(length: _statuses.length, vsync: this);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    //清除缓存
    ApparelProductBLoC.instance.clearProductsMap();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ApparelProductBLoC>(
      bloc: ApparelProductBLoC.instance,
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context, widget.item);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            centerTitle: true,
            title: Text(widget.keyword == null ? '产品管理' : widget.keyword),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  B2BIcons.search,
                  size: 20,
                ),
                onPressed: (){
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return RequestDataLoading(
                          requestCallBack: LocalStorage.get(
                              GlobalConfigs.PRODUCTION_HISTORY_KEYWORD_KEY),
                          outsideDismiss: false,
                          loadingText: '加载中。。。',
                          entrance: 'createPurchaseOrder',
                        );
                      }
                  ).then((value) {
                    if (value != null && value != '') {
                      List<dynamic> list = json.decode(value);
                      historyKeywords = list.map((item) => item as String).toList();
                    } else {
                      historyKeywords = [];
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchModelPage(historyKeywords: historyKeywords,
                              searchModel: SearchModel.PRODUCT,),
                      ),
                    );
                  });
                },
//                onPressed: () {
//                  showSearch(
//                    context: context,
//                    delegate: ProductSearchDelegatePage(
//                        isSelectOption:widget.isSelectOption
//                    ),
//                  ).then((a){
//                    setState(() {
//                      _keyword = a?.name;
//                      ApparelProductBLoC.instance.clear();
//                    });
//                  });
//                },
              ),
            ],
          ),
          body:Scaffold(
            appBar: TabBar(
              controller: _tabController,
              unselectedLabelColor: Colors.black26,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: _statuses.map((status) {
                return Tab(text: status.name);
              }).toList(),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
              isScrollable: false,
            ),
            body: TabBarView(
              controller: _tabController,
              children: _statuses
                  .map((status) {
                return Container(
                  padding: EdgeInsets.only(top: 10),
                  child:ApparelProductList(
                    key: PageStorageKey(status),
                    isSelectOption: widget.isSelectOption,
                    status: status.code,
                    keyword: widget.keyword,
                  ),);
              })
                  .toList(),
            ),
          ),

          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ApparelProductFormPage(
                          item: ApparelProductBLoC.instance.newProduct,
                          isCreate: true,
                        )),
              );
            },
          ),
        ),
      ),
    );
  }
}
