import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'components/progress_abbreviation_table.dart';
import 'components/progress_full_table.dart';

class ProductionProgressDetailPage extends StatefulWidget {
  final PurchaseOrderModel order;

  final ProductionProgressModel progress;

  const ProductionProgressDetailPage({Key key, this.order, this.progress})
      : super(key: key);

  _ProductionProgressDetailPageState createState() =>
      _ProductionProgressDetailPageState();
}

class _ProductionProgressDetailPageState extends State<ProductionProgressDetailPage> {
  final GlobalKey globalKey = GlobalKey();
  double tableWidth = 0;
  double tableHeight = 0;

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
      color: Colors.white,
      child: FlatButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>
                  ProgressFullTable(
                    entries: widget.order.entries,
                    productionProgressOrders: widget.progress
                        .productionProgressOrders,
                  )));
        },
        child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  key: globalKey,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: ProgressAbbreviationTable(
                    entries: widget.order.entries,
                    productionProgressOrders:
                    widget.progress.productionProgressOrders,
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
                // FutureBuilder<BuildContext>(
                //   future: _getTableContext(),
                //   builder:
                //       (BuildContext context, AsyncSnapshot<BuildContext> snapshot) {
                //     if (tableHeight == 0 && tableWidth == 0) {
                //       _getTableContext();
                //       return Container();
                //     } else {
                //       return Container(
                //         width: tableWidth,
                //         height: tableHeight,
                //         color: Color.fromRGBO(0, 0, 0, 0.2),
                //         child: Center(
                //             child: FlatButton(
                //           onPressed: () {},
                //           child: Container(
                //             color: Colors.white60,
                //             padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                //             child: Text('编辑'),
                //           ),
                //         )),
                //       );
                //     }
                //   },
                // )
              ],
            )),
      ),
    );
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

// Future<BuildContext> _getTableContext() async {
//   Future.delayed(Duration(milliseconds: 100)).then((e) {
//     if (globalKey.currentContext == null) {
//       return _getTableContext();
//     } else {
//       tableWidth = globalKey.currentContext.size.width;
//       tableHeight = globalKey.currentContext.size.height;
//       return globalKey.currentContext;
//     }
//   });
// }
}
