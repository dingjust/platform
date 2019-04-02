import 'package:b2b_commerce/src/home/pool/requirement_quote_order_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

class RequirementOrderDetailForFactory extends StatefulWidget {
  RequirementOrderModel model;

  RequirementOrderDetailForFactory({@required this.model});

  _RequirementOrderDetailForFactoryState createState() =>
      _RequirementOrderDetailForFactoryState();
}

class _RequirementOrderDetailForFactoryState
    extends State<RequirementOrderDetailForFactory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text('需求订单明细'),
      ),
      body: Container(
          color: Color(0xffF0F0F0),
          margin: EdgeInsets.only(bottom: 70),
          child: ListView(
            children: <Widget>[
              _buildTop(context),
              _buildBrandInfo(context),
              _buildContact(context),
              _buildRequirementInfo(context),
              _buildRemarks(context),
              _buildEnclosure(context),
              _buildDeliveryAddress(context),
//              _buildCommitButton(context),
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        icon: Container(
          width: 0,
          child: Icon(
            null,
            color: Colors.white,
          ),
        ),
        label: Container(
            width: 250,
            child: Center(
              child: Text(
                '去报价',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RequirementQuoteOrderForm(
                      model: widget.model,
                    )),
          );
        },
        backgroundColor: Colors.amberAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.white,
    );
  }

  Widget _buildTop(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '需求订单号：${widget.model.code}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Text(
                RequirementOrderStatusLocalizedMap[widget.model.status],
                style: TextStyle(
                  color: Colors.greenAccent,
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                '发布时间：${widget.model.creationTime}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBrandInfo(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(
                          '${widget.model.belongTo.profilePicture}'),
                      fit: BoxFit.cover,
                    )),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.model.belongTo.brand,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                          '已认证',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.deepOrange),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContact(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 1.5),
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20),
                    height: 45,
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: Color(0xffFF9516),
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.model.belongTo.contactPerson,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(left: 1.5),
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 20),
                      height: 45,
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Icon(
                              Icons.phone,
                              size: 20,
                              color: Color(0xffFF9516),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.model.belongTo.contactPhone,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _selectActionButton(widget.model.belongTo.contactPhone);
                    },
                  ),
                  flex: 1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRequirementInfo(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://gd3.alicdn.com/imgextra/i2/0/TB194socYrpK1RjSZTEXXcWAVXa_!!0-item_pic.jpg'),
                        fit: BoxFit.cover,
                      )),
                ),
                Container(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          widget.model.details.productName,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        child: Text(
                          '${widget.model.details.productSkuID}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          '${widget.model.details.majorCategoryName()} ${widget.model.details.category.name} ${widget.model.totalQuantity}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffFFBBFF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            child: ListTile(
              leading: Text(
                '期望价格',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Text(
                widget.model.details.maxExpectedPrice == null
                    ? ''
                    : '${widget.model.details.maxExpectedPrice}',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            child: ListTile(
              leading: Text(
                '加工类型',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Text(
                widget.model.details.machiningType == null
                    ? ''
                    : MachiningTypeLocalizedMap[
                        widget.model.details.machiningType],
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            child: ListTile(
              leading: Text(
                '交货时间',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Text(
                widget.model.details.expectedDeliveryDate == null
                    ? ''
                    : DateFormatUtil.formatYMD(
                        widget.model.details.expectedDeliveryDate),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            child: ListTile(
              leading: Text(
                '是否需要打样',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Text(
                widget.model.details.proofingNeeded == null
                    ? ''
                    : widget.model.details.proofingNeeded ? '是' : '否',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            child: ListTile(
              leading: Text(
                '是否提供样衣',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Text(
                widget.model.details.samplesNeeded == null
                    ? ''
                    : widget.model.details.samplesNeeded ? '是' : '否',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
          ),
          Divider(
            height: 1,
          ),
          Container(
            child: ListTile(
              leading: Text(
                '是否开票',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Text(
                widget.model.details.invoiceNeeded == null
                    ? ''
                    : widget.model.details.invoiceNeeded ? '是' : '否',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemarks(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "备注",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                widget.model.remarks,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )),
      ]),
    );
  }

  Widget _buildEnclosure(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "附件",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Attachments(
            list: widget.model.attachments,
          )
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "送货地址",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  widget.model.deliveryAddress.region.name +
                      widget.model.deliveryAddress.city.name +
                      widget.model.deliveryAddress.cityDistrict.name +
                      widget.model.deliveryAddress.line1,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCommitButton(BuildContext context) {
    return Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: RaisedButton(
          color: Colors.amberAccent,
          child: Text(
            '去报价',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RequirementQuoteOrderForm(
                        model: widget.model,
                      )),
            );
          },
        ));
  }

  void _selectActionButton(String tel) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('拨打电话'),
              onTap: () async {
                var url = 'tel:' + tel;
                await launch(url);
              },
            ),
            tel.indexOf('-') > -1
                ? Container()
                : ListTile(
                    leading: Icon(Icons.message),
                    title: Text('发送短信'),
                    onTap: () async {
                      var url = 'sms:' + tel;
                      await launch(url);
                    },
                  ),
          ],
        );
      },
    );
  }
}
