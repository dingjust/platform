import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:b2b_commerce/src/business/search/purchase_order_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_PAYMENT', '待付款'),
  EnumModel('IN_PRODUCTION', '生产中'),
  EnumModel('WAIT_FOR_OUT_OF_STORE', '待出库'),
  EnumModel('OUT_OF_STORE', '已出库'),
];

class PurchaseOrdersPage extends StatefulWidget {
  _PurchaseOrdersPageState createState() => _PurchaseOrdersPageState();
}

class _PurchaseOrdersPageState extends State<PurchaseOrdersPage> {
  String showText;
  String statusColor;
  String userType;

  @override
  void initState() {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    if(bloc.isBrandUser){
      userType = 'brand';
    }else{
      userType = 'factory';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<PurchaseOrderBLoC>(
        bloc: PurchaseOrderBLoC.instance,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            title: Text('生产订单'),
            actions: <Widget>[
              IconButton(
                icon: Icon(B2BIcons.search,size: 20,),
                onPressed: () => showSearch(
                    context: context, delegate: PurchaseOrderSearchDelegate()),
              ),
            ],
          ),
          body: DefaultTabController(
            length: statuses.length,
            child: Scaffold(
              appBar: TabBar(
                unselectedLabelColor: Colors.black26,
                labelColor: Colors.black38,
                tabs: statuses.map((status) {
                  return Tab(text: status.name);
                }).toList(),
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
                isScrollable: true,
              ),
              body: TabBarView(
                children: statuses
                    .map((status) => PurchaseOrderList(
                  status: status,
                )).toList(),
              ),
            ),
          ),
          floatingActionButton: ToTopBtn(),
        ));
  }

}

class PurchaseOrderList extends StatelessWidget {
  PurchaseOrderList({Key key, this.status}) : super(key: key);

  final EnumModel status;

  ScrollController _scrollController = new ScrollController();


  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<PurchaseOrderBLoC>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses(status.code);
      }
    });

    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (_scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    //状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        _scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: RefreshIndicator(
            onRefresh: () async {
              return await bloc.refreshData(status.code);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              children: <Widget>[
                StreamBuilder<List<PurchaseOrderModel>>(
                  stream: bloc.stream,
                  // initialData: null,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PurchaseOrderModel>> snapshot) {
                    if (snapshot.data == null) {
                      bloc.filterByStatuses(status.code);
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 200),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data.map((order) {
                          return PurchaseOrderItem(
                            order: order,
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                  },
                ),
                StreamBuilder<bool>(
                  stream: bloc.bottomStream,
                  initialData: false,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.data) {
                      _scrollController.animateTo(_scrollController.offset - 70,
                          duration: new Duration(milliseconds: 500),
                          curve: Curves.easeOut);
                    }
                    return snapshot.data
                        ? Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                            child: Center(
                              child: Text(
                                "人家可是有底线的。。。",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
                StreamBuilder<bool>(
                  stream: bloc.loadingStream,
                  initialData: false,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Center(
                        child: new Opacity(
                          opacity: snapshot.data ? 1.0 : 0,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
        )
    );
  }
}

class PurchaseOrderItem extends StatelessWidget {
  PurchaseOrderItem({Key key, this.order}) : super(key: key);

  final PurchaseOrderModel order;

  static Map<PurchaseOrderStatus, MaterialColor> _statusColors = {
    PurchaseOrderStatus.PENDING_PAYMENT: Colors.red,
    PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE: Colors.yellow,
    PurchaseOrderStatus.OUT_OF_STORE: Colors.yellow,
    PurchaseOrderStatus.IN_PRODUCTION: Colors.yellow,
    PurchaseOrderStatus.COMPLETED: Colors.green,
    PurchaseOrderStatus.CANCELLED: Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: EdgeInsets.fromLTRB(0, 0, 5, 10),
        child: Column(
          children: <Widget>[
            _buildOrderHeader(context),
            _buildContent(context),
            bloc.isBrandUser ?
            _buildBrandButton(context):
            _buildFactoryButton(context),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {
        //根据code查询
        PurchaseOrderModel model = await PurchaseOrderRepository().getPurchaseOrderDetail(order.code);

        if (model != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PurchaseOrderDetailPage(
                order: model,
              ))
          );
        }
      },
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                (order.depositPaid == false && order.status == PurchaseOrderStatus.PENDING_PAYMENT ) ||
            (order.balancePaid == false && order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE ) ?
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '￥',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${order.depositPaid == false && order.status == PurchaseOrderStatus.PENDING_PAYMENT ?
                      order.deposit : order.balance}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ):
                Container(
                    child:order.delayed ?
                    Text(
                        '已延期',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        )
                    ) : Container()
                ),
                Expanded(
                  child: Container(
                    child: _buildHeaderText(context),
                  )
                ),
                order.status == null ? Container() :
                Text(
                  '${PurchaseOrderStatusLocalizedMap[order.status]}',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 18,
                      color:  _statusColors[order.status],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Text(
                      '${order.belongTo == null ? order.companyOfSeller : order
                          .belongTo.name}',
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
                Text(
                  '${order.salesApplication == null ? '' : SalesApplicationLocalizedMap[order.salesApplication]}',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 16),
                )
              ],
            )
          ],
        ));
  }

  Widget _buildHeaderText(BuildContext context){
    if(order.depositPaid == false && order.status == PurchaseOrderStatus.PENDING_PAYMENT ){
          return Text(
            '（待付定金）',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          );
    }
    else if(order.balancePaid == false && order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE ){
      return Text(
        '（待付尾款）',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      );
    }
    else{
      return Text(
        '${PurchaseOrderStatusLocalizedMap[order.status]}',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 18,
          color: Colors.red,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }

  Widget _buildContent(BuildContext context) {
    //计算总数
    int sum = 0;
    order.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });
    return Container(
        padding: EdgeInsets.fromLTRB(10,0,10,0),
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image:  order.product == null ||  order.product.thumbnail == null?
                    AssetImage(
                      'temp/picture.png',
                      package: "assets",
                    ):
                    NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${order.product.thumbnail.url}'),
                    fit: BoxFit.cover,
                  )),
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: order.product == null || order.product.name == null?
                            Container():
                            Text(
                              '${order.product.name}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                '货号：${order.product == null ? '' : order.product.skuID}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            )),
                        order.product == null || order.product.category == null?
                        Container() :
                        Container(
                            padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 243, 243, 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "${order.product.category.name}  ${sum}件",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(255, 133, 148, 1)),
                          ),
                        )
                      ],
                    )))
          ],
        ));
  }

  Widget _buildBrandButton(BuildContext context){
    if(order.salesApplication == SalesApplication.ONLINE){
      if(order.depositPaid == false && order.status == PurchaseOrderStatus.PENDING_PAYMENT){
        return Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.only(right: 30),
                width: 150,
                child: FlatButton(
                    color: Color(0xFFFFD600),
                    child: Text(
                      '去支付',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20))),
                    onPressed: () {
                      //todo 接通支付页面
                    }
                ),
              ),
            )
        );
      }
      else if(order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE){
        if(order.balancePaid == false && order.balance > 0){
          return Container(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.only(right: 30),
                  width: 150,
                  child: FlatButton(
                      color: Color(0xFFFFD600),
                      child: Text(
                        '去支付',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                      onPressed: () {
                        //todo 接通支付页面
                      }
                  ),
                ),
              )
          );
        }else{
          return Container(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.only(right: 30),
                  width: 150,
                  child: FlatButton(
                      color: Color(0xFFFFD600),
                      child: Text(
                        '确认',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                      onPressed: () {}
                  ),
                ),
              )
          );
        }
      }
      if (order.status == PurchaseOrderStatus.OUT_OF_STORE) {
        return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 10),
                width: 150,
                child: FlatButton(
                    color: Colors.white,
                    child: Text(
                      '查看物流',
                      style: TextStyle(
                        color: Color(0xFF969696),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        side: BorderSide(
                            color: Color(0xFF969696),
                            style: BorderStyle.solid,
                            width: 2)),
                    clipBehavior: Clip.antiAlias,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onPressed: () {}
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                width: 150,
                child: FlatButton(
                    color: Colors.white,
                    child: Text(
                      '确认收货',
                      style: TextStyle(
                        color: Color(0xFFFFD600),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(20)),
                      side: BorderSide(
                          color: Color(0xFFFFD600),
                          style: BorderStyle.solid,
                          width: 2),
                    ),
                    onPressed: () async {
                      bool result = false;

                      result = await PurchaseOrderRepository().purchaseOrderShipped(order.code, order);
                      _showMessage(context, result, '确认收货');
                    }
                ),
              ),
            ],
          ),
        );
      }
      else {
        return Container();
      }
    }else{
      return Container();
    }
  }

  Widget _buildFactoryButton(BuildContext context){
    //流程是待付款状态并定金未付的情况下能修改订单金额
    if (order.status == PurchaseOrderStatus.PENDING_PAYMENT && order.depositPaid == false) {
        return Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.only(right: 30),
                width: 150,
                child: FlatButton(
                    color: Colors.red,
                    child: Text(
                      '修改金额',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20))),
                    onPressed: () {
                      _showDepositDialog(context,order);
                    }
                ),
              ),
            )
        );
    }
   //流程是生产中时，显示验货完成按钮
   else if(order.status == PurchaseOrderStatus.IN_PRODUCTION && order.currentPhase == ProductionProgressPhase.INSPECTION){
       return Container(
         child: Align(
           alignment: Alignment.bottomRight,
           child: Container(
             padding: EdgeInsets.only(right: 30),
             width: 150,
             child: FlatButton(
                 color: Color(0xFFFFD600),
                 child: Text(
                   '验货完成',
                   style: TextStyle(
                     color: Colors.white,
                     fontWeight: FontWeight.w500,
                     fontSize: 18,
                   ),
                 ),
                 shape: RoundedRectangleBorder(
                     borderRadius:
                     BorderRadius.all(Radius.circular(20))),
                 onPressed: () {
                   _showBalanceDialog(context, order);
                 }
             ),
           ),
         )
     );
   }
    //当流程是待出库状态下
   else if(order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE){
     //尾款已付时，出现确认发货
     if(order.balancePaid || order.salesApplication == SalesApplication.BELOW_THE_LINE){
       return Container(
           child:
           Align(
             alignment: Alignment.bottomRight,
             child: Container(
               padding: EdgeInsets.only(right: 30),
               width: 150,
               child: FlatButton(
                   color: Color(0xFFFFD600),
                   child: Text(
                     '确认发货',
                     style: TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.w500,
                       fontSize: 18,
                     ),
                   ),
                   shape: RoundedRectangleBorder(
                       borderRadius:
                       BorderRadius.all(Radius.circular(20))),
                   onPressed: () {
                     //todo 接填写物流单号页面再保存数据
                   }
               ),
             ),
           )
       );
     }else if(order.salesApplication == SalesApplication.ONLINE && !order.balancePaid){ //未付尾款时可以修改金额
      return Container(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(right: 20),
              width: 150,
              child: FlatButton(
                  color: Colors.red,
                  child: Text(
                    '修改金额',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(20))),
                  onPressed: () {
                    _showBalanceDialog(context, order);
                  }
              ),
            ),
          )
      );
     }
   }
    //当流程是已出库时，可以查看物流
   else if(order.status == PurchaseOrderStatus.OUT_OF_STORE){
     return Container(
         child: Align(
           alignment: Alignment.bottomRight,
           child: Container(
             padding: EdgeInsets.only(right: 30),
             width: 150,
             child: FlatButton(
                 color: Color(0xFFFFD600),
                 child: Text(
                   '查看物流',
                   style: TextStyle(
                     color: Colors.white,
                     fontWeight: FontWeight.w500,
                     fontSize: 18,
                   ),
                 ),
                 shape: RoundedRectangleBorder(
                     borderRadius:
                     BorderRadius.all(Radius.circular(20))),
                 onPressed: () {
                   //todo 接通查看物流信息页面
                 }
             ),
           ),
         )
     );
   }else{
     return Container();
   }

  }

  //修改金额按钮方法
  Future<void> _neverUpdateBalance(BuildContext context,PurchaseOrderModel model) async {
    TextEditingController dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '订单总额：￥${model.totalPrice}',
                ),
                Text(
                  '已付定金：￥${model.deposit}',
                ),
                Text(
                  '应付尾款：￥${model.totalPrice != null && model.deposit != null ? model.totalPrice-model.deposit : ''}',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  color: Colors.black12,
                  child: TextField(
                    controller:dialogText,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '请输入尾款',
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 30),
                  width: 230,
                  child: FlatButton(
                      color: Color(0xFFFFD600),
                      child: Text(
                        '确定',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                      onPressed: () async {
                        bool result = false;
                        double balance = dialogText.text == null || dialogText.text == '' ? model.balance : double.parse(dialogText.text);
                        model.balance = balance;
                        model.skipPayBalance = false;
                        try {
                           await PurchaseOrderRepository().purchaseOrderBalanceUpdate(model.code, model);
                        } catch (e) {
                          print(e);
                        }
                        if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
                          try {
                            for(int i=0;i<order.progresses.length;i++){
                              if(order.currentPhase == order.progresses[i].phase){
                                result = await PurchaseOrderRepository().productionProgressUpload(order.code,order.progresses[i].id.toString(),order.progresses[i]);
                              }
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                        Navigator.of(context).pop();
                        _showMessage(context,result,'修改尾款');
                      }
                  ),
                ),
                FlatButton(
                  child: Text(
                      '无需付款直接跳过>>',
                    style: TextStyle(
                      color: Colors.grey
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showTips(context,model);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  //修改定金
  Future<void> _neverUpdateDeposit(BuildContext context,PurchaseOrderModel model) async {
    TextEditingController depositText = TextEditingController();
    TextEditingController unitText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '订单总额：￥${model.totalPrice}',
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  color: Colors.black12,
                  child: TextField(
                    controller:depositText,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '定金：￥${model.deposit}',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  color: Colors.black12,
                  child: TextField(
                    controller:unitText,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '单价：￥${model.unitPrice}',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 30),
                  width: 230,
                  child: FlatButton(
                      color: Color(0xFFFFD600),
                      child: Text(
                        '确定',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                      onPressed: () async {
                        bool result = false;
                        double unit = unitText.text == null || unitText.text == '' ? model.unitPrice : double.parse(unitText.text);
                        double deposit = depositText.text == null || depositText.text == '' ? model.deposit : double.parse(depositText.text);
                        model.deposit = deposit;
                        model.unitPrice = unit;
                        model.skipPayBalance = false;
                        try {
                          result = await PurchaseOrderRepository().purchaseOrderBalanceUpdate(model.code , model);
                        } catch (e) {
                          print(e);
                        }
                        Navigator.of(context).pop();
                        _showMessage(context,result,'修改定金');
                      }
                  ),
                ),
          ],
        );
      },
    );
  }

  //打开修改尾款金额弹框
  void _showBalanceDialog(BuildContext context,PurchaseOrderModel model){
    _neverUpdateBalance(context,model);
  }

  //打开修改定金金额弹框
  void _showDepositDialog(BuildContext context,PurchaseOrderModel model){
    _neverUpdateDeposit(context,model);
  }

  void _showTips(BuildContext context,PurchaseOrderModel model){
    _neverComplete(context,model);
  }

  void _showMessage(BuildContext context,bool result,String message){
    _requestMessage(context,result == true? '${message}成功' : '${message}失败');
    PurchaseOrderBLoC.instance.refreshData('ALL');
  }

  //确认跳过按钮
  Future<void> _neverComplete(BuildContext context,PurchaseOrderModel model) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('是否无需付款直接跳过？'),
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
                bool result = false;
                model.balance = 0;
                model.skipPayBalance = true;
                try {
                  await PurchaseOrderRepository().purchaseOrderBalanceUpdate(model.code , model);
                  if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
                    try {
                      for(int i=0;i<order.progresses.length;i++){
                        if(order.currentPhase == order.progresses[i].phase){
                          result = await PurchaseOrderRepository().productionProgressUpload(order.code,order.progresses[i].id.toString(),order.progresses[i]);
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                } catch (e) {
                  print(e);
                }
                Navigator.of(context).pop();
                _showMessage(context,result,'验货');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestMessage(BuildContext context,String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return SimpleDialog(
          title: const Text('提示'),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('${message}'),
            ),
          ],
        );
      },
    );
  }


//  //确认发货按钮
//  Future<void> _neverDelivering(BuildContext context,PurchaseOrderModel model) async {
//    return showDialog<void>(
//      context: context,
//      barrierDismissible: true, // user must tap button!
//      builder: (context) {
//        return AlertDialog(
//          title: Text('提示'),
//          content: Text('是否确认发货？'),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('取消'),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//            FlatButton(
//              child: Text('确定'),
//              onPressed: () async {
//                model.balance = 0;
//                model.skipPayBalance = true;
//                try {
//                  await PurchaseOrderRepository().purchaseOrderBalanceUpdate(model.code , model);
//                  if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
//                    try {
//                      for(int i=0;i<order.progresses.length;i++){
//                        if(order.currentPhase == order.progresses[i].phase){
//                          await PurchaseOrderRepository().productionProgressUpload(order.code,order.progresses[i].id.toString(),order.progresses[i]);
//                        }
//                      }
//                    } catch (e) {
//                      print(e);
//                    }
//                  }
//                } catch (e) {
//                  print(e);
//                }
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

}

class ToTopBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<PurchaseOrderBLoC>(context);

    return StreamBuilder<bool>(
        stream: bloc.toTopBtnStream,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return snapshot.data
              ? FloatingActionButton(
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    bloc.returnToTop();
                  },
                  backgroundColor: Colors.blue,
                )
              : Container();
        });
  }

}
