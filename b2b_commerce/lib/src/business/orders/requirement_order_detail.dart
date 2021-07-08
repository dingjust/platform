import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:b2b_commerce/src/business/orders/quote_item.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_from.dart';
import 'package:b2b_commerce/src/business/requirement_orders.dart';
import 'package:b2b_commerce/src/common/mini_program_page_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

import './requirement/requirement_form_factory.dart';
import './requirement/requirement_form_order.dart';

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
  RequirementOrderModel orderModel;

  UserModel currentUser = UserBLoC.instance.currentUser;

  List<QuoteModel> quotesList;

  double _leadingRowWidth = 180;
  int _flexL = 2;
  int _flexR = 3;

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
                  _buildReviewInfo(),
                  //品牌端显示
                  _buildQuote(),
                  //标题
                  _buildTitle(),
                  //描述
                  _buildRemarks(),
                  Divider(
                    height: 0,
                  ),
                  //需求信息
                  orderModel.orderType == RequirementOrderType.FINDING_ORDER
                      ? _buildMainOrder()
                      : _buildMainFactory(),
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
      size: 99,
    );

    return detail;
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

  ///找工厂
  Widget _buildMainFactory() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
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
          //工厂区域
          _buildOrientations(),
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
          _InfoRow(
            label: '订单尺码',
            val: OrderSizeTypeLocalizedMap[orderModel.details.sizeType],
          ),
          Divider(
            height: 0,
          ),
          _InfoRow(
            label: '订单颜色',
            val: '${OrderColorTypeLocalizedMap[orderModel.details.colorType]}',
          ),
          Divider(
            height: 0,
          ),
          _InfoRow(
            label: '工厂规模',
            val:
            PopulationScaleLocalizedMap[orderModel.details.populationScale],
          ),
          Divider(
            height: 0,
          ),
          _InfoRow(
            label: '支付条件',
            val: '${payPlanStr()}',
          ),
          Divider(
            height: 0,
          ),
          _InfoRow(
            label: '所在位置',
            val: '${orderModel.details.address ?? ''}',
          ),
          Divider(
            height: 0,
          ),
          _InfoRow(
            label: '微信号',
            val: '${orderModel.details.contactWeChatNo ?? ''}',
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
        ],
      ),
    );
  }

  ///找订单
  Widget _buildMainOrder() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
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
                  child: Text('${orderModel.details?.majorCategory?.name}',
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
          _InfoRow(
            label: '所在位置',
            val: '${orderModel.details.address ?? ''}',
          ),
          Divider(
            height: 0,
          ),
          _InfoRow(
            label: '微信号',
            val: '${orderModel.details.contactWeChatNo ?? ''}',
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
        ],
      ),
    );
  }

  Widget _buildQuote() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: quotesList != null && quotesList.length > 0
          ? Column(
          children: quotesList
              .map((e) =>
              Container(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.only(bottom: 5),
                child: QuoteItem(
                  model: e,
                  onRefresh: () {
                    onRefreshData();
                  },
                  pageContext: context,
                ),
              ))
              .toList())
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

  List<PopupMenuItem<String>> _buildPopupMenu() {
    // if (orderModel.editable != null &&
    //     orderModel.editable &&
    //     orderModel.status == RequirementOrderStatus.PENDING_QUOTE) {
    if (orderModel.status == RequirementOrderStatus.PENDING_QUOTE) {
      if (orderModel.editable != null && orderModel.editable) {
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

  Widget _buildOrientations() {
    String val = '';

    //处理旧数据的地区信息
    if (orderModel.details.productiveDistricts == null) {
      val = formatAreaSelectsText(orderModel.details.productiveOrientations,
          orderModel.details.productiveOrientations.length);
    } else {
      val = orderModel.details.productiveDistricts.map((e) => e.name).join('、');
    }

    return _InfoRow(
      label: '工厂区域',
      val: '$val',
    );
  }

  Future<bool> _onCancle() {
    bool result = false;
    try {
      widget.onRequirementCancle();
      result = true;
    } catch (e) {
      result = false;
    }

    return Future.value(result);
  }

  Widget _buildRemarks() {
    return Container(
      padding: EdgeInsets.only(left: 15, bottom: 15, right: 5),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(child: Text(orderModel.remarks ?? '')),
        ],
      ),
    );
  }

  ///审核信息
  Widget _buildReviewInfo() {
    if (orderModel.reviewState == RequirementReviewState.REVIEWING) {
      return Container(
        color: Colors.orange,
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          children: [
            Expanded(
                child: Text(
                  '您提交的需求正在等待平台审核，请耐心等待',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      );
    } else if (orderModel.reviewState ==
        RequirementReviewState.REVIEW_REJECTED) {
      return Container(
        color: Colors.red[300],
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Row(
          children: [
            Expanded(
                child: Text(
                  '您提交的资料平台审核失败,原因如下：${orderModel.enableShowReasons}',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      );
    }

    return Container();
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
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return RequestDataLoading(
                          requestCallBack: _onCancle(),
                          outsideDismiss: false,
                          loadingText: '正在关闭。。。',
                          entrance: '',
                        );
                      }).then((value) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return CustomizeDialog(
                            dialogType: DialogType.RESULT_DIALOG,
                            successTips: '关闭成功',
                            failTips: '关闭失败',
                            callbackResult: value,
                            confirmAction: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                        });
                  });
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) =>
                      RequirementOrderFormStateV2(detailModel: orderModel),
                ),
              ],
              child: Consumer(
                builder: (context, RequirementOrderFormStateV2 state, _) =>
                orderModel.orderType == RequirementOrderType.FINDING_ORDER
                    ? RequirementFormOrder(
                  formState: state,
                )
                    : RequirementFormFactory(
                  formState: state,
                ),
              ),
            ),
      ),
    );
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
        path: MiniProgramPageRoutes.requirementDetail(orderModel.code),
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
}

class _InfoRow extends StatelessWidget {
  final String label;

  final String val;

  const _InfoRow({Key key, this.label, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Row(
        children: <Widget>[
          Expanded(flex: 2, child: Text('$label：')),
          Container(
            width: 8,
          ),
          Expanded(
            flex: 3,
            child: Text(
              val != null ? '$val' : '',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
