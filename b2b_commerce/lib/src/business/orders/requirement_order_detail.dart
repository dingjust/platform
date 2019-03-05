import 'package:b2b_commerce/src/business/orders/requirement_quote_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class RequirementOrderDetailPage extends StatefulWidget {
  // final String code;
  final RequirementOrderModel order;

  const RequirementOrderDetailPage({Key key, this.order}) : super(key: key);

  _RequirementOrderDetailPageState createState() =>
      _RequirementOrderDetailPageState();
}

class _RequirementOrderDetailPageState
    extends State<RequirementOrderDetailPage> {
  QuoteModel quoteModel = QuoteModel.fromJson({
    "code": "34938475200045",
    "creationtime": DateTime.now().toString(),
    "belongTo": {"name": "广州好辣制衣厂", "starLevel": 3},
    "state": "BUYER_REJECTED",
    "totalPrice": 360.00,
    "deliveryAddress": {
      "region": {"name": "广东"},
      "city": {"name": "广州"},
      "cityDistrict": {"name": "白云"}
    }
  });

  static Map<RequirementOrderStatus, MaterialColor> _statusColors = {
    RequirementOrderStatus.PENDING_QUOTE: Colors.green,
    RequirementOrderStatus.COMPLETED: Colors.orange,
    RequirementOrderStatus.CANCELLED: Colors.red
  };

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
            _buildHeader(),
            _buildMain(),
            _buildQuote(),
            _buildAttachments(),
            _buildRemarks(),
            _buildButton()
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
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
                '已报价 6',
                style: TextStyle(fontSize: 15, color: Colors.red),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMain() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: <Widget>[
          Column(
            children: [
              _buildEntries(),
            ]
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '共${widget.order.details.expectedMachiningQuantity}件商品',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )
            ],
          ),
          InfoRow(
            label: '加工类型',
            value: Text(
              widget.order.details.machiningType == null ? '' : MachiningTypeLocalizedMap[widget.order.details.machiningType],
              style: TextStyle(fontSize: 16),
            ),
          ),
          InfoRow(
            label: '是否开具发票',
            value: Text(
              '否',
              style: TextStyle(fontSize: 16),
            ),
          ),
          InfoRow(
            label: '期望价格',
            value: Text(
              '￥15.00',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          InfoRow(
            label: '预计交货时间',
            value: Text(
              '${DateFormatUtil.format(widget.order.details.expectedDeliveryDate)}',
              style: TextStyle(fontSize: 16),
            ),
            hasBottomBorder: false,
          )
        ],
      ),
    );
  }

  Widget _buildEntries() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image:widget.order.details.pictures != null && widget.order.details.pictures.isNotEmpty
                      ? NetworkImage(widget.order.details.pictures[0].url)
                      : AssetImage(
                    'temp/picture.png',
                    package: "assets",
                  ),
                  fit: BoxFit.cover,
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.order.details.productName != null
                      ? Text(
                    widget.order.details.productName,
                    style: TextStyle(fontSize: 15),
                  )
                      : Text(
                    '暂无产品',
                    style: TextStyle(
                        fontSize: 15, color: Colors.red),
                  ),
                  widget.order.details.productSkuID != null
                      ? Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      '货号：' + widget.order.details.productSkuID,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey),
                    ),
                  )
                      : Container(),
                  Text(
                    '生产单价：￥ ${widget.order.details.maxExpectedPrice}',
                    style: TextStyle(color: Colors.red),
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
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          QuoteItem(
            model: quoteModel,
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      RequirementQuoteDetailPage()));
            },
            child: Text(
              '查看全部报价>>',
              style: TextStyle(color: Colors.orange),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAttachments() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
            children: <Widget>[Text(widget.order.remarks)],
          )
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: RaisedButton(
          onPressed: () {},
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Color.fromRGBO(255, 149, 22, 1),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Text(
            '重新发布需求',
            style: TextStyle(color: Colors.white, fontSize: 16),
          )),
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
