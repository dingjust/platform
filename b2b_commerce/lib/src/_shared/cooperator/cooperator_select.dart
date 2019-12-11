import 'package:b2b_commerce/src/_shared/cooperator/cooperator_select_list.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class CooperatorSelectPage extends StatefulWidget{
  CooperatorSelectPage({
    Key key,
    this.models,
  }) : super(key: key);
  List<CooperatorModel> models;

  _CooperatorSelectPageState createState() => _CooperatorSelectPageState();
}

class _CooperatorSelectPageState extends State<CooperatorSelectPage> {
  final GlobalKey _globalKey = GlobalKey<_CooperatorSelectPageState>();
  String _keyword = '';
  List<CooperatorModel> _models = [];
  CooperatorState cooperatorState;

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
    return BLoCProvider<ApparelProductBLoC>(
      key: _globalKey,
      bloc: ApparelProductBLoC.instance,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              builder: (_) => CooperatorState()),
        ],
        child: Consumer<CooperatorState>(
            builder: (context, CooperatorState cooperatorState, _) {
          cooperatorState.queryFormData['type'] = 'ONLINE';
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
                              historyKey: GlobalConfigs.COOPERATOR_SELECT_HISTORY_KEYWORD_KEY,
                              hintText: '请输入合作商名称，联系人，联系方式搜索',
                              keyword: _keyword,
                            ),
                          ),
                        );

                        if(result != null){
                          cooperatorState.queryFormData['keyword'] = result;
                          _keyword = result;
                          cooperatorState.clear();
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
            body: Container(
                  child: cooperatorState.cooperatorModels != null
                      ? CooperatorSelectList(
                    cooperatorState: cooperatorState,
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
                  Navigator.pop(context,_models);
                },
              ),
            ),
          );}
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


