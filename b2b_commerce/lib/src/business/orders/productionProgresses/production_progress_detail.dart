import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'package:core/core.dart';
import 'package:widgets/widgets.dart';

import 'components/progress_abbreviation_table.dart';

class ProductionProgressDetailPage extends StatefulWidget {
  final PurchaseOrderModel order;

  final ProductionProgressModel progress;

  const ProductionProgressDetailPage({Key key, this.order, this.progress})
      : super(key: key);

  _ProductionProgressDetailPageState createState() =>
      _ProductionProgressDetailPageState();
}

class _ProductionProgressDetailPageState
    extends State<ProductionProgressDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text(
            '${ProductionProgressPhaseLocalizedMap[widget.progress.phase]}'),
        backgroundColor: Constants.THEME_COLOR_MAIN,
      ),
      body: Container(
        color: Constants.THEME_COLOR_BACKGROUND,
        child: ListView(
          children: <Widget>[
            _buildInfoBlock(),
            _buildTableBlock(),
            _buildMediasBlock(),
            _buildRemarksBlock(),
            _buildBtn()
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBlock() {
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
                  '预计完成时间：${DateFormatUtil.formatYMD(widget.progress.estimatedDate)}'),
              Text(
                widget.progress.delayedDays != 0
                    ? '已延期${widget.progress.delayedDays}天'
                    : '',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text('款号：${widget.order.product.skuID ?? ''}'),
          ),
          Text('合作商：${widget.order.cooperator.getName()}')
        ],
      ),
    );
  }

  Widget _buildTableBlock() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        color: Colors.white,
        child: ProgressAbbreviationTable(
          entries: widget.order.entries,
          productionProgressOrders: widget.progress.productionProgressOrders,
        ));
  }

  Widget _buildMediasBlock() {
    //整合全部单据图片
    List<MediaModel> attachments = [];
    widget.progress.productionProgressOrders
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

  Widget _buildRemarksBlock() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('备注：'),
          Expanded(flex: 1, child: Text('${widget.progress.remarks}'))
        ],
      ),
    );
  }

  Widget _buildBtn() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
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
        onPressed: () {},
      ),
    );
  }
}
