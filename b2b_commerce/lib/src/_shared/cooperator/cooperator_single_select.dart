import 'dart:convert';

import 'package:b2b_commerce/src/_shared/cooperator/cooperator_single_select_list.dart';
import 'package:b2b_commerce/src/_shared/products/apparel_product_search_list.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class CooperatorSingleSelectPage extends StatefulWidget {
  CooperatorSingleSelectPage({
    Key key,
    this.model,
  }) : super(key: key);
  CooperatorModel model;

  _CooperatorSingleSelectPageState createState() =>
      _CooperatorSingleSelectPageState();
}

class _CooperatorSingleSelectPageState
    extends State<CooperatorSingleSelectPage> {
  final GlobalKey _globalKey = GlobalKey<_CooperatorSingleSelectPageState>();
  String _keyword = '';
  CooperatorState cooperatorState;

  @override
  void initState() {
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
          ChangeNotifierProvider(create: (_) => CooperatorState()),
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
                      onTap: () async {
                        dynamic result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistorySearch(
                              historyKey: GlobalConfigs
                                  .COOPERATOR_SELECT_HISTORY_KEYWORD_KEY,
                              hintText: '请输入合作商名称，联系人，联系方式搜索',
                              keyword: _keyword,
                            ),
                          ),
                        );

                        if (result != null) {
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
                          border:
                          Border.all(color: Colors.grey[300], width: 0.5),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            _keyword == '' ? '请输入合作商名称，联系人，联系方式搜索' : _keyword,
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
                  ? CooperatorSingleSelectList(
                cooperatorState: cooperatorState,
                model: widget.model,
              )
                  : Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
            }),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
