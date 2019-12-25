import 'package:b2b_commerce/src/_shared/subcontract/subcontract_mine_list.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class SubContractMinePage extends StatefulWidget {
  SubContractMinePage({
    Key key,
  }) : super(key: key);

  _SubContractMinePageState createState() => _SubContractMinePageState();
}

class _SubContractMinePageState extends State<SubContractMinePage> {
  final GlobalKey _globalKey = GlobalKey<_SubContractMinePageState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => SubContractMineState()),
      ],
      child: Consumer<SubContractMineState>(
          builder: (context, SubContractMineState subContractMineState, _) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            title: Text(subContractMineState.keyword ?? '我的发布'),
            actions: <Widget>[
              GestureDetector(
                onTap: () async{
                  dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistorySearch(
                        historyKey: GlobalConfigs.SUBCONTRACT_MINE_HISTORY_KEYWORD_KEY,
                        hintText: '请输入转包标题，分类搜索',
                        keyword: subContractMineState.keyword,
                      ),
                    ),
                  );

                  if(result != null){
                    subContractMineState.keyword = result;
                    subContractMineState.clear();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right:10.0),
                  child: Icon(
                    Icons.search,
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            child: subContractMineState.subcontractModels != null
                ? SubContractMineList(
                    subcontractMineState: subContractMineState,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
