import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'components/ColorSizeView.dart';

class DeliverOrderView extends StatefulWidget {
  final DeliveryOrderNoteModel deliveryOrder;

  const DeliverOrderView({Key key, this.deliveryOrder}) : super(key: key);

  @override
  _DeliverOrderViewState createState() => _DeliverOrderViewState();
}

class _DeliverOrderViewState extends State<DeliverOrderView>
    with SingleTickerProviderStateMixin {
  List<Widget> tabs = <Widget>[
    Tab(
      text: '发货单信息',
    ),
    Tab(
      text: '发货人',
    ),
    Tab(
      text: '收货人',
    )
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
                '收货单',
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
            body: widget.deliveryOrder != null
                ? Container(
                    color: Colors.white,
                    child: ListView(
                      children: <Widget>[
                        Container(
                            height: 365,
                            child: TabBarView(
                              children: <Widget>[
                                _buildDetailSection(widget.deliveryOrder),
                                _buildConsignorSection(widget.deliveryOrder),
                                _buildConsigneeSection(widget.deliveryOrder),
                              ],
                            )),
                        ColorSizeView(
                          entries: widget.deliveryOrder.entries,
                        )
                      ],
                    ))
                : Center(
                    child: Text('暂无收货单'),
                  )));
  }

  ///发货人
  Widget _buildConsignorSection(DeliveryOrderNoteModel order) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          B2BInfoRow(
            hasBottomBorder: true,
            label: '发货人',
            value: Text('${order.consignorName}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '联系方式',
            value: Text('${order.consignorPhone}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '发货方式',
            value: Text('${order?.consignment?.carrierDetails?.name ?? '无'}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '发货单号',
            value: Text('${order?.consignment?.trackingID ?? '无'}'),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('是否线下发货'),
                      Text(
                        '选择线下发货可不填方式和单号',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      )
                    ],
                  ),
                ),
                Text('${order.isOfflineConsignment ?? false ? '是' : '否'}')
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///发货单信息
  Widget _buildDetailSection(DeliveryOrderNoteModel order) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          B2BInfoRow(
            hasBottomBorder: true,
            label: '品牌',
            value: Text('${order.brand}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '款号',
            value: Text('${order.skuID ?? ''}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '退料',
            value: Text('${order.withdrawalQuality ?? ''}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '残次品数',
            value: Text('${order.defectiveQuality ?? ''}'),
          ),
        ],
      ),
    );
  }

  ///收货人
  Widget _buildConsigneeSection(DeliveryOrderNoteModel order) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          B2BInfoRow(
            hasBottomBorder: true,
            label: '收货人',
            value: Text('${order.consigneeName}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '联系方式',
            value: Text('${order.consigneePhone ?? ''}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '收货地址',
            value: Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  '${order.consigneeAddress}',
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
