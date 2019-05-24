import 'package:b2b_commerce/src/_shared/products/apparel_product_list.dart';
import 'package:b2b_commerce/src/_shared/products/product_search_delegate_page.dart';
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

  ApparelProductsPage({this.isSelectOption = false, this.item,});

  _ApparelProductsPageState createState() => _ApparelProductsPageState();
}

class _ApparelProductsPageState extends State<ApparelProductsPage> with SingleTickerProviderStateMixin{

  final List<EnumModel> _statuses = UserBLoC.instance.currentUser.type == UserType.FACTORY ? <EnumModel>[
    EnumModel('approved', '上架产品'),
    EnumModel('unapproved', '下架产品'),
  ] : [
    EnumModel('ALL', '全部产品'),
  ];

  String _keyword;
  TabController _tabController;
  bool isChangeTab = false;

  @override
  void initState() {
    _tabController = TabController(length: _statuses.length, vsync: this);
    _tabController.addListener((){
      print('${_tabController.index}------------------------');
      print('${_tabController.indexIsChanging}------------------------');
      if(_tabController.index.toDouble() == _tabController.animation.value){
//        setState(() {
//          isChangeTab = true;
//        });
      }

    });

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
            title: Text(_keyword == null ? '产品管理' : _keyword),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  B2BIcons.search,
                  size: 20,
                ),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ProductSearchDelegatePage(
                        isSelectOption:widget.isSelectOption
                    ),
                  ).then((a){
                    setState(() {
                      _keyword = a?.name;
                      ApparelProductBLoC.instance.clear();
                    });
                  });
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
                    isSelectOption: widget.isSelectOption,
                    status: status.code,
                    keyword: _keyword,
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
