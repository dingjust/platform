import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/business/orders/quote_order_detail.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/home/factory/_shared/factory_widgets.dart';
import 'package:b2b_commerce/src/home/pool/requirement_quote_order_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  UserModel currentUser = UserBLoC.instance.currentUser;

  List<QuoteModel> quotesList;

  double _leadingRowWidth = 180;
  int _flexL = 2;
  int _flexR = 3;

  @override
  void initState() {
    //埋点>>>需求明细
    UmengPlugin.onEvent('requirement_detail',
        properties: {'code': widget.code});
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
                        Divider(
                          height: 0,
                        ),
                        //标题
                        _buildTitle(),
                        //发布公司信息
                        _buildCompanyInfo(),
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

    //点击量
    ItemRepository().onDetail(orderModel.id);

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
                      '${orderModel.details?.category?.parent != null ? orderModel.details.category.parent.name + '-' : ''}'
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
                    orderModel.details.maxExpectedPrice == -1
                        ? '面议'
                        : '￥${orderModel.details.maxExpectedPrice ?? 0}',
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
                    '${DateFormatUtil.formatYMD(orderModel.details.expectedDeliveryDate)}',
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
                    child: Text('质量等级：'),
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
                        : orderModel.details.invoiceNeeded
                        ? '是'
                        : '否',
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
                        : orderModel.details.proofingNeeded
                        ? '是'
                        : '否',
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
    return Offstage(
      offstage: isMyself(),
      child: Container(
        height: 65,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
                child: FactoryBottomBtn(
                  color: Colors.green,
                  label: '联系对方',
                  onTap: () {
                    _selectActionButton(model?.details?.contactPhone);
                  },
                )),
            Expanded(
                child: FactoryBottomBtn(
                  color: Colors.blueAccent,
                  label: '生产报价',
                  onTap: () async {
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
                ))
          ],
        ),
      ),
    );
  }

  ///分享
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
        builder: (context) =>
            RequirementOrderFrom(
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

  ///是否自己所属
  bool isMyself() {
    if (currentUser?.companyCode != null && orderModel?.belongTo?.uid != null) {
      return currentUser.companyCode == orderModel.belongTo.uid;
    }
    return false;
  }
}
