import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class QuoteOrderDetailPage extends StatefulWidget {
  QuoteModel item;

  QuoteOrderDetailPage({this.item});

  _QuoteOrderDetailPageState createState() => _QuoteOrderDetailPageState();
}

class _QuoteOrderDetailPageState extends State<QuoteOrderDetailPage> {
  QuoteModel pageItem;

  static Map<QuoteState, MaterialColor> _statesColor = {
    QuoteState.SELLER_SUBMITTED: Colors.green,
    QuoteState.BUYER_APPROVED: Colors.blue,
    QuoteState.BUYER_REJECTED: Colors.red
  };

  TextEditingController rejectController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //页面缓存Model对象
    pageItem = widget.item;
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
      body: ListView(
        children: <Widget>[
          _buildOrderState(),
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
          _buildActionChip(context),
        ],
      ),
    );
  }

  Widget _buildOrderState() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('需求订单号：' + pageItem.requirementOrderRef),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('报价单号：' + pageItem.code),
                ),
                Text(
                  QuoteStateLocalizedMap[pageItem.state],
                  style: TextStyle(
                    color: _statesColor[pageItem.state],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                  '报价时间：' + pageItem.creationTime.toString().substring(0, 10)),
            )
          ],
        ),
      ),
    );
  }

  _buildFactory() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 15),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 15, 0, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '报价工厂',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      pageItem.belongTo.name,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Stars(
                    starLevel: pageItem.belongTo.starLevel ?? 1,
                    highlightOnly: false,
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  '${pageItem.belongTo.contactAddress?.city?.name} ${pageItem.belongTo.contactAddress?.cityDistrict?.name}',
                  style: TextStyle(color: Colors.grey),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: Colors.grey,
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('历史接单'),
                Text(
                  pageItem.belongTo.historyOrdersCount.toString(),
                  style: TextStyle(color: Colors.red),
                ),
                Text('单，报价成功率'),
                Text(
                  (pageItem.belongTo.orderedSuccessRate ?? 0 * 100)
                          .round()
                          .toString() +
                      '%',
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProduct() {
    return Row(
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: pageItem.requirementOrder.details.pictures != null &&
                        pageItem.requirementOrder.details.pictures.isNotEmpty
                    ? NetworkImage(
                        pageItem.requirementOrder.details.pictures[0].url)
                    : AssetImage(
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
                pageItem.requirementOrder.details.productName != null
                    ? Text(
                        pageItem.requirementOrder.details.productName,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        //overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        '暂无产品',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
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
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${pageItem.requirementOrder.details?.majorCategory.name},${pageItem.requirementOrder.details?.category.name},${pageItem.requirementOrder.totalQuantity}件',
                    style: TextStyle(
                      color: Colors.orange,
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
                    child: Text('面料单价'),
                  ),
                  Text(
                    '￥ ${pageItem.unitPriceOfFabric}',
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('辅料单价'),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('加工单价'),
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
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('其他'),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '费用合计'
                        '￥' +
                        (pageItem.unitPriceOfFabric +
                                pageItem.unitPriceOfExcipients +
                                pageItem.unitPriceOfProcessing +
                                pageItem.costOfOther)
                            .toString(),
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('打样费'),
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
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 15),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Text(
            '交货时间：${DateFormatUtil.formatYMD(pageItem.expectedDeliveryDate)}'),
      ),
    );
  }

  Widget _buildAttachment() {
    return Card(
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

  Widget _buildActionChip(BuildContext pageContext) {
    return Offstage(
      offstage: pageItem.state != QuoteState.SELLER_SUBMITTED &&
              UserBLoC.instance.currentUser.type == UserType.BRAND
          ? true
          : false,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ActionChip(
                backgroundColor: Colors.red,
                labelPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                labelStyle: TextStyle(fontSize: 16),
                label: Text('拒绝报价'),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('请输入拒绝原因'),
                        content: TextField(
                          controller: rejectController,
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: '请输入数量',
                          ),
                        ),
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
                              int statusCode = await QuoteOrderRepository()
                                  .quoteReject(
                                      pageItem.code, rejectController.text);
                              Navigator.of(context).pop();
                              if (statusCode == 200) {
                                alertMessage('拒绝成功!');
                                //触发刷新
                                refreshData();
                              } else {
                                alertMessage('拒绝失败');
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: ActionChip(
                backgroundColor: Colors.orange,
                labelPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                labelStyle: TextStyle(fontSize: 16),
                label: Text('确认报价'),
                onPressed: () async {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (context) {
                      return AlertDialog(
                        title: Text('是否确认?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('否'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('是'),
                            onPressed: () async {
                              int statusCode = await QuoteOrderRepository()
                                  .quoteApprove(pageItem.code);
                              Navigator.of(context).pop();
                              if (statusCode == 200) {
                                alertMessage('确认成功!');
                                //触发刷新
                                refreshData();
                              } else {
                                alertMessage('确认失败');
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void refreshData() async {
    //查询明细
    QuoteModel detailModel =
        await QuoteOrderRepository().getquoteDetail(pageItem.code);
    if (detailModel != null) {
      setState(() {
        pageItem = detailModel;
      });
    }
  }

  void alertMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text(message)],
            ),
          ),
    );
  }
}
