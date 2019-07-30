import 'dart:convert';

import 'package:b2b_commerce/src/_shared/products/apparel_product_list.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'products/apparel_product_form.dart';

class ApparelProductsPage extends StatefulWidget {
//  final List<ApparelProductModel> items = <ApparelProductModel>[];

  ApparelProductsPage();

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
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('产品管理'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                B2BIcons.search,
                size: 20,
              ),
              onPressed: ()async{
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistorySearch(
                  hintText: '请输入编码，名称，货号搜索',
                  historyKey: GlobalConfigs.PRODUCT_HISTORY_KEYWORD_KEY,
                )));
              },
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
                  status: status.code,
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
                        enabled: true,
                      )),
            );
          },
        ),
      ),
    );
  }

}
