import 'package:b2b_commerce/src/business/orders/quote_item.dart';
import 'package:b2b_commerce/src/business/orders/quote_order_detail.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/business/orders/requirement_quote_detail.dart';
import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:b2b_commerce/src/home/pool/requirement_quote_order_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
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
  static Map<RequirementOrderStatus, Color> _statusColors = {
    RequirementOrderStatus.PENDING_QUOTE: Color(0xFFFFD600),
    RequirementOrderStatus.COMPLETED: Colors.green,
    RequirementOrderStatus.CANCELLED: Colors.grey,
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
        actions: <Widget>[
          widget.order.editable != null &&
                  widget.order.editable &&
              UserBLoC.instance.currentUser.type == UserType.BRAND
              ? Container(
              width: 60,
              margin: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 10),
              child: FlatButton(
                  color: Color(0xFFFFD600),
                  child: Text(
                    '修改',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  onPressed: onEdit
              )
          ) : Container()
        ],
      ),
      body: Container(
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
      ),
    );
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
                widget.order.belongTo.profilePicture == null?
                Container(
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
                ):
                Container(
                  margin: EdgeInsets.all(10),
                  width: 80,
                  height: 80,
                  child: CachedNetworkImage(
                      width: 100,
                      height: 100,
                      imageUrl: '${widget.order.belongTo.profilePicture.previewUrl()}',
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
                          )
                  ),
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
                        widget.order.belongTo == null ||
                                widget.order.belongTo == null
                            ? ''
                            : '${widget.order.belongTo.name}',
                        textScaleFactor: 1.3,
                      ),
                    ),
                    widget.order.belongTo == null ||
                            widget.order.belongTo.approvalStatus == null
                        ? Container()
                        : Container(
                            margin: EdgeInsets.only(top: 5),
                            color: Color.fromRGBO(254, 252, 235, 1),
                            child: widget.order.belongTo.approvalStatus !=
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
              height: 1,
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
                      widget.order.belongTo.contactAddress?.fullname == null
                          ? ''
                          : '${widget.order.belongTo.contactAddress.fullname}',
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
                        widget.order.belongTo.contactAddress.cellphone == null
                            ? ''
                            : '${widget.order.belongTo.contactAddress.cellphone}',
                        style: TextStyle(
                            color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                widget.order.belongTo.contactAddress.cellphone == null
                    ? null
                    : _selectActionButton(
                        widget.order.belongTo.contactAddress.cellphone);
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
    return Container(
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
              UserBLoC.instance.currentUser.type == UserType.BRAND
                  ? Text(
                      '已报价 ${widget.order.totalQuotesCount}',
                      style: TextStyle(fontSize: 15, color: Colors.red),
                    )
                  : Container()
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
        addressStr = "${addressStr} ${str.name}";
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
              '￥${widget.order.details.maxExpectedPrice ?? 0}',
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
        child: Icon(B2BIcons.noPicture,
            color: Color.fromRGBO(200, 200, 200, 1), size: 60),
      );
    } else {
      if (widget.order.details.pictures.isEmpty) {
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
                    imageUrl: '${widget.order.details.pictures[0].previewUrl()}',
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
                        )
                ),
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
                      medias: widget.order.details.pictures,
                      isUpload: false,
                    )));
          },
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
                          ' ',
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
                      "${widget.order.details.majorCategoryName()}   ${widget.order.details.category?.name}   ${widget.order.details.expectedMachiningQuantity}件",
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
    return widget.order.details.majorCategory != null
        ? widget.order.details.majorCategory.name
        : '';
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

  Widget _buildAttachments() {
    return widget.order.attachments == null||widget.order.attachments.length<=0 ? Container() : Container(
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
              children: <Widget>[Text(widget.order.deliveryAddress ?? '')],
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
    if (UserBLoC.instance.currentUser.type == UserType.BRAND && widget.order.status == RequirementOrderStatus.PENDING_QUOTE) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 30,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
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
                      })
              ),
            ),
            Expanded(
              child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
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
                                    cooperationModes: []
                                ),
                                requirementCode: widget.order.code,
                                route: '全部工厂',
                              )),
                        );
                      })
              ),
            ),
          ],
        ),
      );
    } else if(UserBLoC.instance.currentUser.type == UserType.BRAND && widget.order.status != RequirementOrderStatus.PENDING_QUOTE){
      return Container(
        child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
          margin: EdgeInsets.only(bottom: 10),
          child:FlatButton(
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
              })
        ),
      );
    }else if(UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      return Container(
        child: Container(
          height: 30,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          margin: EdgeInsets.only(bottom: 20),
          child: FlatButton(
              onPressed: () async {
                QuoteModel newQuote =
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RequirementQuoteOrderForm(
                              model: widget.order,
                              quoteModel: QuoteModel(attachments: []),
                            )));

                if (newQuote != null) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          QuoteOrderDetailPage(item: newQuote)));
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '去报价',
                style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1),
                    fontSize: 16,),
              )),
        ),
      );
    }else{
      return Container();
    }
  }

  void onEdit() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequirementOrderFrom(
              order: widget.order,
            )));
  }

  void onReview() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequirementOrderFrom(
          order: widget.order,
          isReview: true,
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
