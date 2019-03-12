import 'package:b2b_commerce/src/business/orders/requirement_quote_detail.dart';
import 'package:b2b_commerce/src/home/factory/quick_reaction_factory.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class RequirementOrderDetailPage extends StatefulWidget {
  final RequirementOrderModel order;

  final List<QuoteModel> quotes;

  const RequirementOrderDetailPage(
      {Key key, @required this.order, @required this.quotes})
      : super(key: key);

  _RequirementOrderDetailPageState createState() =>
      _RequirementOrderDetailPageState();
}

class _RequirementOrderDetailPageState
    extends State<RequirementOrderDetailPage> {
  static Map<RequirementOrderStatus, MaterialColor> _statusColors = {
    RequirementOrderStatus.PENDING_QUOTE: Colors.green,
    RequirementOrderStatus.COMPLETED: Colors.orange,
    RequirementOrderStatus.CANCELLED: Colors.red
  };

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          '需求订单明细',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView(
          children: <Widget>[
            _buildMain(),
            _buildQuote(),
            _buildAttachments(),
            _buildRemarks(),
            _buildHeader(),
            _buildButtonGroups()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text('需求订单号：' + widget.order.code),
                  flex: 1,
                ),
                Text(
                  RequirementOrderStatusLocalizedMap[widget.order.status],
                  style: TextStyle(
                      fontSize: 15, color: _statusColors[widget.order.status]),
                )
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text('发布时间: ' +
                    DateFormatUtil.format(widget.order.creationTime)),
                flex: 1,
              ),
              Text(
                '已报价 ${widget.order.totalQuotesCount}',
                style: TextStyle(fontSize: 15, color: Colors.red),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMain() {
    String addressStr = "";

    if (widget.order.details.productiveOrientations != null) {
      widget.order.details.productiveOrientations.forEach((str) {
        addressStr = "${addressStr} ${str}";
      });
    }
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        children: <Widget>[
          Column(children: [
            _buildEntries(),
          ]),
          InfoRow(
            label: '期望价格',
            value: Text(
              '￥15.00',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          InfoRow(
            label: '加工类型',
            value: Text(
              widget.order.details.machiningType == null
                  ? ''
                  : MachiningTypeLocalizedMap[
                      widget.order.details.machiningType],
              style: TextStyle(fontSize: 16),
            ),
          ),
          InfoRow(
            label: '交货时间',
            value: Text(
              '${DateFormatUtil.formatYMD(widget.order.details.expectedDeliveryDate)}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          InfoRow(
            label: '是否需要打样',
            value: Text(
              widget.order.details.proofingNeeded == null
                  ? ''
                  : widget.order.details.proofingNeeded ? '是' : '否',
              style: TextStyle(fontSize: 16),
            ),
          ),
          InfoRow(
            label: '是否提供样衣',
            value: Text(
              widget.order.details.samplesNeeded == null
                  ? ''
                  : widget.order.details.samplesNeeded ? '是' : '否',
              style: TextStyle(fontSize: 16),
            ),
          ),
          InfoRow(
            label: '生产地区',
            value: Text(
              '${addressStr}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          InfoRow(
            label: '是否开票',
            value: Text(
              widget.order.details.invoiceNeeded == null
                  ? ''
                  : widget.order.details.invoiceNeeded ? '是' : '否',
              style: TextStyle(fontSize: 16),
            ),
            hasBottomBorder: false,
          ),
        ],
      ),
    );
  }

  Widget _buildEntries() {
    Widget _pictureWidget;

    if (widget.order.details.pictures == null) {
      _pictureWidget = Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromRGBO(243, 243, 243, 1)),
        child: Icon(
          B2BIcons.noPicture,
          color: Color.fromRGBO(200, 200, 200, 1),
          size: 25,
        ),
      );
    } else {
      if (widget.order.details.pictures.isEmpty) {
        _pictureWidget = Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(243, 243, 243, 1)),
          child: Icon(
            B2BIcons.noPicture,
            color: Color.fromRGBO(200, 200, 200, 1),
            size: 25,
          ),
        );
      } else {
        _pictureWidget = Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage(
                    '${GlobalConfigs.IMAGE_BASIC_URL}${widget.order.details.pictures[0].url}'),
                fit: BoxFit.cover,
              )),
        );
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          _pictureWidget,
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.order.details.productName != null
                      ? Text(
                          widget.order.details.productName,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          '暂无产品',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                  widget.order.details.productSkuID != null
                      ? Container(
                          padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '货号：${widget.order.details.productSkuID}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "${widget.order.details.majorCategory?.name}   ${widget.order.details.category?.name}   ${widget.order.details.expectedMachiningQuantity}件",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(255, 133, 148, 1)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuote() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: widget.quotes.isNotEmpty
          ? Column(
              children: <Widget>[
                QuoteItem(
                  model: widget.quotes[0],
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RequirementQuoteDetailPage(
                              order: widget.order,
                            )));
                  },
                  child: Text(
                    '查看全部报价>>',
                    style: TextStyle(color: Colors.orange),
                  ),
                )
              ],
            )
          : Center(
              child: Text(
                '暂无报价',
                style: TextStyle(color: Colors.grey),
              ),
            ),
    );
  }

  Widget _buildAttachments() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '附件',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            ],
          ),
          Attachments(
            list: widget.order.attachments,
          )
        ],
      ),
    );
  }

  Widget _buildRemarks() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              children: <Widget>[
                Text(
                  '备注',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[Text(widget.order.remarks ?? '')],
          )
        ],
      ),
    );
  }

  Widget _buildButtonGroups() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          width: 180,
          child: FlatButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: Text(
                '重新发布需求',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
          width: 180,
          child: FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuickReactionFactoryPage(
                            route: '全部工厂',
                          )),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 149, 22, 1),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              child: Text(
                '邀请工厂报价',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        )
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({Key key, this.label, this.value, this.hasBottomBorder = true})
      : super(key: key);

  final String label;
  final Widget value;
  final bool hasBottomBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      decoration: BoxDecoration(
          border: hasBottomBorder
              ? Border(bottom: BorderSide(width: 1, color: Colors.grey[300]))
              : null),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          value
        ],
      ),
    );
  }
}
