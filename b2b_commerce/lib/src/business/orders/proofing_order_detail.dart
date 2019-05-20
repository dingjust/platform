import 'package:b2b_commerce/src/business/orders/form/proofing_order_form.dart';
import 'package:b2b_commerce/src/common/logistics_input_page.dart';
import 'package:b2b_commerce/src/common/order_payment.dart';
import 'package:b2b_commerce/src/my/my_addresses.dart';
import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProofingOrderDetailPage extends StatefulWidget {
  ProofingOrderDetailPage(this.code, {Key key, this.model}) : super(key: key);

  ProofingModel model;

  final String code;

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
      body: FutureBuilder<ProofingModel>(
        builder: (BuildContext context, AsyncSnapshot<ProofingModel> snapshot) {
          if (snapshot.data != null) {
            return Container(
              color: Color.fromRGBO(245, 245, 245, 1),
              child: ListView(
                children: <Widget>[
//            _buildCompanyInfo(),
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
                  _buildBrandInfo(context),
                  _buildFactory(),
                  _buildOrderInfoRow(),
                  _buildButtonGroup(),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        initialData: null,
        future: _getData(),
      ),
    );
  }

  Future<ProofingModel> _getData() async {
    // 查询明细
    ProofingModel detailModel =
        await ProofingOrderRepository().proofingDetail(widget.code);
    widget.model = detailModel;
    return detailModel;
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
          widget.model.product.thumbnail != null
              ? GestureDetector(
                  child: Stack(
                    alignment: const Alignment(0.6, 1.1),
                    children: <Widget>[
                      widget.model.product != null &&
                              widget.model.product.thumbnail != null &&
                              widget.model.product.thumbnail.url != null
                          ? Container(
                              margin: EdgeInsets.only(right: 15),
                              padding: EdgeInsets.fromLTRB(0, 10, 15, 0),
                              width: 80,
                              height: 80,
                              child: CachedNetworkImage(
                                  width: 100,
                                  height: 100,
                                  imageUrl:
                                      '${widget.model.product.thumbnail.previewUrl()}',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => SpinKitRing(
                                        color: Colors.black12,
                                        lineWidth: 2,
                                        size: 30,
                                      ),
                                  errorWidget: (context, url, error) =>
                                      SpinKitRing(
                                        color: Colors.black12,
                                        lineWidth: 2,
                                        size: 30,
                                      )),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(right: 15),
                              padding: EdgeInsets.fromLTRB(0, 10, 15, 0),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'temp/picture.png',
                                      package: "assets",
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                      Container(
                        child: Icon(
                          Icons.photo_size_select_actual,
                          color: Colors.black38,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PicturePickPreviewWidget(
                              medias: widget.model.product.thumbnails,
                              isUpload: false,
                            )));
                  },
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
                      " ${widget.model.product.category.name}   ${sum}件",
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
          Text('${widget.model.remarks == null ? '' : widget.model.remarks}')
        ],
      ),
    );
  }

  //构建收货信息UI
  Widget _buildDeliveryAddress(BuildContext context) {
    return GestureDetector(
      child: Container(
//      padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                B2BIcons.location,
                color: Colors.black,
              ),
              title: Row(
                children: <Widget>[
                  widget.model.deliveryAddress == null ||
                          widget.model.deliveryAddress.fullname == null
                      ? Container()
                      : Text(widget.model.deliveryAddress.fullname),
                  widget.model.deliveryAddress == null ||
                          widget.model.deliveryAddress.cellphone == null
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(widget.model.deliveryAddress.cellphone),
                        )
                ],
              ),
              subtitle: widget.model.deliveryAddress == null ||
                      widget.model.deliveryAddress.region == null ||
                      widget.model.deliveryAddress.city == null ||
                      widget.model.deliveryAddress.cityDistrict == null ||
                      widget.model.deliveryAddress.line1 == null
                  ? Container()
                  : Text(
                      widget.model.deliveryAddress.region.name +
                          widget.model.deliveryAddress.city.name +
                          widget.model.deliveryAddress.cityDistrict.name +
                          widget.model.deliveryAddress.line1,
                      style: TextStyle(
                        color: Colors.black,
                      )),
            ),
            SizedBox(
              child: Image.asset(
                'temp/common/address_under_line.png',
                package: 'assets',
                fit: BoxFit.fitWidth,
              ),
            ),
            GestureDetector(
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      '物流信息',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${widget.model.consignment != null && widget.model.consignment.carrierDetails != null && widget.model.consignment.carrierDetails.name != null ? widget.model.consignment.carrierDetails.name : ''}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        child: Text(
                          '${widget.model.consignment != null && widget.model.consignment.carrierDetails != null && widget.model.consignment.trackingID != null ? widget.model.consignment.trackingID : ''}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              onTap: () {
                if (widget.model.consignment != null &&
                    widget.model.consignment.carrierDetails != null &&
                    widget.model.consignment.trackingID != null &&
                    widget.model.consignment.carrierDetails.name != null) {
                  copyToClipboard(widget.model.consignment.trackingID);
                } else {
                  null;
                }
              },
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {
        UserBLoC.instance.currentUser.type == UserType.BRAND
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyAddressesPage(isJumpSource: true)),
                //接收返回数据并处理
              ).then((value) async {
                if (value != null) {
                  setState(() {
                    widget.model.deliveryAddress = value;
                  });
                  bool result = await ProofingOrderRepository()
                      .updateAddress(widget.model.code, widget.model);
                  _showMessage(context, result, '地址修改');
                }
              })
            : null;
      },
    );
  }

  //品牌信息UI
  Widget _buildBrandInfo(BuildContext context) {
    if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      return Container(
          margin: EdgeInsets.only(top: 10),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  widget.model.supplier == null ||
                          widget.model.supplier.profilePicture == null
                      ? Container(
                          margin: EdgeInsets.all(10),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(
                                  'temp/picture.png',
                                  package: "assets",
                                ),
                                fit: BoxFit.cover,
                              )),
                        )
                      : Container(
                          margin: EdgeInsets.all(10),
                          width: 80,
                          height: 80,
                          child: CachedNetworkImage(
                              width: 100,
                              height: 100,
                              imageUrl:
                                  '${widget.model.supplier.profilePicture.previewUrl()}',
                              fit: BoxFit.cover,
                              placeholder: (context, url) => SpinKitRing(
                                    color: Colors.black12,
                                    lineWidth: 2,
                                    size: 30,
                                  ),
                              errorWidget: (context, url, error) => SpinKitRing(
                                    color: Colors.black12,
                                    lineWidth: 2,
                                    size: 30,
                                  )),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                  Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          '${widget.model.supplier == null || widget.model.supplier.name == null ? '' : widget.model.supplier.name}',
                          textScaleFactor: 1.3,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          color: Color.fromRGBO(254, 252, 235, 1),
                          child: widget.model.supplier.approvalStatus ==
                                  ArticleApprovalStatus.approved
                              ? Text('  已认证  ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 133, 148, 1),
                                  ))
                              : Text(
                                  '  未认证  ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 133, 148, 1),
                                  ),
                                ))
                    ],
                  ))
                ],
              ),
            ],
          ));
    } else {
      return Container();
    }
  }

  _buildFactory() {
    //品牌端显示
    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
      return GestureDetector(
        onTap: () async {
          //TODO跳转详细页
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyFactoryPage(
                        widget.model.belongTo,
                        isFactoryDetail: true,
                      )));
        },
        child: Container(
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
                            '${widget.model.belongTo.historyOrdersCount == null ? '' : widget.model.belongTo.historyOrdersCount}',
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
          Container(
            height: 30,
            child: FlatButton(
                onPressed: onCancelling,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Color.fromRGBO(255, 70, 70, 1),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                child: Text(
                  '取消订单',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          ),
          Container(
            height: 30,
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderPaymentPage(
                            order: widget.model,
                          )));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Color.fromRGBO(255, 214, 12, 1),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 45),
                child: Text(
                  '  去支付  ',
                  style: TextStyle(
                      color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                )),
          ),
        ];
      } else if (widget.model.status == ProofingStatus.SHIPPED) {
        buttons = <Widget>[
          // FlatButton(
          //     onPressed: () {},
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(5)),
          //     color: Color.fromRGBO(150, 150, 150, 1),
          //     padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          //     child: Text(
          //       '查看物流',
          //       style: TextStyle(
          //           color: Color.fromRGBO(150, 150, 150, 1), fontSize: 16),
          //     )),
          Container(
            height: 30,
            child: FlatButton(
                onPressed: () async {
                  bool result = false;
                  result = await ProofingOrderRepository()
                      .shipped(widget.model.code);
                  _showMessage(context, result, '确认收货');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Color(0xFFFFD600),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 150),
                child: Text(
                  '确认收货',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )),
          ),
        ];
      } else {
        return Container();
      }
    } //工厂端显示
    else if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      if (widget.model.status == ProofingStatus.PENDING_PAYMENT) {
        buttons = [
          Container(
            height: 30,
            child: FlatButton(
                onPressed: onUpdate,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 140),
                child: Text(
                  '修改订单',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          ),
        ];
      } else if (widget.model.status == ProofingStatus.PENDING_DELIVERY) {
        buttons = <Widget>[
          Container(
            height: 30,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LogisticsInputPage(
                          isProductionOrder: false,
                          proofingModel: widget.model,
                        )));
              },
              color: Color(0xFFFFD600),
              child: Text(
                '确认发货',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 140),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
            ),
          ),
        ];
      }
      // else if (model.status == ProofingStatus.SHIPPED) {
      //   buttons = [
      //     Container(),
      //     FlatButton(
      //         onPressed: () {},
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(5)),
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

  copyToClipboard(final String text) {
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              '提示',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('复制成功'),
              ),
            ],
          );
        },
      );
    }
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
        await QuoteOrderRepository().getQuoteDetails(detailModel.quoteRef);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProofingOrderForm(
              quoteModel: quoteModel,
              model: detailModel,
              update: true,
            )));
  }

  void _showMessage(BuildContext context, bool result, String message) {
    _requestMessage(context, result == true ? '${message}成功' : '${message}失败');
  }

  Future<void> _requestMessage(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            '提示',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('${message}'),
            ),
          ],
        );
      },
    );
  }
}
