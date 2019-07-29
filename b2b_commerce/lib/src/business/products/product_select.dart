import 'dart:convert';

import 'package:b2b_commerce/src/_shared/products/apparel_product_item.dart';
import 'package:b2b_commerce/src/_shared/products/apparel_product_list.dart';
import 'package:b2b_commerce/src/_shared/products/apparel_product_search_list.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/business/products/apparel_product_form.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:services/src/order/PageEntry.dart';

class ProductSelectPage extends StatefulWidget{
  ProductSelectPage({
    Key key,
  }) : super(key: key);

  _ProductSelectPageState createState() => _ProductSelectPageState();
}

class _ProductSelectPageState extends State<ProductSelectPage> {
  final GlobalKey _globalKey = GlobalKey<_ProductSelectPageState>();
  String _keyword = '';
  String _status;

  @override
  Widget build(BuildContext context) {
    if(UserBLoC.instance.currentUser.type == UserType.FACTORY){
      _status = ArticleApprovalStatusMap[ArticleApprovalStatus.approved];
    }
    return BLoCProvider<ApparelProductBLoC>(
      key: _globalKey,
      bloc: ApparelProductBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          title: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    onClick();
                  },
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
                      child: Text(
                        _keyword,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ApparelProductSearchList(
            isSelection:true,
            status: _status,
            keyword: _keyword,
          ),
        ),
      ),
    );
  }

  void onClick() async{
    dynamic result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistorySearch(
          historyKey: GlobalConfigs.PRODUCT_SELECT_HISTORY_KEYWORD_KEY,
          hintText: '请输入编码，名称，货号搜索',
        ),
      ),
    );

    if(result != null){
      setState(() {
        _keyword = result;
        //清空搜索结果数据
        ApparelProductBLoC.instance.clearSelectSearchProducts();
      });
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}


