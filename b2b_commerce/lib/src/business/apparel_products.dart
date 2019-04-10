import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'package:b2b_commerce/src/_shared/products/product_search_delegate_page.dart';

import 'package:b2b_commerce/src/_shared/products/apparel_product_list.dart';
import 'products/apparel_product_form.dart';

class ApparelProductsPage extends StatefulWidget {
//  final List<ApparelProductModel> items = <ApparelProductModel>[];
  final bool isSelectOption;
  final ApparelProductModel item;

  ApparelProductsPage({this.isSelectOption = false, this.item});

  _ApparelProductsPageState createState() => _ApparelProductsPageState();
}

class _ApparelProductsPageState extends State<ApparelProductsPage>{
  final List<EnumModel> _statuses = UserBLoC.instance.currentUser.type == UserType.FACTORY ? <EnumModel>[
    EnumModel('approved', '上架产品'),
    EnumModel('unapproved', '下架产品'),
  ] : [
    EnumModel('ALL', '全部产品'),
  ];

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
            title: Text('产品管理'),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  B2BIcons.search,
                  size: 20,
                ),
                onPressed: () => showSearch(
                      context: context,
                      delegate: ProductSearchDelegatePage(),
                    ),
              ),
            ],
          ),
          body:DefaultTabController(
            length: _statuses.length,
            child: Scaffold(
              appBar: TabBar(
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
                children: _statuses
                    .map((status) => Container(
                  padding: EdgeInsets.only(top: 10),
                  child:ApparelProductList(
                  isSelectOption: widget.isSelectOption,
                  status:status.code,
                ),))
                    .toList(),
              ),
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
