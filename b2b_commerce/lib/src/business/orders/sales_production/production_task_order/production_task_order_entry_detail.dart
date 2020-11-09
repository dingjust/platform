import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/_shared/widgets/order_contracts_info.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 生产工单详情页
class ProductionTaskOrderEntryDetailPage extends StatefulWidget {
  int id;

  ProductionTaskOrderEntryDetailPage({Key key, @required this.id})
      : super(key: key);

  _ProductionTaskOrderEntryDetailPageState createState() =>
      _ProductionTaskOrderEntryDetailPageState();
}

class _ProductionTaskOrderEntryDetailPageState
    extends State<ProductionTaskOrderEntryDetailPage> {
  SalesProductionOrderModel order;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SalesProductionOrderModel>(
      builder: (BuildContext context,
          AsyncSnapshot<SalesProductionOrderModel> snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('生产工单明细'),
              backgroundColor: Constants.THEME_COLOR_MAIN,
              elevation: 0.5,
            ),
            body: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: ListView(
                  children: <Widget>[
                    _MainInfo(
                        order: order.taskOrderEntries[0], saleOrder: order)
                  ],
                )),
          );
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      initialData: null,
      future: _getData(),
    );
  }

  Future<SalesProductionOrderModel> _getData() async {
    if (order == null) {
      SalesProductionOrderModel detailModel =
          await ProductionTaskOrderRespository().getOrderDetail(widget.id);
      order = detailModel;
    }
    return order;
  }
}

class _MainInfo extends StatelessWidget {
  final ProductionTaskOrderModel order;

  final SalesProductionOrderModel saleOrder;

  const _MainInfo({Key key, this.order, this.saleOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _buildProductRow(),
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: ColorSizeEntryTable(
                  data: order.colorSizeEntries,
                  compareFunction: Provider.of<SizeState>(context).compare,
                ),
              ),
              buildRow('生产数量', '${order.quantity}'),
              buildRow(
                  '合作方式', CooperationModeLocalizedMap[order.cooperationMode]),
              buildRow('交货日期', DateFormatUtil.formatYMD(order.deliveryDate)),
              AddressInfoBlock(
                model: order.shippingAddress,
              ),
            ],
          ),
        ),
        _partnerInfo(saleOrder),
        _staffInfo(order, saleOrder),
        OrderContractsBlock(agreements: saleOrder.agreements)
      ],
    );
  }

  Widget _partnerInfo(SalesProductionOrderModel saleOrder) {
    CooperatorModel cooperator = getCooperator(saleOrder);

    return cooperator != null
        ? Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            color: Colors.white,
            child: Column(children: <Widget>[
              Row(children: [
                Text('合作商信息', style: TextStyle(color: Colors.grey))
              ]),
              buildRow('客户',
                  '${cooperator.type == CooperatorType.ONLINE ? cooperator.partner.name : cooperator.name}'),
              buildRow('联系人',
                  '${cooperator.type == CooperatorType.ONLINE ? cooperator.partner.contactPerson : cooperator.contactPerson}'),
              buildRow('联系电话',
                  '${cooperator.type == CooperatorType.ONLINE ? cooperator.partner.contactPhone : cooperator.contactPhone}'),
            ]),
          )
        : Container();
  }

  CooperatorModel getCooperator(SalesProductionOrderModel saleOrder) {
    CooperatorModel cooperator;

    var companyCode = UserBLoC.instance.currentUser.companyCode;
    // 来源自己的情况
    if (saleOrder.originCompany != null &&
        saleOrder.originCompany.uid == companyCode) {
      cooperator = saleOrder.targetCooperator;
    }
    // 外接的情况
    if (saleOrder.originCooperator != null) {
      cooperator = saleOrder.originCooperator;
    }
    return cooperator;
  }

  Widget _staffInfo(
      ProductionTaskOrderModel order, SalesProductionOrderModel saleOrder) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: Column(children: <Widget>[
        Row(children: [Text('人员设置', style: TextStyle(color: Colors.grey))]),
        buildRow('跟单员', '${order?.merchandiser?.name}'),
        buildRow('审批人',
            '${saleOrder.approvers != null ? saleOrder.approvers[0].name : ''}')
      ]),
    );
  }

  Widget _buildProductRow({double height = 80.0}) {
    return Padding(
      // padding: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: [
          Hero(
              tag: 'productHero${order.code}',
              child: ImageFactory.buildThumbnailImage(order?.product?.thumbnail,
                  containerSize: height)),
          Expanded(
              child: Container(
            height: height,
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.product.name,
                  style: TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '货号：${order.product.skuID}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 243, 243, 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '品类：${order.product.category.name}',
                    style: TextStyle(
                        fontSize: 15, color: Color.fromRGBO(255, 133, 148, 1)),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget buildRow(String title, String val) {
    if (val == null || val == '') {
      return Container();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text('$title'), Text('$val')],
      ),
    );
  }
}
