import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'components/progress_abbreviation_table.dart';
import 'components/progress_full_table.dart';
import 'components/progress_orders_table.dart';
import 'production_progress_order_detail.dart';
import 'production_progress_order_form.dart';

class ProductionProgressDetailPage extends StatefulWidget {
  const ProductionProgressDetailPage({Key key}) : super(key: key);

  _ProductionProgressDetailPageState createState() =>
      _ProductionProgressDetailPageState();
}

class _ProductionProgressDetailPageState
    extends State<ProductionProgressDetailPage> {
  final GlobalKey globalKey = GlobalKey();
  double tableWidth = 0;
  double tableHeight = 0;
  bool showAllOrders = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductionProgressState>(
      builder: (context, ProductionProgressState state, _) =>
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0.5,
              title: Text(
                  '${ProductionProgressPhaseLocalizedMap[state.progress
                      .phase]}'),
              backgroundColor: Constants.THEME_COLOR_MAIN,
            ),
            body: Container(
              color: Constants.THEME_COLOR_BACKGROUND,
              child: ListView(
                children: <Widget>[
                  _buildInfoBlock(state),
                  _buildTableBlock(state),
                  _buildMediasBlock(state),
                  _buildRemarksBlock(state),
                  _buildReadOrderBtn(),
                  _buildProgressOrdersBlock(state),
                  _buildBtn(state)
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildInfoBlock(ProductionProgressState state) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  '预计完成时间：${DateFormatUtil.formatYMD(
                      state.progress.estimatedDate)}'),
              Text(
                state.progress.delayedDays != 0
                    ? '已延期${state.progress.delayedDays}天'
                    : '',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text('款号：${state.order.product.skuID ?? ''}'),
          ),
          Text('合作商：${state.order.cooperator.getName()}')
        ],
      ),
    );
  }

  Widget _buildTableBlock(ProductionProgressState state) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ProgressFullTable(
                    entries: state.order.entries,
                    productionProgressOrders:
                    state.progress.productionProgressOrders,
                  )));
        },
        child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  key: globalKey,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: ProgressAbbreviationTable(
                    entries: state.order.entries,
                    productionProgressOrders:
                    state.progress.productionProgressOrders,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 5,
                  child: Icon(
                    Icons.loupe,
                    size: 25,
                    color: Colors.grey,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildMediasBlock(ProductionProgressState state) {
    //整合全部单据图片
    List<MediaModel> attachments = [];
    state.progress.productionProgressOrders
        .where((order) => order.status != ProductionProgressOrderStatus.CANCEL)
        .forEach((order) {
      attachments.addAll(order.medias);
    });

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('上传图片：'),
          Expanded(
              flex: 1,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    Attachments(
                      list: attachments,
                      width: constraints.maxWidth,
                    ),
              ))
        ],
      ),
    );
  }

  Widget _buildRemarksBlock(ProductionProgressState state) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('备注：'),
          Expanded(flex: 1, child: Text('${state.progress.remarks ?? ''}'))
        ],
      ),
    );
  }

  Widget _buildReadOrderBtn() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: FlatButton(
        onPressed: () {
          setState(() {
            showAllOrders = !showAllOrders;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(showAllOrders ? '收起所有单据' : '查看所有上报单据'),
            Icon(showAllOrders ? Icons.arrow_drop_up : Icons.arrow_drop_down)
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOrdersBlock(ProductionProgressState state) {
    return showAllOrders
        ? Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ProgressOrdersTable(
        productionProgressOrders: state.progress.productionProgressOrders,
        onDetail: _onOrderDetail,
      ),
    )
        : Container();
  }

  Widget _buildBtn(ProductionProgressState state) {
    if (UserBLoC.instance.currentUser.type != UserType.FACTORY ||
        state.order.currentPhase != state.progress.phase) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      child: FlatButton(
        color: Color.fromRGBO(255, 214, 12, 1),
        child: Text(
          '上报数量',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ProductionProgressOrderForm(
                    order: state.order,
                    progress: state.progress,
                  )));
        },
      ),
    );
  }

  void _onOrderDetail(ProductionProgressOrderModel model) {
    final state = Provider.of<ProductionProgressState>(context);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductionProgressOrderDetailPage(model: model)));
  }
}
