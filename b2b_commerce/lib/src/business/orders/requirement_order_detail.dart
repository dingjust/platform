import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/business/orders/quote_item.dart';
import 'package:b2b_commerce/src/business/orders/quote_order_detail.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/business/orders/requirement_quote_detail.dart';
import 'package:b2b_commerce/src/business/requirement_orders.dart';
import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:b2b_commerce/src/home/pool/requirement_quote_order_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

class RequirementOrderDetailPage extends StatefulWidget {
  String code;

  /// 关闭生产订单
  final RequirementOrderCancleCallback onRequirementCancle;

  RequirementOrderDetailPage(this.code, {Key key, this.onRequirementCancle})
      : super(key: key);

  _RequirementOrderDetailPageState createState() =>
      _RequirementOrderDetailPageState();
}

class _RequirementOrderDetailPageState
    extends State<RequirementOrderDetailPage> {
  static Map<RequirementOrderStatus, Color> _statusColors = {
    RequirementOrderStatus.PENDING_QUOTE: Color(0xFFFFD600),
    RequirementOrderStatus.COMPLETED: Colors.green,
    RequirementOrderStatus.CANCELLED: Colors.grey,
  };

  RequirementOrderModel orderModel;

  List<QuoteModel> quotesList;

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
        actions: <Widget>[
          Container(
            width: 60,
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: PopupMenuButton<String>(
              onSelected: (v) => onMenuSelect(v),
              icon: Icon(
                B2BIcons.more,
                size: 5,
              ),
              offset: Offset(0, 50),
              itemBuilder: (BuildContext context) => _buildPopupMenu(),
            ),
          )
        ],
      ),
      body: FutureBuilder<RequirementOrderModel>(
        builder: (BuildContext context,
            AsyncSnapshot<RequirementOrderModel> snapshot) {
          if (snapshot.data != null) {
            return Container(
              color: Colors.grey[100],
              child: ListView(
                children: <Widget>[
                  _buildCompanyInfo(),
                  _buildMain(),
                  //品牌端显示
                  UserBLoC.instance.currentUser.type == UserType.BRAND
                      ? _buildQuote()
                      : Container(),
                  _buildAttachments(),
                  _buildRemarks(),
                  _buildAddress(),
                  _buildHeader(),
                  _buildButtonGroups()
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

  Future<RequirementOrderModel> _getData() async {
    // 查询明细
    // 根据code查询明
    RequirementOrderModel detail = await RequirementOrderRepository()
        .getRequirementOrderDetail(widget.code);

    orderModel = detail;

    quotesList = await RequirementOrderRepository().getRequirementOrderQuotes(
      code: detail.code,
      page: 0,
      size: 1,
    );

    return detail;
  }

  Widget _buildCompanyInfo() {
    /// 工厂端显示
    if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                orderModel.belongTo.profilePicture == null
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
                      '${orderModel.belongTo.profilePicture.previewUrl()}',
                      fit: BoxFit.cover,
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
                            orderModel.belongTo == null ||
                                orderModel.belongTo == null
                                ? ''
                                : '${orderModel.belongTo.name}',
                            textScaleFactor: 1.3,
                          ),
                        ),
                        orderModel.belongTo == null ||
                            orderModel.belongTo.approvalStatus == null
                            ? Container()
                            : Container(
                            margin: EdgeInsets.only(top: 5),
                            color: Color.fromRGBO(254, 252, 235, 1),
                            child: orderModel.belongTo.approvalStatus !=
                                ArticleApprovalStatus.approved
                                ? Text('  未认证  ',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 133, 148, 1),
                                ))
                                : Text(
                              '  已认证  ',
                              style: TextStyle(
                                color: Color.fromRGBO(255, 133, 148, 1),
                              ),
                            ))
                      ],
                    ))
              ],
            ),
            Divider(
              height: 0,
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text('联系人'),
                    ),
                  ),
                  Container(
                    child: Text(
                      orderModel.details.contactPerson == null
                          ? ''
                          : '${orderModel.details.contactPerson}',
                      style: TextStyle(
                          color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 2,
            ),
            GestureDetector(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text('联系手机'),
                      ),
                    ),
                    Container(
                      child: Text(
                        orderModel.details.contactPhone == null
                            ? ''
                            : '${orderModel.details.contactPhone}',
                        style: TextStyle(
                            color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                orderModel.details.contactPhone == null
                    ? null
                    : _selectActionButton(orderModel.details.contactPhone);
              },
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildHeader() {
    return GestureDetector(
      onTap: () {
        copyToClipboard(orderModel.code);
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text('需求订单号：' + orderModel.code),
                    flex: 1,
                  ),
                  Text(
                    '复制',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                      '发布时间: ${orderModel.creationTime != null ? DateFormatUtil
                          .format(orderModel.creationTime) : ''}'),
                  flex: 1,
                ),
                UserBLoC.instance.currentUser.type == UserType.BRAND
                    ? Text(
                  '已报价 ${orderModel.totalQuotesCount != null ? orderModel
                      .totalQuotesCount : ''}',
                  style: TextStyle(fontSize: 15, color: Colors.red),
                )
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMain() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        children: <Widget>[
          Column(children: [
            _buildEntries(),
          ]),
          Divider(
            height: 0,
          ),
          InfoRow(
            label: '期望价格',
            value: Text(
              '￥${orderModel.details.maxExpectedPrice ?? 0}',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          Divider(
            height: 0,
          ),
          InfoRow(
            label: '加工类型',
            value: Text(
              orderModel.details.machiningType == null
                  ? ''
                  : MachiningTypeLocalizedMap[orderModel.details.machiningType],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Divider(
            height: 0,
          ),
          InfoRow(
            label: '交货时间',
            value: Text(
              '${DateFormatUtil.formatYMD(
                  orderModel.details.expectedDeliveryDate)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Divider(
            height: 0,
          ),
          InfoRow(
            label: '是否需要打样',
            value: Text(
              orderModel.details.proofingNeeded == null
                  ? ''
                  : orderModel.details.proofingNeeded ? '是' : '否',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Divider(
            height: 0,
          ),
          InfoRow(
            label: '是否提供样衣',
            value: Text(
              orderModel.details.samplesNeeded == null
                  ? ''
                  : orderModel.details.samplesNeeded ? '是' : '否',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          Divider(
            height: 0,
          ),
          InfoRow(
            label: '生产地区',
            value: GestureDetector(
              onTap: () {
                showDialog(
                    context: (context),
                    builder: (context) {
                      return SimpleDialog(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 5,
                            ),
                            child: Text(
                              orderModel.details?.productiveOrientations == null
                                  ? '选取'
                                  : formatAreaSelectsText(
                                  orderModel.details.productiveOrientations,
                                  orderModel.details.productiveOrientations
                                      .length),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      );
                    });
              },
              child: Text(
                orderModel.details?.productiveOrientations == null
                    ? '选取'
                    : formatAreaSelectsText(
                    orderModel.details.productiveOrientations, 2),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Divider(
            height: 0,
          ),
          InfoRow(
            label: '是否开票',
            value: Text(
              orderModel.details.invoiceNeeded == null
                  ? ''
                  : orderModel.details.invoiceNeeded ? '是' : '否',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            hasBottomBorder: false,
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildEntries() {
    Widget _pictureWidget;

    if (orderModel.details.pictures == null) {
      _pictureWidget = Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromRGBO(243, 243, 243, 1)),
        child: Icon(B2BIcons.noPicture,
            color: Color.fromRGBO(200, 200, 200, 1), size: 60),
      );
    } else {
      if (orderModel.details.pictures.isEmpty) {
        _pictureWidget = Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(243, 243, 243, 1)),
          child: Icon(B2BIcons.noPicture,
              color: Color.fromRGBO(200, 200, 200, 1), size: 60),
        );
      } else {
        _pictureWidget = GestureDetector(
          child: Stack(
            alignment: const Alignment(1.0, 1.1),
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                    width: 100,
                    height: 100,
                    imageUrl: '${orderModel.details.pictures[0].previewUrl()}',
                    fit: BoxFit.cover,
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
                  medias: orderModel.details.pictures,
                  isUpload: false,
                )));
          },
        );
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
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
                  orderModel.details.productName != null
                      ? Text(
                    orderModel.details.productName,
                    style: TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  )
                      : Text(
                    ' ',
                    style: TextStyle(fontSize: 15, color: Colors.red),
                  ),
                  orderModel.details.productSkuID != null
                      ? Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '货号：${orderModel.details.productSkuID}',
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
                      "${orderModel.details.majorCategoryName()}   ${orderModel
                          .details.category?.name}   ${orderModel.details
                          .expectedMachiningQuantity}件",
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

  String _majorCategory() {
    return orderModel.details.majorCategory != null
        ? orderModel.details.majorCategory.name
        : '';
  }

  Widget _buildQuote() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: quotesList != null && quotesList.length > 0
          ? Column(
        children: <Widget>[
          QuoteItem(
            model: quotesList[0],
            onRefresh: () {
              onRefreshData();
            },
            pageContext: context,
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      RequirementQuoteDetailPage(
                        order: orderModel,
                      )));
            },
            child: Text(
              '查看全部报价>>',
              style: TextStyle(color: Colors.red),
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

  onRefreshData() async {
    RequirementOrderBLoC().refreshData('ALL');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => RequirementOrdersPage()),
        ModalRoute.withName('/'));
  }

  Widget _buildAttachments() {
    return orderModel.attachments == null || orderModel.attachments.length <= 0
        ? Container()
        : Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '附件',
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          Attachments(
            list: orderModel.attachments,
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
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
          Row(
            children: <Widget>[Text(orderModel.remarks ?? '')],
          )
        ],
      ),
    );
  }

  Widget _buildAddress() {
    //工厂端显示
    if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      return Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: <Widget>[
                  Text(
                    '送货地址',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[Text(orderModel.deliveryAddress ?? '')],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildButtonGroups() {
    //品牌端显示
    if (UserBLoC.instance.currentUser.type == UserType.BRAND &&
        orderModel.status == RequirementOrderStatus.PENDING_QUOTE) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                  height: 30,
                  padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: FlatButton(
                      color: Colors.red,
                      child: Text(
                        '重新发布需求',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        onReview();
                      })),
            ),
            Expanded(
              child: Container(
                  height: 30,
                  padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: FlatButton(
                      color: Color(0xFFFFD600),
                      child: Text(
                        '邀请工厂报价',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FactoryPage(
                                FactoryCondition(
                                    starLevel: 0,
                                    adeptAtCategories: [],
                                    labels: [],
                                    cooperationModes: []),
                                requirementCode: orderModel.code,
                                route: '全部工厂',
                              )),
                        );
                      })),
            ),
          ],
        ),
      );
    } else if (UserBLoC.instance.currentUser.type == UserType.BRAND &&
        orderModel.status != RequirementOrderStatus.PENDING_QUOTE) {
      return Container(
        child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
            margin: EdgeInsets.only(bottom: 10),
            child: FlatButton(
                color: Colors.red,
                child: Text(
                  '重新发布需求',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                onPressed: () async {
                  onReview();
                })),
      );
    } else if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      return Container(
        child: Container(
          height: 30,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          margin: EdgeInsets.only(bottom: 20),
          child: FlatButton(
              onPressed: () async {
                QuoteModel newQuote =
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        RequirementQuoteOrderForm(
                          model: orderModel,
                          quoteModel: QuoteModel(attachments: []),
                        )));

                if (newQuote != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          QuoteOrderDetailPage(
                            newQuote.code,
                          )));
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '去报价',
                style: TextStyle(
                  color: Color.fromRGBO(36, 38, 41, 1),
                  fontSize: 16,
                ),
              )),
        ),
      );
    } else {
      return Container();
    }
  }

  List<PopupMenuItem<String>> _buildPopupMenu() {
    if (orderModel.editable != null &&
        orderModel.editable &&
        UserBLoC.instance.currentUser.type == UserType.BRAND &&
        orderModel.status == RequirementOrderStatus.PENDING_QUOTE) {
      return <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Icon(Icons.edit),
              ),
              Text('编辑')
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'close',
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Icon(Icons.close),
              ),
              Text('关闭')
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'share',
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Icon(Icons.share),
              ),
              Text('分享')
            ],
          ),
        ),
      ];
    } else {
      return <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: 'share',
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20),
                child: Icon(Icons.share),
              ),
              Text('分享')
            ],
          ),
        ),
      ];
    }
  }

  onMenuSelect(String value) async {
    switch (value) {
      case 'edit':
        onEdit();
        break;
      case 'close':
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.CONFIRM_DIALOG,
                contentText2: '确定关闭订单？',
                isNeedConfirmButton: true,
                isNeedCancelButton: true,
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                dialogHeight: 180,
                confirmAction: () async {
                  await widget.onRequirementCancle();
                  setState(() {
                    orderModel.status = RequirementOrderStatus.CANCELLED;
                  });
                  Navigator.of(context).pop();
                },
              );
            });
        break;
      case 'share':
        onShare();
        break;
      default:
    }
  }

  void onEdit() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequirementOrderFrom(
          order: orderModel,
        )));
  }

  ///TODO分享
  void onShare() {
    String title = '';
    String description =
        " ${orderModel.details.category?.name}   ${orderModel.details
        .expectedMachiningQuantity}件\n 交货时间:${DateFormatUtil.formatYMD(
        orderModel.details.expectedDeliveryDate)}";

    if (orderModel.details.productName != null &&
        orderModel.details.productName != '') {
      title = orderModel.details.productName;
    } else {
      title = orderModel.details.category.name;
    }

    ShareDialog.showShareDialog(context,
        title: '$title',
        description: '$description',
        imageUrl: orderModel.details.pictures.isEmpty
            ? '${GlobalConfigs.LOGO_URL}'
            : '${orderModel.details.pictures[0].previewUrl()}',
        url: Apis.shareRequirement(orderModel.code));
  }

  void onReview() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequirementOrderFrom(
          order: orderModel,
          isReview: true,
          isCreate: true,
        )));
  }

  //拨打电话或发短信
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

  //格式选中的地区（多选）
  String formatAreaSelectsText(List<RegionModel> selects, int count) {
    String text = '';

    for (int i = 0; i < selects.length; i++) {
      if (i > count - 1) {
        text += '...';
        break;
      }

      if (i == selects.length - 1) {
        text += selects[i].name;
      } else {
        text += selects[i].name + '、';
      }
    }

    return text;
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
