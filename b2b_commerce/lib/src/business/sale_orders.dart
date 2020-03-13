import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/orders/purchase/purchase_order_list.dart';
import '../_shared/widgets/app_bar_factory.dart';
import '../_shared/widgets/tab_factory.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_PAYMENT', '待付款'),
  EnumModel('IN_PRODUCTION', '代发货'),
  EnumModel('WAIT_FOR_OUT_OF_STORE', '待收货'),
  EnumModel('OUT_OF_STORE', '退款/售后'),
];

class SaleOrdersPage extends StatefulWidget {
  _SaleOrdersPageState createState() => _SaleOrdersPageState();
}

class _SaleOrdersPageState extends State<SaleOrdersPage>
    with AutomaticKeepAliveClientMixin {
  List<String> historyKeywords;

  // Widget _buildSearchButton() {
  //   return IconButton(
  //     icon: const Icon(B2BIcons.search, size: 20),
  //     onPressed: () {
  //       showDialog(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (_) {
  //             return RequestDataLoading(
  //               requestCallBack:
  //                   LocalStorage.get(GlobalConfigs.SALE_HISTORY_KEYWORD_KEY),
  //               outsideDismiss: false,
  //               loadingText: '加载中。。。',
  //               entrance: '',
  //             );
  //           }).then((value) {
  //         if (value != null && value != '') {
  //           List<dynamic> list = json.decode(value);
  //           historyKeywords = list.map((item) => item as String).toList();
  //         } else {
  //           historyKeywords = [];
  //         }
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => SearchModelPage(
  //               searchModel: SearchModel(
  //                 historyKeywords: historyKeywords,
  //                 searchModelType: SearchModelType.SALE_ORDER,
  //                 route: GlobalConfigs.SALE_HISTORY_KEYWORD_KEY,
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    PurchaseOrderBLoC.instance.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<PurchaseOrderBLoC>(
      bloc: PurchaseOrderBLoC.instance,
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar(
          '销售订单',
          // actions: <Widget>[_buildSearchButton()],
        ),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(statuses, scrollable: true),
            body: TabBarView(
              children: statuses
                  .map((status) => PurchaseOrderList(status: status))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
