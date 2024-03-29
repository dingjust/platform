import 'package:b2b_commerce/b2b_commerce.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
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

class QuoteOrderDetailPage extends StatefulWidget {
//  QuoteModel item;

  QuoteOrderDetailPage(this.code);

  final String code;

  _QuoteOrderDetailPageState createState() => _QuoteOrderDetailPageState();
}

class _QuoteOrderDetailPageState extends State<QuoteOrderDetailPage> {
  QuoteModel pageItem;

  static Map<QuoteState, MaterialColor> _statesColor = {
    QuoteState.SELLER_SUBMITTED: Colors.red,
    QuoteState.BUYER_APPROVED: Colors.green,
    QuoteState.BUYER_REJECTED: Colors.grey
  };

  TextEditingController rejectController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //页面缓存Model对象
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          '报价详情',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<QuoteModel>(
        builder: (BuildContext context, AsyncSnapshot<QuoteModel> snapshot) {
          if (snapshot.data != null) {
            return ListView(
              children: <Widget>[
                _buildRefuseMessage(),
                _buildCompanyInfo(),
                _buildFactory(),
                Card(
                  elevation: 0,
                  margin: EdgeInsets.only(top: 15),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: _buildProduct(),
                  ),
                ),
                _buildQuoteCost(),
                _buildDeliveryDate(),
                _buildAttachment(),
                _buildRemark(),
                _buildOrderState(),
                _buildSummary()
              ],
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

  Future<QuoteModel> _getData() async {
    // 查询明细
    QuoteModel detailModel =
        await QuoteOrderRepository().getQuoteDetails(widget.code);
    pageItem = detailModel;
    return detailModel;
  }

  Widget _buildRefuseMessage() {
    //拒绝状态
    if (pageItem.state == QuoteState.BUYER_REJECTED) {
      return Container(
        padding: EdgeInsets.all(10),
        color: Color.fromRGBO(255, 245, 169, 1),
        child: Text(
          '拒绝理由：${pageItem.comment}',
          style: TextStyle(color: Color.fromRGBO(255, 70, 70, 1), fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildOrderState() {
    return GestureDetector(
      onTap: () {
        copyToClipboard(pageItem.code);
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text('需求订单号：${pageItem.requirementOrder.code}'),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('报价单号：${pageItem.code}'),
                  ),
                  Text(
                    '复制',
                    style: TextStyle(
                      color: Colors.orangeAccent,
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('报价时间：' +
                    pageItem.creationTime.toString().substring(0, 10)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyInfo() {
    /// 工厂端显示
    if (UserBLoC.instance.currentUser.companyCode == pageItem.belongTo.uid) {
      return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                pageItem.requirementOrder.belongTo?.profilePicture == null
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
                                '${pageItem?.requirementOrder?.belongTo?.profilePicture?.previewUrl()}',
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => Container(
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
                        pageItem?.requirementOrder?.belongTo == null ||
                            pageItem?.requirementOrder?.belongTo?.name ==
                                null
                            ? ''
                            : '${pageItem?.requirementOrder?.belongTo?.name}',
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    pageItem?.requirementOrder?.belongTo == null ||
                        pageItem?.requirementOrder?.belongTo
                            .approvalStatus ==
                            null
                        ? Container()
                        : Container(
                        margin: EdgeInsets.only(top: 5),
                        color: Color.fromRGBO(254, 252, 235, 1),
                        child: pageItem?.requirementOrder?.belongTo
                            .approvalStatus !=
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
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  _buildFactory() {
    //品牌端显示
    if (UserBLoC.instance.currentUser.companyCode ==
        pageItem?.requirementOrder?.belongTo?.uid) {
      return GestureDetector(
        onTap: () async {
          if (pageItem.belongTo != null) {
            Navigator.of(context).pushNamed(
                AppRoutes.ROUTE_FACTORY_INTRODUCTION,
                arguments: {'uid': pageItem.belongTo.uid});
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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: pageItem.belongTo == null ||
                                        pageItem.belongTo.name == null
                                    ? Text(
                                        '',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Text(
                                        pageItem.belongTo.name,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                              ),
                              pageItem.belongTo == null ||
                                      pageItem.belongTo.starLevel == null
                                  ? Container()
                                  : Stars(
                                      size: 14,
                                      color: Color.fromRGBO(255, 183, 0, 1),
                                      highlightOnly: false,
                                      starLevel: pageItem.belongTo.starLevel,
                                    ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  '历史接单${pageItem.belongTo == null || pageItem.belongTo.historyOrdersCount == null ? '0' : pageItem.belongTo.historyOrdersCount}单',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${pageItem.belongTo.contactAddress?.city?.name} ${pageItem.belongTo.contactAddress?.cityDistrict?.name}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 40,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ))),
      );
    } else {
      return Container();
    }
  }

  Widget _buildProduct() {
    return Row(
      children: <Widget>[
        pageItem.requirementOrder.details?.pictures != null &&
                pageItem.requirementOrder.details.pictures.isNotEmpty
            ? Container(
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                    width: 100,
                    height: 100,
                    imageUrl:
                        '${pageItem.requirementOrder.details.pictures[0].previewUrl()}',
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
              )
            : Container(
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
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                pageItem.requirementOrder.details?.productName != null
                    ? Text(
                        pageItem.requirementOrder.details.productName,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        //overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        ' ',
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      ),
                pageItem.requirementOrder.details?.productSkuID != null
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '货号：' +
                              pageItem.requirementOrder.details.productSkuID,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 243, 243, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${pageItem.requirementOrder.details?.majorCategoryName()} ${pageItem.requirementOrder.details?.category?.name}  ${pageItem?.totalQuantity == null ? '0' : pageItem?.totalQuantity}件',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 133, 148, 1),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteCost() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 15),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '报价费用',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('订单报价'),
                  ),
                  Text(
                    '￥ ${pageItem.unitPrice}',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
//              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('面料价格'),
                          ),
                        ),
                        Container(
                          child: Text(
                            '￥ ${pageItem.unitPriceOfFabric}',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('辅料价格'),
                          ),
                        ),
                        Text(
                          '￥ ${pageItem.unitPriceOfExcipients}',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('加工价格'),
                          ),
                        ),
                        Text(
                          '￥ ${pageItem.unitPriceOfProcessing}',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('其他价格'),
                          ),
                        ),
                        Text(
                          '￥ ${pageItem.costOfOther}',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text('打样费'),
                    ),
                  ),
                  Text(
                    '￥' + pageItem.costOfSamples.toString(),
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryDate() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 15),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text('交货时间'),
                ),
              ),
              Container(
                child: Text(
                    '${DateFormatUtil.formatYMD(pageItem.expectedDeliveryDate)}'),
              )
            ],
          )),
    );
  }

  Widget _buildAttachment() {
    return pageItem.attachments == null || pageItem.attachments.length <= 0
        ? Container()
        : Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 15),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '附件',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Attachments(list: pageItem.attachments),
                  ],
                )),
          );
  }

  Widget _buildRemark() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 15),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '备注',
                style: TextStyle(color: Colors.grey),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text('${pageItem.remarks}'),
              ),
            ],
          )),
    );
  }

  void refreshData() async {
    // //查询明细
    // QuoteModel detailModel =
    //     await QuoteOrderRepository().getQuoteDetails(pageItem.code);
    // if (detailModel != null) {
    //   setState(() {
    //     pageItem = detailModel;
    //   });
    // }
    QuoteOrdersBLoC().refreshData('ALL');
    setState(() {
      _getData();
    });
  }

  Widget _buildSummary() {
    List<Widget> buttons;

    //品牌端显示
    if (UserBLoC.instance.currentUser.companyCode ==
        pageItem?.requirementOrder?.belongTo?.uid) {
      if (pageItem.state == QuoteState.SELLER_SUBMITTED) {
        buttons = <Widget>[
          Container(
            height: 30,
            margin: EdgeInsets.only(right: 20),
            child: FlatButton(
                onPressed: onReject,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 45),
                child: Text(
                  '拒绝工厂',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          ),
          Container(
            height: 30,
            child: FlatButton(
                onPressed: onApprove,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Color.fromRGBO(255, 214, 12, 1),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 45),
                child: Text(
                  '确认工厂',
                  style: TextStyle(
                      color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                )),
          )
        ];
      }
    } //工厂端显示
    else if (UserBLoC.instance.currentUser.companyCode ==
        pageItem.belongTo?.uid) {
      if (pageItem.state == QuoteState.SELLER_SUBMITTED) {
        buttons = [
          Container(
            height: 30,
            child: FlatButton(
                color: Colors.red,
                onPressed: onUpdateQuote,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 140),
                child: Text(
                  '修改报价',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          ),
        ];
      } else if (pageItem.state == QuoteState.BUYER_APPROVED) {
        buttons = <Widget>[
          Container(
            height: 30,
            child: FlatButton(
              onPressed: () async {
                QuoteModel quote =
                await QuoteOrderRepository().getQuoteDetails(pageItem.code);
                if (quote.salesOrderCode != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            SaleOrderDetailPage(
                              code: pageItem.salesOrderCode,
                              callback: () {
                                //回调刷新State
                              },
                            )),
                  );
                } else {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return CustomizeDialog(
                          dialogType: DialogType.CONFIRM_DIALOG,
                          dialogHeight: 210,
                          contentText2: '该订单已被取消',
                          isNeedConfirmButton: true,
                          isNeedCancelButton: true,
                          confirmAction: () {
                            QuoteOrdersBLoC().refreshData('ALL');
                            Navigator.of(context).pop();
                          },
                        );
                      });
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              color: Colors.grey,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '查看销售订单',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ];
      } else if (pageItem.requirementOrder.status ==
          RequirementOrderStatus.PENDING_QUOTE) {
        buttons = [
          Container(
            height: 30,
            child: FlatButton(
                onPressed: onQuoteAgain,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: Color.fromRGBO(255, 70, 70, 1),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 120),
                child: Text(
                  '重新报价',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          )
        ];
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      // color: Colors.green,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center, children: buttons ?? []),
    );
  }

  void alertMessage(String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            failTips: '${message}',
            callbackResult: false,
            confirmAction: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  void onReject() {
    TextEditingController inputController = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.INPUTS_DIALOG,
            inputController1: inputController,
            title: '填写拒绝原因',
            focusNode1: FocusNode(),
          );
        }).then((value) {
      if (value != null && value != '') {
        rejectQuote(pageItem, value);
      }
      setState(() {});
    });
  }

  rejectQuote(QuoteModel model, String rejectText) async {
    int statusCode = await QuoteOrderRepository().quoteReject(
      model.code,
      rejectText,
    );
    if (statusCode == 200) {
      // 触发刷新
      refreshData();
    } else {
      alertMessage('拒绝失败');
    }
  }

  void onApprove() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            contentText2: '是否确认该工厂报价?',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmButtonText: '是',
            cancelButtonText: '否',
            dialogHeight: 180,
            confirmAction: () async {
              confirmFactory();
              Navigator.of(context).pop();
            },
          );
        });
  }

  confirmFactory() async {
    int statusCode = await QuoteOrderRepository().quoteApprove(pageItem.code);
    Navigator.of(context).pop();
    if (statusCode == 200) {
      //触发刷新
      refreshData();
    } else {
      alertMessage('确认失败');
    }
  }

  void onQuoteAgain() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequirementQuoteOrderForm(
              model: pageItem.requirementOrder,
              quoteModel: pageItem,
            )));
  }

  void onUpdateQuote() async {
    //等待操作回调
    bool isSuccessfule = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RequirementQuoteOrderForm(
              model: pageItem.requirementOrder,
              quoteModel: pageItem,
              update: true,
            )));
    //成功调用列表页传递的更新函数刷新页面
    if (isSuccessfule != null && isSuccessfule) {
      refreshData();
    }
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
}
