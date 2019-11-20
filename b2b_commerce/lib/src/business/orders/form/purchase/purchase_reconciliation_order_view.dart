import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'components/ColorSizeView.dart';

class ReconciliationOrderView extends StatefulWidget {
  final ReconciliationOrderNoteModel reconciliationOrder;

  final String purchaseOrderCode;

  const ReconciliationOrderView(
      {Key key, this.reconciliationOrder, this.purchaseOrderCode})
      : super(key: key);

  @override
  _ReconciliationOrderViewState createState() =>
      _ReconciliationOrderViewState();
}

class _ReconciliationOrderViewState extends State<ReconciliationOrderView>
    with SingleTickerProviderStateMixin {
  List<Widget> tabs = <Widget>[
    Tab(
      text: '对账单信息',
    ),
    Tab(
      text: '款项',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              title: Text(
                '对账单',
                style: TextStyle(color: Colors.black),
              ),
              bottom: TabBar(
                unselectedLabelColor: Colors.black26,
                labelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: tabs,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
            ),
            body: widget.reconciliationOrder != null
                ? Container(
                    color: Colors.white,
                    child: ListView(
                      children: <Widget>[
                        Container(
                            height: 550,
                            child: TabBarView(
                              children: <Widget>[
                                _buildDetailSection(widget.reconciliationOrder),
                                _buildMoneySection(widget.reconciliationOrder),
                              ],
                            )),
                        ColorSizeView(
                          entries: widget.reconciliationOrder.entries,
                        )
                      ],
                    ))
                : Center(
              child: Text('暂无对账单'),
                  )));
  }

  ///款项
  Widget _buildMoneySection(ReconciliationOrderNoteModel order) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          B2BInfoRow(
            hasBottomBorder: true,
            label: '延期扣款',
            value: Row(
              children: <Widget>[
                Text(
                  '-',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text('${order.delayDeduction}')
              ],
            ),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '扣款备注',
            value: Text('${order.delayDeductionRemarks}'),
          ),
          ItemDivider(),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '质量扣款',
            value: Row(
              children: <Widget>[
                Text(
                  '-',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text('${order.qualityDeduction}')
              ],
            ),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '扣款备注',
            value: Text('${order.qualityDeductionRemarks}'),
          ),
          ItemDivider(),
          B2BInfoRow(
              hasBottomBorder: true,
              label: '其他扣款',
              value: Row(
                children: <Widget>[
                  Text(
                    '-',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('${order.otherDeduction}'),
                ],
              )),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '扣款备注',
            value: Text('${order.otherDeductionRemarks}'),
          ),
          ItemDivider(),
          B2BInfoRow(
              hasBottomBorder: true,
              label: '其他增款',
              value: Row(
                children: <Widget>[
                  Text(
                    '+',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('${order.otherFunds}'),
                ],
              )),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '备注',
            value: Text('${order.otherFundsRemarks}'),
          ),
        ],
      ),
    );
  }

  ///对账单信息
  Widget _buildDetailSection(ReconciliationOrderNoteModel order) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          B2BInfoRow(
            hasBottomBorder: true,
            label: '甲方',
            value: Text('${order.partA}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '乙方',
            value: Text('${order.partB}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '品牌',
            value: Text('${order.brand ?? ''}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '款号',
            value: Text('${order.skuID ?? ''}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '加工方式',
            value:
                Text('${CooperationModeLocalizedMap[order.cooperationMethod]}'),
          ),
        ],
      ),
    );
  }
}

class ItemDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 10, color: Colors.grey[50]);
  }
}
