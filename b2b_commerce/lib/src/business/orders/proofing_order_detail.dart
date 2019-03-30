import 'package:b2b_commerce/src/business/orders/form/proofing_order_form.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

class ProofingOrderDetailPage extends StatefulWidget {
  const ProofingOrderDetailPage({Key key, this.model}) : super(key: key);

  final ProofingModel model;

  _ProofingOrderDetailPageState createState() =>
      _ProofingOrderDetailPageState();
}

class _ProofingOrderDetailPageState extends State<ProofingOrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          '打样订单明细',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        child: ListView(
          children: <Widget>[
            _buildCompanyInfo(),
            _buildEntries(),
            _buildNumRow(),
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: ColorSizeNumTable(
                data: widget.model.entries
                    .map((entry) => ApparelSizeVariantProductEntry(
                        quantity: entry.quantity, model: entry.product))
                    .toList(),
              ),
            ),
            _buildCostRow(),
            _buildRemarks(),
            _buildDeliveryAddress(context),
            _buildFactory(),
            _buildOrderInfoRow(),
            _buildButtonGroup(),
          ],
        ),
      ),
    );
  }

  Widget _buildEntries() {
    //计算总数
    int sum = 0;
    widget.model.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: <Widget>[
          widget.model.entries[0].product.thumbnail != null
              ? Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(
                            widget.model.entries[0].product.thumbnail.url),
                        fit: BoxFit.cover,
                      )),
                )
              : Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromRGBO(243, 243, 243, 1)),
                  child: Icon(B2BIcons.noPicture,
                      color: Color.fromRGBO(200, 200, 200, 1), size: 60),
                ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.model.entries[0].product.name,
                    style: TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '货号：${widget.model.entries[0].product.skuID}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "${widget.model.entries[0].product.name}   ${widget.model.entries[0].product.category.name}   ${sum}件",
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

  Widget _buildNumRow() {
    //计算总数
    int sum = 0;
    widget.model.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '样衣数量',
            style:
                TextStyle(fontSize: 18, color: Color.fromRGBO(50, 50, 50, 1)),
          ),
          Text(
            'x${sum}',
            style:
                TextStyle(fontSize: 18, color: Color.fromRGBO(255, 68, 68, 1)),
          )
        ],
      ),
    );
  }

  Widget _buildCostRow() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '样衣费用',
            style:
                TextStyle(fontSize: 18, color: Color.fromRGBO(50, 50, 50, 1)),
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  '￥${widget.model.totalPrice}',
                  style: TextStyle(
                      fontSize: 18, color: Color.fromRGBO(255, 68, 68, 1)),
                ),
              ),
              FlatButton(
                color: Color.fromRGBO(255, 149, 22, 1),
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  '查看报价',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRemarks() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(
            color: Color.fromRGBO(200, 200, 200, 1),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '备注',
              style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
            ),
          ),
          Text('${widget.model.remarks}')
        ],
      ),
    );
  }

  //构建收货信息UI
  Widget _buildDeliveryAddress(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              B2BIcons.location,
              color: Colors.black,
            ),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text('${widget.model.deliveryAddress?.fullname}'),
                ),
                Expanded(
                    child: Text('${widget.model.deliveryAddress?.cellphone}'))
              ],
            ),
            subtitle: Text(
                '${widget.model.deliveryAddress?.region?.name}${widget.model.deliveryAddress?.city?.name}${widget.model.deliveryAddress?.cityDistrict?.name}${widget.model.deliveryAddress?.line1}',
                style: TextStyle(
                  color: Colors.black,
                )),
            trailing: Icon(Icons.chevron_right),
          ),
          SizedBox(
            child: Image.asset(
              'temp/common/address_under_line.png',
              package: 'assets',
              fit: BoxFit.fitWidth,
            ),
          ),
          ListTile(
            title: Text("物流信息"),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildCompanyInfo() {
    /// 工厂端显示
    if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      return GestureDetector(
        onTap: () {
          //TODO跳转详细页
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          margin: EdgeInsets.only(bottom: 10),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[300]))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(widget
                                              .model.supplier?.profilePicture !=
                                          null
                                      ? '${GlobalConfigs.IMAGE_BASIC_URL}${widget.model.supplier?.profilePicture}'
                                      : 'http://img.jituwang.com/uploads/allimg/150305/258852-150305121F483.jpg')),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget.model.supplier?.name}',
                                style: TextStyle(
                                    color: Color.fromRGBO(36, 38, 41, 1)),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromRGBO(229, 242, 255, 1),
                                ),
                                padding: EdgeInsets.all(2),
                                child: Text(
                                  '已认证',
                                  style: TextStyle(
                                      color: Color.fromRGBO(22, 141, 255, 1)),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 35,
                      color: Color.fromRGBO(180, 180, 180, 1),
                    )
                  ],
                ),
              ),
              InfoRow(
                label: '联系人',
                value: Text(
                  '${widget.model.supplier?.contactPerson}',
                  style: TextStyle(
                      color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                ),
              ),
              InfoRow(
                  label: '联系手机',
                  hasBottomBorder: false,
                  value: Row(
                    children: <Widget>[
                      Text(
                        '${widget.model.supplier?.contactPhone}',
                        style: TextStyle(
                            color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                      ),
                      Container(
                        child: IconButton(
                          onPressed: () {
                            //TODO调用拨打电话API
                          },
                          icon: Icon(
                            Icons.phone,
                            color: Color.fromRGBO(86, 194, 117, 1),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  _buildFactory() {
    //品牌端显示
    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
      return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 15),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 15, 0, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.model.belongTo.name,
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Stars(
                              starLevel: widget.model.belongTo.starLevel ?? 1,
                              highlightOnly: false,
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                            )
                          ],
                        ))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text('历史接单'),
                        Text(
                          widget.model.belongTo.historyOrdersCount.toString(),
                          style: TextStyle(color: Colors.red),
                        ),
                        Text('单')
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '${widget.model.belongTo.contactAddress?.city?.name} ${widget.model.belongTo.contactAddress?.cityDistrict?.name}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildOrderInfoRow() {
    return Container(
      color: Colors.white,
      height: 100,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '打样单号：${widget.model.code}',
            style: TextStyle(color: Colors.black),
          ),
          Text(
            '发布时间：${DateFormatUtil.format(widget.model.creationTime)}',
            style: TextStyle(color: Colors.black),
          ),
          Text(
            '需求订单号：${widget.model.requirementOrderRef}',
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget _buildButtonGroup() {
    List<Widget> buttons;
    //品牌端显示
    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
      if (widget.model.status == ProofingStatus.PENDING_PAYMENT) {
        buttons = <Widget>[
          FlatButton(
              onPressed: onCancelling,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 70, 70, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '取消订单',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
          FlatButton(
              onPressed: () {
                WechatServiceImpl.instance.pay(widget.model.code);
                // WechatServiceImpl.instance.shareText('asdad');
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 214, 12, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '  去支付  ',
                style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
              )),
        ];
      } else if (widget.model.status == ProofingStatus.SHIPPED) {
        buttons = <Widget>[
          // FlatButton(
          //     onPressed: () {},
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(20)),
          //     color: Color.fromRGBO(150, 150, 150, 1),
          //     padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          //     child: Text(
          //       '查看物流',
          //       style: TextStyle(
          //           color: Color.fromRGBO(150, 150, 150, 1), fontSize: 16),
          //     )),
          Container(),
          FlatButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 245, 193, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '确认收货',
                style: TextStyle(
                    color: Color.fromRGBO(255, 169, 0, 1), fontSize: 16),
              )),
        ];
      } else {
        return Container();
      }
    } //工厂端显示
    else if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      if (widget.model.status == ProofingStatus.PENDING_PAYMENT) {
        buttons = [
          Container(
            height: 40,
            width: 250,
            child: FlatButton(
                onPressed: onUpdate,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color.fromRGBO(255, 45, 45, 1)),
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  '修改订单',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
                )),
          )
        ];
      } else if (widget.model.status == ProofingStatus.PENDING_DELIVERY) {
        buttons = <Widget>[
          Container(
            height: 40,
            width: 250,
            child: FlatButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Color.fromRGBO(255, 245, 193, 1),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Text(
                  '确认发货',
                  style: TextStyle(
                      color: Color.fromRGBO(255, 169, 0, 1), fontSize: 16),
                )),
          ),
        ];
      }
      // else if (model.status == ProofingStatus.SHIPPED) {
      //   buttons = [
      //     Container(),
      //     FlatButton(
      //         onPressed: () {},
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(20)),
      //         color: Color.fromRGBO(150, 150, 150, 1),
      //         padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      //         child: Text(
      //           '查看物流',
      //           style: TextStyle(
      //               color: Color.fromRGBO(150, 150, 150, 1), fontSize: 16),
      //         )),
      //   ];
      // }
      else {
        return Container();
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, children: buttons),
    );
  }

  void onCancelling() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('确认取消？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                String response = await ProofingOrderRepository()
                    .proofingCancelling(widget.model.code);
                if (response != null) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Text('取消失败')],
                          ),
                        ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void onUpdate() async {
    //查询明细
    ProofingModel detailModel =
        await ProofingOrderRepository().proofingDetail(widget.model.code);

    QuoteModel quoteModel =
        await QuoteOrderRepository().getquoteDetail(detailModel.quoteRef);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProofingOrderForm(
              quoteModel: quoteModel,
              model: detailModel,
              update: true,
            )));
  }
}
