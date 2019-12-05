import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'components/progress_abbreviation_table.dart';
import 'components/progress_order_full_table.dart';

class ProductionProgressOrderDetailPage extends StatefulWidget {
  final PurchaseOrderModel order;

  final ProductionProgressModel progress;

  final ProductionProgressOrderModel model;

  const ProductionProgressOrderDetailPage(
      {Key key, this.order, this.progress, this.model})
      : super(key: key);

  _ProductionProgressOrderDetailPageState createState() =>
      _ProductionProgressOrderDetailPageState();
}

class _ProductionProgressOrderDetailPageState
    extends State<ProductionProgressOrderDetailPage> {
  final GlobalKey globalKey = GlobalKey();
  double tableWidth = 0;
  double tableHeight = 0;
  bool showAllOrders = false;

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
            _buildBtnRow()
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
              Text('单号：${widget.model.id}'),
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
          Text('上报时间：${DateFormatUtil.formatYMD(widget.model.reportTime)}'),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('上报人员：${widget.model.operator.name}'),
          )
        ],
      ),
    );
  }

  Widget _buildTableBlock() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProgressOrderFullTable(
                    entries: widget.order.entries,
                    order: widget.model,
                  )));
        },
        child: Container(
            child: Stack(
          children: <Widget>[
            Container(
              key: globalKey,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SingleProgressAbbreviationTable(
                entries: widget.order.entries,
                order: widget.model,
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

  Widget _buildMediasBlock() {
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
                  list: widget.model.medias,
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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('备注：'),
          Expanded(flex: 1, child: Text('${widget.model.remarks ?? ''}'))
        ],
      ),
    );
  }

  Widget _buildBtnRow() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: FlatButton(
                color: Color.fromRGBO(255, 214, 12, 1),
                child: Text(
                  '作废',
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
            ),
            Container(
              width: 50,
            ),
            Expanded(
              flex: 1,
              child: FlatButton(
                color: Color.fromRGBO(255, 214, 12, 1),
                child: Text(
                  '修改',
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
            )
          ],
        ));
  }
}
