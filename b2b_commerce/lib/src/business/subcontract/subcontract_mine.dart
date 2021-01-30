import 'package:b2b_commerce/src/_shared/subcontract/subcontract_mine_list.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class SubContractMinePage extends StatefulWidget {
  SubContractMinePage({
    Key key,
  }) : super(key: key);

  _SubContractMinePageState createState() => _SubContractMinePageState();
}

class _SubContractMinePageState extends State<SubContractMinePage> {
  final GlobalKey _globalKey = GlobalKey<_SubContractMinePageState>();
  List<EnumModel> tabs = <EnumModel>[
    EnumModel('ALL', '全部'),
    EnumModel('PUBLISHED', '已发布'),
    EnumModel('CANCELLED', '已关闭'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubContractMineState()),
      ],
      child: Consumer<SubContractMineState>(
          builder: (context, SubContractMineState subContractMineState, _) {
        return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0.5,
                brightness: Brightness.light,
                iconTheme: IconThemeData(color: Colors.black),
                centerTitle: true,
                title: Text(
                  '我的发布',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: Scaffold(
                appBar: TabBar(
                  onTap: (v) {
                    subContractMineState.key = v.toString();
                  },
                  unselectedLabelColor: Colors.black26,
                  labelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: tabs
                      .map((tab) => Tab(
                            text: tab.name,
                          ))
                      .toList(),
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                ),
                body: TabBarView(
                  children: tabs
                      .map((tab) =>
                  subContractMineState.subcontractModelsByMap != null
                      ? SubContractMineList(
                    subcontractMineState: subContractMineState,
                  )
                      : Center(
                    child: CircularProgressIndicator(),
                  ))
                      .toList(),
                ),
              ),
            ));
      }),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
