import 'package:b2b_commerce/main.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class PublishRequirementSuccessDialog extends StatefulWidget {
  final RequirementOrderModel model;

  const PublishRequirementSuccessDialog({Key key, this.model})
      : super(key: key);

  _PublishRequirementSuccessDialogState createState() =>
      _PublishRequirementSuccessDialogState();
}

class _PublishRequirementSuccessDialogState
    extends State<PublishRequirementSuccessDialog> {
  bool _isSelected = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: Color.fromRGBO(245, 245, 245, 1)),
        child: ListView(
          children: <Widget>[
            _buildTitle(),
            _buildOrderInfo(),
            _buildButtonGroup(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              // color: Colors.white,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 50, 20),
                      child: Icon(
                        B2BIcons.publish_requirement_success,
                        size: 100,
                        color: Color.fromRGBO(255, 214, 12, 1),
                      ),
                    ),
                    Text(
                      '需求发布成功!',
                      style: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(255, 214, 12, 1)),
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }

  Widget _buildOrderInfo() {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  RequirementOrderDetailPage(order: widget.model)));
        },
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Text('需求订单号: ${widget.model.code}'),
            ),
            _buildEntries(),
            Container(
              width: double.infinity,
              color: Color.fromRGBO(250, 250, 250, 1),
              padding: EdgeInsets.all(10),
              child: Text(
                '交货时间: ${DateFormatUtil.formatYMD(widget.model.details.expectedDeliveryDate)}',
                style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
              ),
            ),
          ],
        ));
  }

  Widget _buildEntries() {
    Widget _pictureWidget;

    if (widget.model.details.pictures == null) {
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
      if (widget.model.details.pictures.isEmpty) {
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
                    '${GlobalConfigs.IMAGE_BASIC_URL}${widget.model.details.pictures[0].url}'),
                fit: BoxFit.cover,
              )),
        );
      }
    }

    return Container(
      color: Color.fromRGBO(250, 250, 250, 1),
      padding: EdgeInsets.all(10),
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
                  widget.model.details.productName != null
                      ? Text(
                          widget.model.details.productName,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          '暂无产品',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                  widget.model.details.productSkuID != null
                      ? Container(
                          padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '货号：${widget.model.details.productSkuID}',
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
                      "${widget.model.details.majorCategory?.name}   ${widget.model.details.category?.name}   ${widget.model.totalQuantity}件",
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

  Widget _buildCheckLine() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Checkbox(
                  onChanged: (v) {
                    setState(() {
                      _isSelected = v;
                    });
                  },
                  value: _isSelected,
                ),
                Text(
                  '将需求信息发到需求池',
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildButtonGroup() {
    return Container(
        margin: EdgeInsets.only(top: 100),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: double.infinity,
              height: 45,
              child: FlatButton(
                onPressed: () {
                  //TODO:工厂列表
                },
                color: Color.fromRGBO(255, 214, 12, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  '邀请工厂',
                  style: TextStyle(
                      color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: double.infinity,
              height: 45,
              child: FlatButton(
                onPressed: () {},
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color.fromRGBO(255, 45, 45, 1)),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  '完善需求',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 45, 45, 1), fontSize: 18),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: double.infinity,
              height: 45,
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyApp()));
                },
                color: Color.fromRGBO(255, 245, 193, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  '回到首页',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 169, 0, 1), fontSize: 18),
                ),
              ),
            ),
          ],
        ));
  }
}
