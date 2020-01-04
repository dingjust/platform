import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ColorSizeView extends StatelessWidget {
  final List<OrderNoteEntryModel> entries;

  final int rowHeith;

  const ColorSizeView({Key key, this.entries, this.rowHeith = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = [];
    List<List<OrderNoteEntryModel>> tabEntries = [];
    //初始化按颜色分组
    Map<String, List<OrderNoteEntryModel>> dataMap = {};
    entries.forEach((entry) {
      if (dataMap[entry.color] == null) {
        dataMap[entry.color] = [];
      }
      dataMap[entry.color].add(entry);
    });

    dataMap.forEach((key, list) {
      tabs.add(Tab(
        text: '$key',
      ));
      tabEntries.add(list);
    });

    return Container(
        height: _getContainerHeight(dataMap),
        child: DefaultTabController(
          length: tabEntries.length,
          child: Scaffold(
              appBar: TabBar(
                tabs: tabs,
                isScrollable: true,
              ),
              body: TabBarView(
                children: tabEntries
                    .map((entries) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.white,
                          child: Column(
                              children: entries
                                  .map((entry) => B2BInfoRow(
                                        label: '${entry.size}',
                                        value: Text('${entry.quantity}'),
                                      ))
                                  .toList()),
                        ))
                    .toList(),
              )),
        ));
  }

  double _getContainerHeight(Map<String, List<OrderNoteEntryModel>> dataMap) {
    int maxLength = 0;
    dataMap.forEach((key, list) {
      if (list.length > maxLength) {
        maxLength = list.length;
      }
    });
    return (rowHeith * maxLength).toDouble() + 50;
  }
}
