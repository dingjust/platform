import 'dart:convert';

import 'package:b2b_commerce/src/_shared/cooperator/cooperator_search_list.dart';
import 'package:b2b_commerce/src/_shared/products/apparel_product_search_list.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class CooperatorSelectPage extends StatefulWidget{
  CooperatorSelectPage({
    Key key,
  }) : super(key: key);

  _CooperatorSelectPageState createState() => _CooperatorSelectPageState();
}

class _CooperatorSelectPageState extends State<CooperatorSelectPage> {
  final GlobalKey _globalKey = GlobalKey<_CooperatorSelectPageState>();
  String _keyword = '';
  String _status;

  @override
  Widget build(BuildContext context) {
//    if(UserBLoC.instance.currentUser.type == UserType.FACTORY){
//      _status = ArticleApprovalStatusMap[ArticleApprovalStatus.approved];
//    }
    return BLoCProvider<ApparelProductBLoC>(
      key: _globalKey,
      bloc: ApparelProductBLoC.instance,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              builder: (_) => CooperatorState()),
        ],
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
                          _keyword == '' ? '请输入合作商名称，联系人，联系方式搜索':_keyword,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
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
            child: Consumer<CooperatorState>(
              builder: (context, CooperatorState cooperatorState, _) =>
                  Container(
                    child: cooperatorState.cooperatorModels != null
                        ? CooperatorSearchList(
                      cooperatorState: cooperatorState,
                    )
                        : Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
            ),
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
          historyKey: GlobalConfigs.COOPERATOR_SELECT_HISTORY_KEYWORD_KEY,
          hintText: '请输入合作商名称，联系人，联系方式搜索',
          keyword: _keyword,
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


