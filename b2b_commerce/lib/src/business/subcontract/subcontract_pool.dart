import 'package:b2b_commerce/src/_shared/subcontract/subcontract_pool_list.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class SubContractPoolPage extends StatefulWidget{
  SubContractPoolPage({
    Key key,
  }) : super(key: key);

  _SubContractPoolPageState createState() => _SubContractPoolPageState();
}

class _SubContractPoolPageState extends State<SubContractPoolPage> {
  final GlobalKey _globalKey = GlobalKey<_SubContractPoolPageState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            builder: (_) => SubContractPoolState()),
      ],
      child: Consumer(
        builder: (context, SubContractPoolState subContractPoolState,_) => Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            title:   Text(subContractPoolState.keyword == null || subContractPoolState.keyword == '' ? '转包/裁片' : subContractPoolState.keyword),
            actions: <Widget>[
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () async{
                      dynamic result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistorySearch(
                            historyKey: GlobalConfigs.SUBCONTRACT_POOL_HISTORY_KEYWORD_KEY,
                            hintText: '请输入转包标题，分类搜索',
                            keyword: subContractPoolState.keyword,
                          ),
                        ),
                      );

                      if(result != null){
                        subContractPoolState.keyword = result;
                        subContractPoolState.clear();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.search,
                      ),
                    ),
                  );
                }
              ),
            ],
          ),
          body:  SubContractPoolList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}


