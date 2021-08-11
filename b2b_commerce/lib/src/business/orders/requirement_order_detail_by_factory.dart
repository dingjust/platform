import 'dart:ui';

import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/company_bar.dart';
import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/business/orders/quote_order_detail.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/common/mini_program_page_routes.dart';
import 'package:b2b_commerce/src/helper/dialog_helper.dart';
import 'package:b2b_commerce/src/home/factory/_shared/factory_widgets.dart';
import 'package:b2b_commerce/src/home/pool/requirement_quote_order_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_group_sliver/flutter_group_sliver.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

///首页需求订单明细
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

  _Divider _divider = const _Divider();

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
            backgroundColor: Color(0xffF7F7F7),
            appBar: AppBar(
              brightness: Brightness.light,
              centerTitle: true,
              elevation: 0,
              title: Text(
                '需求订单明细',
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      B2BIconsV2.share,
                      color: Color(0xff231815),
                    ),
                    onPressed: onShare),
              ],
            ),
            body: Container(
              // color: Color(0xffF7F7F7),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate(<Widget>[
                    //公司信息
                    _buildCompany(),
                    _buildMain(),
                  ])),
                  _buildImages(),
                  ..._buildCards()
                ],
              ),
            ),
            bottomNavigationBar: _buildBottomButtons(orderModel),
          );
        } else {
          return Scaffold(
            backgroundColor: Color(0xffF7F7F7),
            appBar: AppBar(
              brightness: Brightness.light,
              centerTitle: true,
              elevation: 0,
              title: Text(
                '需求订单明细',
                style: TextStyle(
                    color: Color(0xff000000),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      initialData: null,
      future: _getData(),
    );
  }

  List<Widget> _buildCards() {
    //工厂需求
    if (orderModel.orderType == RequirementOrderType.FINDING_ORDER) {
      return _findOrderCards();
    }
    return _finadFactoriesCards();
  }

  ///找工厂需求内容
  List<Widget> _finadFactoriesCards() {
    return [
      _Card(
        children: [
          _Info(
            title: '发布时间',
            val: DateFormatUtil.formatYMDHM(orderModel.creationTime),
          ),
          _divider,
          _Info(
            title: '品   类',
            val: '${orderModel.details?.category?.name ?? ''}',
          ),
          _divider,
          _Info(
            title: '生产数量',
            val: '${orderModel.details.expectedMachiningQuantity ?? 0}件',
          ),
          _divider,
          _Info(
            title: '期望价格',
            val: orderModel.details.maxExpectedPrice == -1
                ? '面议'
                : '￥${orderModel.details.maxExpectedPrice ?? 0}',
          ),
          _divider,
          _Info(
            title: '交货日期',
            val: DateFormatUtil.formatYMD(
                orderModel.details.expectedDeliveryDate),
          ),
          _divider,
          _Info(
            title: '是否打样',
            val: orderModel.details.proofingNeeded == null
                ? ''
                : orderModel.details.proofingNeeded
                    ? '是'
                    : '否',
          ),
        ],
      ),
      _Card(
        children: [
          _Info(
            title: '加工类型',
            val: orderModel.details.machiningType == null
                ? ''
                : MachiningTypeLocalizedMap[orderModel.details.machiningType],
          ),
          _divider,
          _Info(
            title: '质量等级',
            val: formatEnumSelectsText(orderModel.details.salesMarket,
                FactoryQualityLevelsEnum, FactoryQualityLevelsEnum.length),
          ),
          _divider,
          _Info(
            title: '工厂区域',
            val: _buildOrientations(),
          ),
          _divider,
          _Info(
            title: '工厂规模',
            val:
                PopulationScaleLocalizedMap[orderModel.details.populationScale],
          ),
          _divider,
          _Info(
            title: '订单尺码',
            val: OrderSizeTypeLocalizedMap[orderModel.details.sizeType],
          ),
          _divider,
          _Info(
            title: '订单颜色',
            val: OrderColorTypeLocalizedMap[orderModel.details.colorType],
          ),
        ],
      ),
      _Card(
        margin: EdgeInsets.only(top: 12, bottom: 60),
        children: [
          _Info(
            title: '是否开票',
            val: orderModel.details.invoiceNeeded == null
                ? ''
                : orderModel.details.invoiceNeeded
                    ? '是'
                    : '否',
          ),
          _divider,
          _Info(
            title: '有效期限',
            val: enumMap(
                EffectiveDaysEnum,
                orderModel.details.effectiveDays == null
                    ? '-1'
                    : orderModel.details.effectiveDays.toString()),
          ),
          _divider,
          _Info(
            title: '支付条件',
            val: payPlanStr(),
          ),
          _divider,
          _Info(
            title: '所在位置',
            val: orderModel.details.address,
          ),
          _divider,
          _Info(
            title: '微信号',
            val: orderModel.details.contactWeChatNo,
          ),
        ],
      )
    ];
  }

  ///找订单需求内容
  List<Widget> _findOrderCards() {
    return [
      _Card(
        children: [
          _Info(
            title: '发布时间',
            val: DateFormatUtil.formatYMDHM(orderModel.creationTime),
          ),
          _divider,
          _Info(
            title: '擅长品类',
            val: '${orderModel.details?.category?.name ?? ''}',
          ),
          _divider,
          _Info(
            title: '所在位置',
            val: orderModel.details.address,
          ),
        ],
      ),
    ];
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

  Widget _buildCompany() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 12),
      child: CompanyBar(
        companyModel: orderModel.belongTo,
        favoriteId: orderModel.id,
      ),
    );
  }

  Widget _buildMain() {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 16, 12, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  orderModel.details?.productName ?? '',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFAA6E15),
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  orderModel.remarks ?? '',
                  style: TextStyle(
                      color: Color(0xff666666),
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImages() {
    if (getImages().length == 0) {
      return SliverToBoxAdapter();
    }

    return SliverGroupBuilder(
      // margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
      ),
      child: SliverPadding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCountMap[getImages().length], //Grid按两列显示
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 12.0,
            childAspectRatio: childAspectRatioMap[getImages().length],
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              //创建子widget
              return _ImageItem(
                e: getImages()[index],
                onTap: () => onPreview(index),
              );
            },
            childCount: getImages().length,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(RequirementOrderModel model) {
    if (orderModel?.orderType == RequirementOrderType.FINDING_ORDER) {
      return Offstage(
        offstage: isMyself(),
        child: Container(
          height: 60,
          // color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Expanded(
                  child: FactoryBottomBtn(
                    color: Color(0xffFED800),
                    label: '联系对方',
                    onTap: () {
                      DialogHelper.showConfirm(
                          title: '温馨提示',
                          content:
                          '钉单平台无法保护您在电话、微信沟通和线下交易的可靠性及资金安全。请务必使用钉单平台的线上需求发布、钉单确认、合同签订、线上支付、对账单等系列功能，获得平台监督与仲裁服务。',
                          confirm: () {
                            var tel = '';
                            if (model?.details?.agentContactPhone != null &&
                                model?.details?.agentContactPhone != '') {
                              //代理电话
                              tel = model.details.agentContactPhone;
                            } else {
                              tel = model.details.contactPhone;
                            }
                            _selectActionButton(tel);
                          });
                    },
                  )),
            ],
          ),
        ),
      );
    }

    return Offstage(
      offstage: isMyself(),
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            Expanded(
                child: FactoryBottomBtn(
                  color: Color(0xffFED800),
                  label: '联系对方',
                  onTap: () {
                    DialogHelper.showConfirm(
                        title: '温馨提示',
                        content:
                        '钉单平台无法保护您在电话、微信沟通和线下交易的可靠性及资金安全。请务必使用钉单平台的线上需求发布、钉单确认、合同签订、线上支付、对账单等系列功能，获得平台监督与仲裁服务。',
                        confirm: () {
                          var tel = '';
                          if (model?.details?.agentContactPhone != null &&
                              model?.details?.agentContactPhone != '') {
                            //代理电话
                            tel = model.details.agentContactPhone;
                          } else {
                            tel = model.details.contactPhone;
                          }
                          _selectActionButton(tel);
                        });
                  },
                )),
            Container(width: 15),
            Expanded(
                child: FactoryBottomBtn(
                  color: Colors.blueAccent,
                  gradient: LinearGradient(
                      colors: [Color(0xffFFDB34), Color(0xffFF7C18)]),
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

  String _buildOrientations() {
    String val = '';

    //处理旧数据的地区信息
    if (orderModel.details.productiveDistricts == null) {
      val = formatAreaSelectsText(orderModel.details.productiveOrientations,
          orderModel.details.productiveOrientations.length);
    } else {
      val = orderModel.details.productiveDistricts.map((e) => e.name).join('、');
    }

    return val;
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

    const processUrl = 'image_process=resize,w_320/crop,mid,w_320,h_320';

    ShareDialog.showShareDialog(context,
        title: '$title',
        description: '$description',
        imageUrl: orderModel.details.pictures.isEmpty
            ? '${GlobalConfigs.LOGO_URL}'
            : '${orderModel.details.pictures[0].imageProcessUrl(processUrl)}',
        path: MiniProgramPageRoutes.requirementDetail(orderModel.code),
        url: Apis.shareRequirement(orderModel.code));
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

  ///支付条件
  String payPlanStr() {
    if (orderModel.details?.payPlan == null) {
      return '';
    } else {
      CompanyPayPlanModel payplan = orderModel.details.payPlan;
      return '${payplan.isHaveDeposit
          ? '有'
          : '无'}定金  ${PayPlanTypeLocalizedMap[payplan.payPlanType]}';
    }
  }

  List<MediaModel> getImages() {
    if (orderModel.details.pictures != null) {
      if (orderModel.details.pictures.length > 9) {
        return orderModel.details.pictures.getRange(0, 9).toList();
      }
      return orderModel.details.pictures;
    }
    return [];
  }

  //图片预览
  void onPreview(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GalleryPhotoViewWrapper(
              galleryItems:
              getImages().map((model) => GalleryItem(model: model)).toList(),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
              initialIndex: index,
              scrollDirection: Axis.horizontal,
            ),
      ),
    );
  }
}

class _ImageItem extends StatelessWidget {
  final MediaModel e;

  final VoidCallback onTap;

  final String processUrl;

  const _ImageItem({Key key,
    this.e,
    this.onTap,
    this.processUrl = 'image_process=resize,w_320/crop,mid,w_320,h_320'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        child: CachedNetworkImage(
          imageUrl: '${e.imageProcessUrl(processUrl)}',
          placeholder: (context, url) =>
              SpinKitRing(
                color: Colors.grey[300],
                lineWidth: 2,
                size: 30,
              ),
          errorWidget: (context, url, error) =>
              SpinKitRing(
                color: Colors.grey[300],
                lineWidth: 2,
                size: 30,
              ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;

  final EdgeInsetsGeometry margin;

  const _Card(
      {Key key, this.children, this.margin = const EdgeInsets.only(top: 12)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: margin,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String title;

  final String val;

  const _Info({Key key, this.title, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              margin: EdgeInsets.only(right: 24),
              child: Text(
                '$title',
                style: TextStyle(
                    color: Color(0xff999999),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
                child: Text((val != null && val != '') ? '$val' : '-',
                    style: TextStyle(
                        color: Color(0xff222222),
                        fontSize: 14,
                        fontWeight: FontWeight.w500)))
          ],
        ));
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Color(0xffE7E7E7),
      thickness: 0.5,
      height: 28,
    );
  }
}

///图片列数
const crossAxisCountMap = {
  1: 1,
  2: 2,
  3: 3,
  4: 2,
  5: 3,
  6: 3,
  7: 3,
  8: 3,
  9: 3
};

///图片比列
const childAspectRatioMap = {
  1: 16 / 9,
  2: 4 / 3,
  3: 1.0,
  4: 4 / 3,
  5: 1.0,
  6: 1.0,
  7: 1.0,
  8: 1.0,
  9: 1.0
};
