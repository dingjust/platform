import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_select_list.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ContractPurchaseOrderSelectPage extends StatefulWidget {
  ContractPurchaseOrderSelectPage({
    Key key,
    this.models,
  }) : super(key: key);
  List<PurchaseOrderModel> models;

  _ContractPurchaseOrderSelectPageState createState() =>
      _ContractPurchaseOrderSelectPageState();
}

class _ContractPurchaseOrderSelectPageState extends State<ContractPurchaseOrderSelectPage> {
  final GlobalKey _globalKey = GlobalKey<_ContractPurchaseOrderSelectPageState>();
  String _keyword = '';
  List<PurchaseOrderModel> _models = [];
  PurchaseOrderListState purchaseOrderState;

  @override
  void initState() {
    if (widget.models != null) {
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
          ChangeNotifierProvider(builder: (_) => PurchaseOrderListState()),
        ],
        child: Consumer<PurchaseOrderListState>(
            builder: (context, PurchaseOrderListState purchaseOrderState, _) {
          purchaseOrderState.queryFormData['statuses'] = [
            'PENDING_PAYMENT',
            'IN_PRODUCTION',
            'WAIT_FOR_OUT_OF_STORE',
            'OUT_OF_STORE',
            'COMPLETED',
          ];
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
                                  .PURCHASE_ORDER_SELECT_HISTORY_KEYWORD_KEY,
                              hintText: '请输入订单号，产品名称，合作商，款号搜索',
                              keyword: _keyword,
                            ),
                          ),
                        );

                        if (result != null) {
                          purchaseOrderState.queryFormData['keyword'] = result;
                          _keyword = result;
                          purchaseOrderState.clear();
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
                            _keyword == '' ? '请输入订单号，产品名称，合作商，款号搜索' : _keyword,
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
                  child: purchaseOrderState.purchaseOrderModels != null
                      ? PurchaseOrderSelectList(
                    purchaseOrderState: purchaseOrderState,
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
                onPressed: () async{
                  if(_models == null || _models.length == 0){
                    ShowDialogUtil.showValidateMsg(context, '请勾选订单');
                    return;
                  }
                  List<String> orderCodes = _models.map((model) => model.code).toList();
                  //合同订单验证
                  SearchResultModel searchResultModel = await ContractRepository().validateContractOrders(data: {
                    'orderCodes': orderCodes,
                    'type': 'WTSCHT',
                    'isPdfAgreement': false,
                  });
                  print(searchResultModel);
                  if(searchResultModel.code == 1){
                    Navigator.pop(context, _models);
                  }else{
                    ShowDialogUtil.showValidateMsg(context, searchResultModel?.msg);
                  }
                },
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
