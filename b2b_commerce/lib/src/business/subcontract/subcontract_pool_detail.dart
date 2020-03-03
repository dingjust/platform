import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

class SubContractPoolDetailPage extends StatefulWidget {
  String code;

  /// 关闭生产订单
  final RequirementOrderCancleCallback onRequirementCancle;

  SubContractPoolDetailPage(this.code, {Key key, this.onRequirementCancle})
      : super(key: key);

  _SubContractPoolDetailPageState createState() =>
      _SubContractPoolDetailPageState();
}

class _SubContractPoolDetailPageState extends State<SubContractPoolDetailPage> {
  SubContractModel subContractModel;

  double _leadingRowWidth = 180;
  int _flexL = 2;
  int _flexR = 3;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SubContractModel>(
        initialData: null,
        future: _getData(),
        builder:
            (BuildContext context, AsyncSnapshot<SubContractModel> snapshot) {
          return Scaffold(
              appBar: AppBar(
                brightness: Brightness.light,
                centerTitle: true,
                elevation: 0.5,
                title: Text(
                  '转包明细',
                  style: TextStyle(color: Colors.black),
                ),
                actions: <Widget>[],
              ),
              bottomNavigationBar: _buildBottomButtons(),
              body: snapshot.data != null
                  ? Container(
                color: Colors.grey[100],
                child: ListView(
                  children: <Widget>[
                    //发布公司信息
//                  _buildCompanyInfo(),
//                  Divider(
//                    height: 0,
//                  ),
                    //标题
                    _buildTitle(),
                    Divider(
                      height: 0,
                    ),
                    //需求信息
                    _buildMain(),
                  ],
                ),
              )
                  : Center(
                child: CircularProgressIndicator(),
              ));
        });
  }

  Future<SubContractModel> _getData() async {
    print(widget.code);
    // 查询明细
    // 根据code查询明
    SubContractModel detail =
    await SubContractRepositoryImpl().getSubContract(widget.code);

    subContractModel = detail;

    return detail;
  }

  Widget _buildCompanyInfo() {
    /// 工厂端显示
    if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      return Container(
        padding: EdgeInsets.all(15),
//        margin: EdgeInsets.only(bottom: 10),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                subContractModel.belongTo.profilePicture == null
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
                      '${subContractModel.belongTo.profilePicture
                          .previewUrl()}',
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
                            subContractModel.belongTo == null ||
                                subContractModel.belongTo == null
                                ? ''
                                : '${subContractModel.belongTo.name}',
                            textScaleFactor: 1.3,
                          ),
                        ),
                        subContractModel.belongTo == null ||
                            subContractModel.belongTo.approvalStatus == null
                            ? Container()
                            : Container(
                            margin: EdgeInsets.only(top: 5),
                            color: Color.fromRGBO(254, 252, 235, 1),
                            child: subContractModel.belongTo.approvalStatus !=
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
                        '${DateFormatUtil.formatYMDHM(
                            subContractModel.creationTime)}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
//            Container(
//              padding: EdgeInsets.all(15),
//              child: Row(
//                children: <Widget>[
//                  Expanded(
//                    child: Container(
//                      child: Text('联系人'),
//                    ),
//                  ),
//                  Container(
//                    child: Text(
//                      orderModel.details.contactPerson == null
//                          ? ''
//                          : '${orderModel.details.contactPerson}',
//                      style: TextStyle(
//                          color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
//                    ),
//                  )
//                ],
//              ),
//            ),
//            Divider(
//              height: 2,
//            ),
//            GestureDetector(
//              child: Container(
//                padding: EdgeInsets.all(15),
//                child: Row(
//                  children: <Widget>[
//                    Expanded(
//                      child: Container(
//                        child: Text('联系手机'),
//                      ),
//                    ),
//                    Container(
//                      child: Text(
//                        orderModel.details.contactPhone == null
//                            ? ''
//                            : '${orderModel.details.contactPhone}',
//                        style: TextStyle(
//                            color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//              onTap: () {
//                orderModel.details.contactPhone == null
//                    ? null
//                    : _selectActionButton(orderModel.details.contactPhone);
//              },
//            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Text(
        subContractModel.details?.title ?? '无标题',
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
                    child: Text('类       型：'),
                  ),
                ),
                Expanded(
                  flex: _flexR,
                  child: Text(
                    subContractModel.details.type == null
                        ? ''
                        : enumMap(
                        SubContractTypeEnum, subContractModel.details.type),
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
//                    width: _leadingRowWidth,
                    child: Text('品       类：'),
                  ),
                ),
                Expanded(
                  flex: _flexR,
                  child: Text(
                      '${subContractModel.details?.majorCategory?.name}-'
                          '${subContractModel.details?.category?.parent != null
                          ? subContractModel.details.category.parent.name + '-'
                          : ''}'
                          '${subContractModel.details?.category?.name}',
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
                      '${subContractModel.details.subContractQuantity ?? 0}件',
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
                    '￥${subContractModel.details.maxExpectedPrice ?? 0}',
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
                        subContractModel.details.expectedDeliveryDate)}',
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
                    subContractModel.details.machiningType == null
                        ? ''
                        : enumMap(CooperationModesEnum,
                        subContractModel.details.machiningType),
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
                        subContractModel.details.salesMarket,
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
                        subContractModel.details.productiveOrientations,
                        subContractModel.details.productiveOrientations.length),
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
                    subContractModel.details.invoiceNeeded == null
                        ? ''
                        : subContractModel.details.invoiceNeeded ? '是' : '否',
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
                        subContractModel.details.effectiveDays == null
                            ? '-1'
                            : subContractModel.details.effectiveDays
                            .toString()),
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
              list: subContractModel.details.pictures,
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
                Expanded(child: Text(subContractModel.remarks ?? '')),
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

  Widget _buildBottomButtons() {
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
                  Text(subContractModel?.details?.contactPerson ?? ''),
                ],
              ),
              onPressed: () {
                _selectActionButton(subContractModel?.details?.contactPhone);
              },
            ),
          ),
        ],
      ),
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

  onMenuSelect(String value) async {
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
  }

  ///TODO分享
  void onShare() {
    String title = '';
    String description =
        " ${subContractModel.details.category?.name}   ${subContractModel
        .details.subContractQuantity}件\n 交货时间:${DateFormatUtil.formatYMD(
        subContractModel.details.expectedDeliveryDate)}";

    if (subContractModel.details.title != null &&
        subContractModel.details.title != '') {
      title = subContractModel.details.title;
    } else {
      title = subContractModel.details.category.name;
    }

    ShareDialog.showShareDialog(context,
        title: '$title',
        description: '$description',
        imageUrl: subContractModel.details.pictures.isEmpty
            ? '${GlobalConfigs.LOGO_URL}'
            : '${subContractModel.details.pictures[0].shareUrl()}',
        url: Apis.shareRequirement(subContractModel.code));

    print('${subContractModel.details.pictures[0].shareUrl()}');
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
