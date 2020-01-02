import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/business/orders/quote_order_detail.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
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

class RequirementOrderDetailByFactoryPage extends StatefulWidget {
  String code;

  /// 关闭生产订单
  final RequirementOrderCancleCallback onRequirementCancle;

  RequirementOrderDetailByFactoryPage(this.code,
      {Key key, this.onRequirementCancle})
      : super(key: key);

  _RequirementOrderDetailByFactoryPageState createState() =>
      _RequirementOrderDetailByFactoryPageState();
}

class _RequirementOrderDetailByFactoryPageState
    extends State<RequirementOrderDetailByFactoryPage> {
  RequirementOrderModel orderModel;

  List<QuoteModel> quotesList;

  double _leadingRowWidth = 180;
  int _flexL = 2;
  int _flexR = 3;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RequirementOrderModel>(
      builder: (BuildContext context,
          AsyncSnapshot<RequirementOrderModel> snapshot) {
        if (snapshot.data != null) {
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
                InkWell(
                    onTap: () => onShare(),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: <Widget>[
                          Icon(
                            B2BIcons.share,
                          ),
                          Text('分享')
                        ],
                      ),
                    )),
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
                        //发布公司信息
                        _buildCompanyInfo(),
                        Divider(
                          height: 0,
                        ),
                        //标题
                        _buildTitle(),
                        Divider(
                          height: 0,
                        ),
                        //需求信息
                        _buildMain(),
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
            bottomNavigationBar: _buildBottomButtons(orderModel),
          );
        } else {
          print('ddd');
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      initialData: RequirementOrderModel(details: RequirementInfoModel()),
      future: _getData(),
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
    return Container(
      padding: EdgeInsets.all(15),
//        margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              orderModel.belongTo.profilePicture == null
                  ? Container(
                margin: EdgeInsets.only(right: 10),
                width: 60,
                height: 60,
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
                margin: EdgeInsets.only(right: 10),
                width: 60,
                height: 60,
                child: CachedNetworkImage(
                    width: 80,
                    height: 80,
                    imageUrl:
                    '${orderModel.belongTo.profilePicture.previewUrl()}',
                    fit: BoxFit.cover,
                    imageBuilder: (context, imageProvider) =>
                        Container(
                          width: 80,
                          height: 80,
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
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '发布于：',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text:
                      '${DateFormatUtil.formatYMDHM(orderModel.creationTime)}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Text(
        orderModel.details?.productName ?? '无标题',
        style: TextStyle(fontSize: 20),
      ),
    );
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
      child: Column(
        children: <Widget>[
//          Column(children: [
//            _buildEntries(),
//          ]),
//          Divider(
//            height: 0,
//          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: _flexL,
                  child: Container(
                    alignment: Alignment.centerLeft,
//                    width: _leadingRowWidth,
                    child: Text('品       类：'),
                  ),
                ),
                Expanded(
                  flex: _flexR,
                  child: Text(
                      '${orderModel.details?.majorCategory?.name}-'
                          '${orderModel.details?.category?.parent != null
                          ? orderModel.details.category.parent.name + '-'
                          : ''}'
                          '${orderModel.details?.category?.name}',
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: _flexL,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: _leadingRowWidth,
                    child: Text('数       量：'),
                  ),
                ),
                Expanded(
                  flex: _flexR,
                  child: Text(
                      '${orderModel.details.expectedMachiningQuantity ?? 0}件',
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: _flexL,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: _leadingRowWidth,
                    child: Text('期望价格：'),
                  ),
                ),
                Expanded(
                  flex: _flexR,
                  child: Text(
                    '￥${orderModel.details.maxExpectedPrice ?? 0}',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: _flexL,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: _leadingRowWidth,
                    child: Text('交货日期：'),
                  ),
                ),
                Expanded(
                  flex: _flexR,
                  child: Text(
                    '${DateFormatUtil.formatYMD(
                        orderModel.details.expectedDeliveryDate)}',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: _flexL,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: _leadingRowWidth,
                    child: Text('加工类型：'),
                  ),
                ),
                Expanded(
                  flex: _flexR,
                  child: Text(
                    orderModel.details.machiningType == null
                        ? ''
                        : MachiningTypeLocalizedMap[
                    orderModel.details.machiningType],
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: _flexL,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: _leadingRowWidth,
                    child: Text('销售市场：'),
                  ),
                ),
                Expanded(
                  flex: _flexR,
                  child: Text(
                    formatEnumSelectsText(
                        orderModel.details.salesMarket,
                        FactoryQualityLevelsEnum,
                        FactoryQualityLevelsEnum.length),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: _flexL,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: _leadingRowWidth,
                    child: Text('工厂区域：'),
                  ),
                ),
                Expanded(
                  flex: _flexR,
                  child: Text(
                    formatAreaSelectsText(
                        orderModel.details.productiveOrientations,
                        orderModel.details.productiveOrientations.length),
//                  overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: _flexL,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: _leadingRowWidth,
                    child: Text('是否开票：'),
                  ),
                ),
                Expanded(
                  flex: _flexR,
                  child: Text(
                    orderModel.details.invoiceNeeded == null
                        ? ''
                        : orderModel.details.invoiceNeeded ? '是' : '否',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: _flexL,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: _leadingRowWidth,
                    child: Text('是否打样：'),
                  ),
                ),
                Expanded(
                  flex: _flexR,
                  child: Text(
                    orderModel.details.proofingNeeded == null
                        ? ''
                        : orderModel.details.proofingNeeded ? '是' : '否',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: _flexL,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: _leadingRowWidth,
                    child: Text('有效期限：'),
                  ),
                ),
                Expanded(
                  flex: _flexR,
                  child: Text(
                    enumMap(
                        EffectiveDaysEnum,
                        orderModel.details.effectiveDays == null
                            ? '-1'
                            : orderModel.details.effectiveDays.toString()),
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),

          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: Row(
              children: <Widget>[
                Text('参考图片：'),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: EditableAttachments(
              list: orderModel.details.pictures,
              editable: false,
            ),
          ),
          Divider(
            height: 0,
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 15,
              top: 15,
            ),
            child: Row(
              children: <Widget>[
                Text('备注：'),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, bottom: 15, right: 5),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(orderModel.remarks ?? '')),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(RequirementOrderModel model) {
    return Container(
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: FlatButton(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.all(2),
                  ),
                  Text(model?.details?.contactPerson ?? ''),
                ],
              ),
              onPressed: () {
                _selectActionButton(model?.details?.contactPhone);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
                height: double.infinity,
                child: Builder(
                  builder: (BuildContext buttonContext) =>
                      FlatButton(
                        color: Color.fromRGBO(255, 214, 12, 1),
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
                        disabledColor: Colors.grey[300],
                        child: Text(
                          '去报价',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                )),
          )
        ],
      ),
    );
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
            : '${orderModel.details.pictures[0].shareUrl()}',
        url: Apis.shareRequirement(orderModel.code));

    print('${orderModel.details.pictures[0].shareUrl()}');
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
    if (tel == null || tel == '') {
      return;
    }
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
