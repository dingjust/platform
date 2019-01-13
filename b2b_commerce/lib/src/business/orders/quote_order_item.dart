import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'quote_order_detail.dart';

class QuoteOrderItem extends StatelessWidget {
  final QuoteEntryModel item;

  const QuoteOrderItem({Key key, this.item}) : super(key: key);

  static Map<QuoteState, MaterialColor> _statesColor = {
    QuoteState.SELLER_SUBMITTED: Colors.green,
    QuoteState.BUYER_APPROVED: Colors.blue,
    QuoteState.BUYER_REJECTED: Colors.red
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuoteOrderDetailPage(item: item),
          ),
        );
      },
      child: Card(
        elevation: 0.5,
        margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildEntry(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 30),
            child: Text("工厂：" + item.order.belongTo.name),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Text('报价：'),
                Text(
                  item.order.totalPrice.toString(),
                  style: TextStyle(color: Colors.red),
                ),
                Text('元'),
              ],
            ),
          ),
          Text(
            QuoteStateLocalizedMap[item.order.state],
            style: TextStyle(
              color: _statesColor[item.order.state],
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntry(){
    return  Container(
      color: Colors.grey[50],
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('报价单号：' + item.order.code),
                ),
                Text('报价时间：' +
                    item.order.creationTime
                        .toString()
                        .substring(0, 10)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              '需求订单号：' + item.order.requirementOrderCode,
            ),
          ),

          _buildProduct(),

          _buildActionChip(),

        ],
      ),
    );
  }

  Widget _buildProduct(){
    return Row(
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: item.product.thumbnail != null
                    ? NetworkImage(item.product.thumbnail)
                    : AssetImage(
                  'temp/picture.png',
                  package: "assets",
                ),
                fit: BoxFit.cover,
              )),
        ),
        Expanded(
          child: Container(
            padding:
            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                item.product?.name != null
                    ? Text(
                  item.product.name,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  //overflow: TextOverflow.ellipsis,
                )
                    : Text(
                  '暂无产品',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
                item.product?.skuID != null
                    ? Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 1, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '货号：' + item.product.skuID,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                )
                    : Container(),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 1, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    item.product.majorCategory.name +
                        "," +
                        item.product.minorCategory.name +
                        "," +
                        item.order.totalQuantity.toString() +
                        '件',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionChip(){
    return Offstage(
      offstage: item.order.state != QuoteState.SELLER_SUBMITTED
          ? true
          : false,
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 70, right: 20),
              child: ActionChip(
                backgroundColor: Colors.red,
                labelPadding: EdgeInsets.symmetric(
                    vertical: 2, horizontal: 13),
                labelStyle: TextStyle(fontSize: 18),
                label: Text('拒绝报价'),
                onPressed: () {},
              ),
            ),
            ActionChip(
              backgroundColor: Colors.orange,
              labelPadding: EdgeInsets.symmetric(
                  vertical: 2, horizontal: 13),
              labelStyle: TextStyle(fontSize: 18),
              label: Text('确认报价'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
