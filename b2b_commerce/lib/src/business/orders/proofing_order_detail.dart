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
  ProofingOrderDetailPage(this.code);

  final String code;

  _ProofingOrderDetailPageState createState() =>
      _ProofingOrderDetailPageState();
}

class _ProofingOrderDetailPageState extends State<ProofingOrderDetailPage> {
  ProofingModel model;

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
                      data: model.entries
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
    model = detailModel;
    return detailModel;
  }

  Widget _buildEntries() {
    //计算总数
    int sum = 0;
    model.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });

    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: <Widget>[
          model.product.thumbnail != null
              ? GestureDetector(
            child: Stack(
              alignment: const Alignment(0.6, 1.1),
              children: <Widget>[
                model.product != null &&
                    model.product.thumbnail != null &&
                    model.product.thumbnail.url != null
                    ? Container(
                  margin: EdgeInsets.only(right: 15),
                  padding: EdgeInsets.fromLTRB(0, 10, 15, 0),
                  width: 80,
                  height: 80,
                  child: CachedNetworkImage(
                      width: 100,
                      height: 100,
                      imageUrl:
                      '${model.product.thumbnail.previewUrl()}',
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                          ),
                      placeholder: (context, url) =>
                          SpinKitRing(
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
                  builder: (context) =>
                      PicturePickPreviewWidget(
                        medias: model.product.thumbnails,
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
                    model.product.name,
                    style: TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      '货号：${model.product.skuID}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      " ${model.product.category.name}   ${sum}件",
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
    model.entries.forEach((entry) {
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
                  '￥${model.totalPrice}',
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
          Text('${model.remarks == null ? '' : model.remarks}')
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
                Icons.location_on,
                color: Colors.black,
              ),
              title: Row(
                children: <Widget>[
                  model.deliveryAddress == null ||
                      model.deliveryAddress.fullname == null
                      ? Container()
                      : Text(model.deliveryAddress.fullname),
                  model.deliveryAddress == null ||
                      model.deliveryAddress.cellphone == null
                      ? Container()
                      : Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(model.deliveryAddress.cellphone),
                  )
                ],
              ),
              subtitle: model.deliveryAddress == null ||
                  model.deliveryAddress.region == null ||
                  model.deliveryAddress.city == null ||
                  model.deliveryAddress.cityDistrict == null ||
                  model.deliveryAddress.line1 == null
                  ? Container()
                  : Text(
                  model.deliveryAddress.region.name +
                      model.deliveryAddress.city.name +
                      model.deliveryAddress.cityDistrict.name +
                      model.deliveryAddress.line1,
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
                          '${model.consignment != null &&
                              model.consignment.carrierDetails != null &&
                              model.consignment.carrierDetails.name != null
                              ? model.consignment.carrierDetails.name
                              : ''}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Container(
                        child: Text(
                          '${model.consignment != null &&
                              model.consignment.carrierDetails != null &&
                              model.consignment.trackingID != null ? model
                              .consignment.trackingID : ''}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              onTap: () {
                if (model.consignment != null &&
                    model.consignment.carrierDetails != null &&
                    model.consignment.trackingID != null &&
                    model.consignment.carrierDetails.name != null) {
                  copyToClipboard(model.consignment.trackingID);
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
        ).then((value) {
          if (value != null) {
            setState(() {
              _getData();
            });
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return RequestDataLoading(
                    requestCallBack: ProofingOrderRepository()
                        .updateAddress(model.code, model),
                    outsideDismiss: false,
                    loadingText: '保存中。。。',
                    entrance: '0',
                  );
                }).then((value) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return CustomizeDialog(
                      dialogType: DialogType.RESULT_DIALOG,
                      successTips: '地址修改成功',
                      failTips: '地址修改失败',
                      callbackResult: value,
                      confirmAction: () {
                        Navigator.of(context).pop();
                      },
                    );
                  });
            });
          }
        })
            : null;
        ProofingOrdersBLoC().refreshData('ALL');
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
                  model.supplier == null ||
                      model.supplier.profilePicture == null
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
                        '${model.supplier.profilePicture.previewUrl()}',
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) =>
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                        placeholder: (context, url) =>
                            SpinKitRing(
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
                  ),
                  Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            child: Text(
                              '${model.supplier == null ||
                                  model.supplier.name == null ? '' : model
                                  .supplier.name}',
                              textScaleFactor: 1.3,
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              color: Color.fromRGBO(254, 252, 235, 1),
                              child: model.supplier.approvalStatus ==
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
          if (model.belongTo != null) {
            //TODO跳转详细页
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyFactoryPage(
                          factoryUid: model.belongTo.uid,
                          isFactoryDetail: true,
                        )));
          } else {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return CustomizeDialog(
                    dialogType: DialogType.CONFIRM_DIALOG,
                    contentText2: '该订单没有工厂信息',
                    isNeedConfirmButton: true,
                    confirmButtonText: '确定',
                    dialogHeight: 180,
                  );
                });
          }
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
                            model.belongTo.name,
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
                                starLevel: model.belongTo.starLevel ?? 1,
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
                            '${model.belongTo.historyOrdersCount == null
                                ? ''
                                : model.belongTo.historyOrdersCount}',
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
                            '${model.belongTo.contactAddress?.city
                                ?.name} ${model.belongTo.contactAddress
                                ?.cityDistrict?.name}',
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
    return GestureDetector(
      onTap: () {
        copyToClipboard(model.code);
      },
      child: Container(
        color: Colors.white,
        height: 100,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '打样单号：${model.code}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Text(
                  '复制',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            Text(
              '发布时间：${DateFormatUtil.format(model.creationTime)}',
              style: TextStyle(color: Colors.black),
            ),
            model.requirementOrderRef != null
                ? Text(
              '需求订单号：${model.requirementOrderRef}',
              style: TextStyle(color: Colors.black),
            )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _buildButtonGroup() {
    List<Widget> buttons;
    //品牌端显示
    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
      if (model.status == ProofingStatus.PENDING_PAYMENT) {
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
                        order: model,
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
      } else if (model.status == ProofingStatus.SHIPPED) {
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
                  _onProofingConfirm(model);
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
      if (model.status == ProofingStatus.PENDING_PAYMENT) {
        buttons = [
          Container(
            height: 30,
            child: FlatButton(
                onPressed: onUpdate,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 140),
                child: Text(
                  '修改订单',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          ),
        ];
      } else if (model.status == ProofingStatus.PENDING_DELIVERY) {
        buttons = <Widget>[
          Container(
            height: 30,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LogisticsInputPage(
                      isProductionOrder: false,
                      proofingModel: model,
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

  void _onProofingConfirm(ProofingModel model) async {
    bool result =
    await ProofingOrderRepository().proofingConfirm(model.code, model);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            successTips: '确认成功',
            failTips: '确认失败',
            callbackResult: result,
            confirmAction: () {
              Navigator.of(context).pop();
            },
          );
        });
    ProofingOrdersBLoC.instance.refreshData('ALL');
    Navigator.of(context).pop();
  }

  copyToClipboard(final String text) {
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              successTips: '复制成功',
              callbackResult: true,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
  }

  void onCancelling() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            dialogHeight: 210,
            contentText2: '是否取消订单？',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmAction: () {
              Navigator.of(context).pop();
              cancelOrder(model);
            },
          );
        });
  }

  void cancelOrder(ProofingModel model) async {
    String response =
    await ProofingOrderRepository().proofingCancelling(model.code);
    if (response != null) {
      ProofingOrdersBLoC.instance.refreshData('ALL');
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '取消失败',
              callbackResult: false,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
  }

  void onUpdate() async {
    //查询明细
    ProofingModel detailModel =
    await ProofingOrderRepository().proofingDetail(model.code);

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
