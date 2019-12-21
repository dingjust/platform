import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_select_list.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class RequirementOrderSelectPage extends StatefulWidget{
  RequirementOrderSelectPage({
    Key key,
    this.models,
    this.onConfirm,
  }) : super(key: key);
  List<RequirementOrderModel> models;
  Function onConfirm;

  _RequirementOrderSelectPageState createState() => _RequirementOrderSelectPageState();
}

class _RequirementOrderSelectPageState extends State<RequirementOrderSelectPage> {
  final GlobalKey _globalKey = GlobalKey<_RequirementOrderSelectPageState>();
  String _keyword = '';
  List<RequirementOrderModel> _models = [];

  @override
  void initState() {
    if(widget.models != null){
      _models = List.from(widget.models);
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            builder: (_) => RequirementOrderSelectState()),
      ],
      child: Consumer<RequirementOrderSelectState>(
          builder: (context, RequirementOrderSelectState state, _) {
        state.queryFormData['status'] = 'PENDING_QUOTE';
        return Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            title: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () async{
                      dynamic result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistorySearch(
                            historyKey: GlobalConfigs.REQURIEMEN_ORDER_SELECT_HISTORY_KEYWORD_KEY,
                            hintText: '请输入订单号，标题，分类搜索',
                            keyword: _keyword,
                          ),
                        ),
                      );

                      if(result != null){
                        state.queryFormData['keyword'] = result;
                        _keyword = result;
                        state.clear();
                      }
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
                          _keyword == '' ? '请输入订单号，标题，分类搜索':_keyword,
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
          body: Container(
                child: state.requiremenOrderModels != null
                    ? RequirementOrderSelectList(
                  requirementSelectState: state,
                  models: _models,
                )
                    : Center(
                  child: CircularProgressIndicator(),
                ),
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: 50,
            child: RaisedButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '确定',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              onPressed: (){
                widget.onConfirm(_models);
              },
            ),
          ),
        );}
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}


