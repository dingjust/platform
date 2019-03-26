import 'package:b2b_commerce/src/business/orders/production_progresses.dart';
import 'package:b2b_commerce/src/production/production_generate_unique_code.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

final List<OrderStatusModel> _statusList = [
  OrderStatusModel.fromJson({
    'code': 'PENDING_PAYMENT',
    'name': '待付款',
    'sort': 1,
  }),
  OrderStatusModel.fromJson({
    'code': 'IN_PRODUCTION',
    'name': '生产中',
    'sort': 2,
  }),
  OrderStatusModel.fromJson({
    'code': 'WAIT_FOR_OUT_OF_STORE',
    'name': '待出库',
    'sort': 3,
  }),
  OrderStatusModel.fromJson({
    'code': 'OUT_OF_STORE',
    'name': '已出库',
    'sort': 4,
  }),
  OrderStatusModel.fromJson({
    'code': 'COMPLETED',
    'name': '已完成',
    'sort': 5,
  }),
];

class PurchaseOrderDetailPage extends StatefulWidget {
  final PurchaseOrderModel order;

  final bool isProduction;

  PurchaseOrderDetailPage(
      {Key key, @required this.order, this.isProduction = false})
      : super(key: key);

  _PurchaseDetailPageState createState() =>
      _PurchaseDetailPageState(order: order);
}

class _PurchaseDetailPageState extends State<PurchaseOrderDetailPage> {
  TextEditingController dialogText;
  List<ApparelSizeVariantProductEntry> mockData = new List();
  DateTime _blDate;
  bool isShowButton = false;
  String userType;
  String _blNumber;
  String remarks;
  bool isHide = true;

  final PurchaseOrderModel order;
  _PurchaseDetailPageState({this.order});

  @override
  void initState() {
    mockData.clear();
    //把颜色尺码封装成ApparelSizeVariantProductEntry
    if(order.entries.isNotEmpty){
      for (int i = 0; i < order.entries.length; i++) {
        if(order.entries[i].product.color != null && order.entries[i].product.size != null){
          ApparelSizeVariantProductEntry entry = new ApparelSizeVariantProductEntry();
          entry.quantity = order.entries[i].quantity;
          entry.model = order.entries[i].product;
          mockData.add(entry);
        }
      }
    }
    //控制是否显示按钮
    if(order.status == PurchaseOrderStatus.PENDING_PAYMENT ||
        (order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE && order.balancePaid == false)){
      isShowButton = true;
    }

    final bloc = BLoCProvider.of<UserBLoC>(context);
    if(bloc.isBrandUser){
      userType = 'brand';
    }else{
      userType = 'factory';
    }

    super.initState();
  }

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
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: Text('生产订单明细'),
          actions: <Widget>[
            order.salesApplication == null ? Container() : Container(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Center(
                child: Text(
                  '${SalesApplicationLocalizedMap[order.salesApplication]}'
                ),
              ),
            ),
          ],
        ),
        body: Container(
            child: ListView(
          children: <Widget>[
//            Container(
//              color: Colors.white,
//              padding: EdgeInsets.only(left: 10),
//              child: StatusStep(
//                list: _statusList,
//                currentStatus: PurchaseOrderStatusLocalizedMap[order.status],
//                isScroll: false,
//              ),
//            ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${PurchaseOrderStatusLocalizedMap[order.status]}',
                style: TextStyle(
                  color: _statusColors[order.status],
                  fontSize: 18
                ),
              ),
            ),
          ),
            _buildEntries(context),
            _buildProductHide(context),
            _buildProductInfo(context),
            order.status == PurchaseOrderStatus.PENDING_PAYMENT &&
                order.depositPaid == false ?
            _buildTipsPayment(context)
                : _buildPurchaseProductionProgresse(context),
            _buildDeliveryAddress(context),
            userType != null && userType == 'brand' ?
            _buildFactoryInfo(context) :
            _buildBrandInfo(context),
            _buildDocutment(context),
            _buildRemarks(context),
            _buildBottom(context),
            _buildCommitButton(context),
          ],
            )));
  }

  //商品详情
  Widget _buildEntries(BuildContext context) {
    //计算总数
    int sum = 0;
    order.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });
    return order.product == null ?
    Container() :
    Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          order.product != null  && order.product.thumbnail != null
              && order.product.thumbnail.name != null
              ? Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${order.product.thumbnail.url}'),
                  fit: BoxFit.cover,
                )),
          )
              : Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(243, 243, 243, 1)),
            child: Icon(
              B2BIcons.noPicture,
              color: Color.fromRGBO(200, 200, 200, 1),
              size: 25,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  order.product == null || order.product.name == null ?
                  Container() :
                  Text(
                    order.product.name,
                    style: TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child:  order.product == null || order.product.skuID == null ?
                    Container() :
                    Text(
                      '货号：${order.product.skuID}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: order.product == null || order.product.category == null ?
                    Container() :
                    Text(
                      "${order.product.category.name}  ${sum}件",
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

  //底部订单信息
  Widget _buildBottom(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: order.code == null ?
            Container() :
            Text('生产订单号：${order.code}'),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: order.requirementOrderCode == null ?
              Container() :
              Text('需求订单号：${order.requirementOrderCode}')),
          Align(
              alignment: Alignment.centerLeft,
              child: order.creationTime == null ?
              Container() :
              Text('订单生成时间：${DateFormatUtil.formatYMD(order.creationTime)}')),
          Align(
              alignment: Alignment.centerLeft,
              child: order.expectedDeliveryDate == null ?
              Container() :
              Text('预计交货时间：${DateFormatUtil.formatYMD(order.expectedDeliveryDate)}')),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

//构建工厂信息UI
  Widget _buildFactoryInfo(BuildContext context) {
    return Container(
//      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child:
                      order.belongTo == null ||
                          order.belongTo.name == null ?
                      Text(
                        '${order.companyOfSeller == null ? '' : order
                            .companyOfSeller}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ) :
                      Text(
                        order.belongTo.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    order.belongTo == null ||
                        order.belongTo.starLevel == null ?
                    Container() :
                    Stars(
                      size: 14,
                      color: Color.fromRGBO(255, 183, 0, 1),
                      highlightOnly: false,
                      starLevel: order.belongTo.starLevel,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '历史接单${order.belongTo == null || order.belongTo.historyOrdersCount == null ? '0' : order.belongTo.historyOrdersCount}单，报价成功率0%',
                        style: TextStyle(
                            color: Colors.grey
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right)

                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            title: Text('加工类型'),
            trailing: order.machiningType == null ? Container():Text(MachiningTypeLocalizedMap[order.machiningType]),
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            title: Text('是否开具发票'),
            trailing: order.invoiceNeeded == null ? Container():Text(order.invoiceNeeded == true ? '是' : '否'),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //品牌信息UI
  Widget _buildBrandInfo(BuildContext context){
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image:  order.purchaser == null ||  order.purchaser.profilePicture == null?
                  AssetImage(
                    'temp/picture.png',
                    package: "assets",
                  ):
                  NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${order.purchaser.profilePicture}'),
                  fit: BoxFit.cover,
                )),
          ),
          Text(
            '${order.purchaser == null || order.purchaser.name == null ? order.companyOfSeller : order.purchaser.name}',
            textScaleFactor: 1.3,
          ),
        ],
      ),
    );
  }

//构建收货信息UI
  Widget _buildDeliveryAddress(BuildContext context) {
    return Container(
//      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              B2BIcons.location,
              color: Colors.black,
            ),
            title: Row(
              children: <Widget>[
                 order.deliveryAddress == null ||
                      order.deliveryAddress.fullname == null ?
                  Container() :
                  Text(order.deliveryAddress.fullname),
                order.deliveryAddress == null ||
                    order.deliveryAddress.cellphone == null ?
                Container() :
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(order.deliveryAddress.cellphone),
                )
              ],
            ),
            subtitle: order.deliveryAddress == null ||
                order.deliveryAddress.region == null ||
                order.deliveryAddress.city == null ||
                order.deliveryAddress.cityDistrict == null ||
                order.deliveryAddress.line1 == null ?
            Container() :
            Text(
                order.deliveryAddress.region.name +
                    order.deliveryAddress.city.name +
                    order.deliveryAddress.cityDistrict.name +
                    order.deliveryAddress.line1,
                style: TextStyle(
                  color: Colors.black,
                )),
          ),
          SizedBox(
            child: Image.asset(
              'temp/common/address_under_line.png',
              package: 'assets',
              fit: BoxFit.fitWidth,
            ),
          ),
          ListTile(
            title: Text("物流信息"),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

//构建生产进度UI
  Widget _buildPurchaseProductionProgresse(BuildContext context) {
    int _index = 0;
    if(order.progresses != null ){
      for (int i = 0; i < order.progresses.length; i++) {
        if (order.currentPhase == order.progresses[i].phase) {
          _index = order.progresses[i].sequence;
          break;
        }
      }
    }

    return order.progresses == null ?
    Container():
    Container(
      padding: EdgeInsets.only(right: 15),
      child: _index == 0
          ? Column(
              children: <Widget>[
                _buildProductionProgress(
                    context, order.progresses[_index], true),
                _buildProductionProgress(
                    context, order.progresses[_index + 1], false),
                Container(
                  width: 200,
                    padding: EdgeInsets.fromLTRB(50, 0, 10, 0),
                    child: OutlineButton(
                      child: Text(
                        '查看全部',
                        style: TextStyle(color: Colors.black),
                      ),
                      borderSide: BorderSide(color:Colors.black),
                      shape: RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductionProgressesPage(order: order),
                          ),
                        );
                      },
                    ))
              ],
            )
          : Column(
              children: <Widget>[
//                _buildProductionProgress(
//                    context, order.progresses[_index - 1], false),
                _buildProductionProgress(
                    context, order.progresses[_index], true),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(50, 0, 10, 0),
                    child: RaisedButton(
                      elevation: 0,
                      color:  Color(0xFFFFD600),
                      child: Text(
                        '查看全部',
                        style: TextStyle(color: Colors.black),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductionProgressesPage(order: order),
                          ),
                        );
                      },
                    ))
              ],
            ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //TimeLineUI
  Widget _buildProductionProgress(BuildContext context,
      ProductionProgressModel productionProgress, bool isCurrentStatus) {
    return Stack(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: _buildProgressTimeLine(
                context, productionProgress, isCurrentStatus)),
        Positioned(
          top: 30.0,
          bottom: 0.0,
          left: 17.5,
          child: Container(
            height: double.infinity,
            width: 1.3,
            color: isCurrentStatus == true ? Color(0xFFFFD600) : Colors.black45,
          ),
        ),
        Positioned(
          top: 26.0,
          left: 10.0,
          child: Container(
            height: 16.0,
            width: 16.0,
            child: Container(
              margin: EdgeInsets.all(3.0),
              height: 16.0,
              width: 16.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrentStatus == true
                      ? Color(0xFFFFD600)
                      : Colors.black),
            ),
          ),
        )
      ],
    );
  }

//TimeLineUI右边的Card部分
  Widget _buildProgressTimeLine(BuildContext context,
      ProductionProgressModel productionProgress, bool isCurrentStatus) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('${ProductionProgressPhaseLocalizedMap[productionProgress.phase]} ' ,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCurrentStatus == true
                              ? Color(0xFFFFD600)
                              : Colors.black54,
                          fontSize: 18)
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    '${productionProgress.delayedDays >0 ? '已延期${productionProgress.delayedDays}天': '' }',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    isCurrentStatus == true ?
                    _buildEstimatedDate(context,productionProgress,isCurrentStatus):
                    _buildFinishDate(context,productionProgress,isCurrentStatus),
                    _buildQuantity(context,productionProgress,isCurrentStatus),
                  ],
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image:  productionProgress.medias == null || productionProgress.medias.isEmpty?
                        AssetImage(
                          'temp/picture.png',
                          package: "assets",
                        ):
                        NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${productionProgress.medias[0].url}'),
                        fit: BoxFit.fill,
                      )),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PicturePickPreviewWidget(
                        medias: productionProgress.medias,
                        isUpload: isCurrentStatus == true ? true : false,
                      ))
                  ).then((value){
                    if(value != null){
                      productionProgress.medias = value;
                      productionProgress.updateOnly = true;
                      uploadPicture(productionProgress);
                    }
                  });
                },
              ),
            ],
          ),
          _buildProgressRemarks(context, productionProgress, isCurrentStatus),
        ],
      ),
    );
  }


  Widget _buildEstimatedDate(BuildContext context,ProductionProgressModel progress,bool isCurrentStatus){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
                child: Text('预计完成时间',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  userType != null && userType == 'factory' && isCurrentStatus == true ?
                  _showDatePicker(progress) : null;
                }),
          ),
          GestureDetector(
              child:Align(
                alignment: Alignment.centerRight,
                child:
                progress.estimatedDate == null? Container():
                Text('${DateFormatUtil.formatYMD(
                    progress.estimatedDate)}',
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              onTap: () {
                userType != null && userType == 'factory' && isCurrentStatus == true ?
                _showDatePicker(progress) : null;
              }),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () {
                  userType != null && userType == 'factory' && isCurrentStatus == true ?
                  _showDatePicker(progress) : null;
                }
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFinishDate(BuildContext context,ProductionProgressModel progress,bool isCurrentStatus){
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text('实际完成时间', style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            child:
            progress.finishDate == null ? Container() :
            Text('${DateFormatUtil.formatYMD(progress.finishDate)}',
                style: TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantity(BuildContext context,ProductionProgressModel progress,bool isCurrentStatus){
    return Container(
      child: Container(
        height: 35,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                  child: Text('数量',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    userType != null && userType == 'factory' && isCurrentStatus == true ?
                    _showDialog(progress): null;
                  }),
            ),
            GestureDetector(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('${progress.quantity}',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ),
                onTap: () {
                  userType != null && userType == 'factory' && isCurrentStatus == true ?
                  _showDialog(progress)
                      : null;
                }
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: (){
                    userType != null && userType == 'factory' && isCurrentStatus == true ?
                    _showDialog(progress) : null;
                  }
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRemarks(BuildContext context,ProductionProgressModel progress,bool isCurrentStatus){
    return Container(
        child: GestureDetector(
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                  children: <Widget>[
                     Text('备注', style: TextStyle(fontWeight: FontWeight.w500)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: progress.remarks == null?
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '填写',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ):
                            Container(
                              child: Text(
                                '${progress.remarks}',
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines:2,
                              ),
                            )
                        ),
                      ),
                    )
                  ])
          ),
          onTap: () async {
            userType != null && userType == 'factory' && isCurrentStatus == true ?
            _showRemarksDialog(progress,'备注') : null;
          },
        )
    );
  }


  //提示付款信息
  Widget _buildTipsPayment(BuildContext context){
    final bloc = BLoCProvider.of<UserBLoC>(context);
    return order.depositPaid == false?Container(
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        padding: EdgeInsets.fromLTRB(0,20,0,20),
        child: Text(
          bloc.isBrandUser ?
          '生产状态尚未开始，请先付订金' : '生产状态尚未开始，待客户付定金',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    ):Container();
  }

  // 提示隐藏商品颜色尺码UI
  Widget _buildProductHide(BuildContext context){
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "生产商品详情",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Icon(
                    isHide?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,
                    color: Colors.grey,
                    size: 28,
                  ),
                ],
              )
          ),
        ),
        onTap: () {
          setState(() {
            isHide = !isHide;
          });
        }
    );
  }
  //商品的颜色尺码及价格
  Widget _buildProductInfo(BuildContext context){
    return mockData.isEmpty?Container():
    Offstage(
      offstage: isHide,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ColorSizeNumTable(
                data: mockData,
              ),
            ),
            Container(
              child: ListTile(
                  leading: Text(
                    '生产单价',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '￥',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        '${order.unitPrice == null? '' :order.unitPrice}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      )
                    ],
                  )
              ),
            ),
            Container(
              child: ListTile(
                  leading: Text(
                    '合计',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '￥',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        '${order.totalPrice == null ? '' : order.totalPrice}',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.red,
                        ),
                      )
                    ],
                  )
              ),
            ),
            order.salesApplication != SalesApplication.BELOW_THE_LINE ?
            Container(
              child: ListTile(
                trailing: Container(
                  child: RaisedButton(
                    elevation: 0,
                    color: Color(0xFFFFD600),
                    child: Text(
                      '查看报价',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(20))),
                    onPressed: () {
                    },
                  ),
                ),
              ),
            ):Container(),
            Divider(
              height: 1,
            ),
            Container(
              child: ListTile(
                  leading: Text(
                    '定金',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '￥',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        '${order.deposit == null? '' : order.deposit}',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.red,
                        ),
                      )
                    ],
                  )
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }


  //备注
  Widget _buildRemarks(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0,10,0,10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '备注',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: order.remarks == null? Container():
                    Text(
                      '${order.remarks}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ),
              ],
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //构建附件UI
  Widget _buildDocutment(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: Attachments(list: order.attachments),
    );
  }

  //按钮UI，判断用户类型展示按钮
  Widget _buildCommitButton(BuildContext context) {
    if(userType == 'brand'){
      if(order.salesApplication == SalesApplication.BELOW_THE_LINE){
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildBrandButton(context),
            _buildOfflineButton(context),
          ],
        );
      }else{
        _buildBrandButton(context);
      }
    }else{
      if(order.salesApplication == SalesApplication.BELOW_THE_LINE){
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildFactoryButton(context),
            _buildOfflineButton(context),
          ],
        );
      }else{
        _buildFactoryButton(context);
      }
    }
  }

  //线下单显示按钮
  Widget _buildOfflineButton(BuildContext context) {
    return Container(
        width: 300,
        margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: 40,
        child: FlatButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '唯一码',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(20))),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductionGenerateUniqueCodePage(
                            model: widget.order,
                          )));
            }
        )
    );
  }

  //品牌端支付按钮
  Widget _buildShowBrandButton(BuildContext context){
    return isShowButton == true?
    Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 40,
                child: order.status == PurchaseOrderStatus.PENDING_PAYMENT ?
                RaisedButton(
                    color: Colors.red,
                    child: Text(
                      '取消订单',
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
                        bool result = false;

                    })
                    :Container()
            ),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 40,
                child: RaisedButton(
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
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        // user must tap button!
                        builder: (context) {
                          return  AlertDialog(
                            title: Text('您的默认收货地址为：'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      '${order.deliveryAddress.fullname ==
                                          null ? '' : order.deliveryAddress.fullname}  '
                                          '${order.deliveryAddress.cellphone == null ? '' :
                                      order.deliveryAddress.cellphone}',
                                    ),
                                    subtitle: Text(
                                      '${order.deliveryAddress == null  ? '':
                                      order.deliveryAddress.region.name} ${order.deliveryAddress.city.name} '
                                          '${order.deliveryAddress.cityDistrict.name} ${order.deliveryAddress.line1}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.keyboard_arrow_right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  width:100,
                                  child: RaisedButton(
                                      child: Text("不，在看看"),
                                      textTheme: ButtonTextTheme.normal,
                                      textColor: Color(0xFFFFD600),
                                      color: Colors.white,
                                      // 主题
                                      // RaisedButton 才起效
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          side: BorderSide(
                                              color: Color(0xFFFFD600),
                                              style: BorderStyle.solid,
                                              width: 1)),
                                      materialTapTargetSize: MaterialTapTargetSize
                                          .padded,
                                      animationDuration: Duration(
                                          seconds: 1),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }
                                  ),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    width:100,
                                    child: RaisedButton(
                                        child: Text("是"),
                                        textTheme: ButtonTextTheme.normal,
                                        textColor: Colors.white,
                                        color: Color(0xFFFFD600),
                                        // 主题
                                        // RaisedButton 才起效
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        materialTapTargetSize: MaterialTapTargetSize
                                            .padded,
                                        animationDuration: Duration(
                                            seconds: 1),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        }
                                    ),
                                  )
                              )
                            ],
                          );
                        },
                      );
                    })),
          ),
        ],
      ),
    ) : Container();
  }

  //品牌端显示按钮
  Widget _buildBrandButton(BuildContext context){
    if(order.salesApplication == SalesApplication.ONLINE){
      if(order.depositPaid == false && order.status == PurchaseOrderStatus.PENDING_PAYMENT){
        _buildShowBrandButton(context);
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
                      onPressed: () {}
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
      else if(order.status == PurchaseOrderStatus.OUT_OF_STORE){
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
                        color: Colors.black,
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
                    onPressed: () {}
                ),
              ),
            ],
          ),
        );
      }
      else {
        return Container();
      }
    } else {
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
                        color: Colors.black,
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
                    onPressed: () {}
                ),
              ),
            ],
          ),
        );
      }
      else {
        return Container();
      }
    }
  }

  //工厂端按钮
  Widget _buildFactoryButton(BuildContext context) {
    //流程是待付款状态并定金未付的情况下能修改订单金额
    if (order.status == PurchaseOrderStatus.PENDING_PAYMENT &&
        order.depositPaid == false) {
      return Container(
        width: 300,
        margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: 40,
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
              _showDepositDialog(context, order);
            }
        ),
      );
    }
    //流程是生产中时，显示验货完成按钮
//    else if (order.status == PurchaseOrderStatus.IN_PRODUCTION) {
//      return Container(
//        width: 300,
//        margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
//        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//        height: 40,
//        child: FlatButton(
//            color: Color(0xFFFFD600),
//            child: Text(
//              '验货完成',
//              style: TextStyle(
//                color: Colors.black,
//                fontWeight: FontWeight.w500,
//                fontSize: 18,
//              ),
//            ),
//            shape: RoundedRectangleBorder(
//                borderRadius:
//                BorderRadius.all(Radius.circular(20))),
//            onPressed: () {
//              _showBalanceDialog(context, order);
//            }
//        ),
//      );
//    }
    //当流程是待出库状态下
    else if (order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
      //尾款已付时，出现确认发货
      if (order.balancePaid ||
          order.salesApplication == SalesApplication.BELOW_THE_LINE) {
        return Container(
          width: 300,
          margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 40,
          child: FlatButton(
              color: Color(0xFFFFD600),
              child: Text(
                '确认发货',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(20))),
              onPressed: () {}
          ),
        );
      } else if (order.salesApplication == SalesApplication.ONLINE &&
          !order.balancePaid) { //未付尾款时可以修改金额
        return Container(
          width: 300,
          margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: 40,
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
        );
      }
    }
    //当流程是已出库时，可以查看物流
    else if (order.status == PurchaseOrderStatus.OUT_OF_STORE) {
      return Container(
        width: 300,
        margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: 40,
        child: FlatButton(
            color: Color(0xFFFFD600),
            child: Text(
              '查看物流',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(20))),
            onPressed: () {}
        ),
      );
    } else {
      return Container();
    }

  }

//生成日期选择器
  Future<Null> _selectDate(BuildContext context,ProductionProgressModel model) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2999)
    );

    if(_picked != null){
      bool result = false;
      model.estimatedDate = _picked;
      try{
        result = await PurchaseOrderRepository().productionProgressUpload(widget.order.code,model.id.toString(),model);
      }catch(e){
        print(e);
      }
      setState(() {
        _blDate = _picked;
      });
      _showMessage(context,result,'保存');
    }
  }

//生成Dialog控件
  Future<void> _neverSatisfied(BuildContext context,ProductionProgressModel model) async {
    dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入数量'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller:dialogText,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                  '取消',
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                  '确定',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16
                ),
              ),
              onPressed: () async {
                bool result = false;
                if(dialogText.text != null){
                  print(dialogText.text);
                  if(dialogText != null && dialogText.text != '') {
                    model.quantity = int.parse(dialogText.text);
                  }
                  try {
                    result = await PurchaseOrderRepository().productionProgressUpload(
                        widget.order.code, model.id.toString(), model);
                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    _blNumber = dialogText.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


//打开日期选择器
  void _showDatePicker(ProductionProgressModel model) {
    _selectDate(context,model);
  }

//打开数量输入弹框
  void _showDialog(ProductionProgressModel model){
    _neverSatisfied(context,model);
  }

  //备注输入框
  void _showRemarksDialog(ProductionProgressModel model,String type){
    _neverRemarks(context,model,type);
  }

  Future<void> _neverRemarks(BuildContext context,ProductionProgressModel model,String type) async {
    dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入${type}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller:dialogText,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                  '取消',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                  '确定',
                style: TextStyle(
                  color: Colors.black
                ),
              ),
              onPressed: () async {
                bool result = false;
                if(dialogText.text != null){
                  model.remarks = dialogText.text;
                  try {
                    model.updateOnly = true;
                    result =  await PurchaseOrderRepository().productionProgressUpload(
                        order.code, model.id.toString(), model);
                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    _blNumber = dialogText.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                        _showMessage(context,result,'修改');
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
                      result = await PurchaseOrderRepository().purchaseOrderDepositUpdate(model.code , model);
                    } catch (e) {
                      print(e);
                    }
                    Navigator.of(context).pop();
                    _showMessage(context,result,'修改');
                  }
              ),
            ),
          ],
        );
      },
    );
  }

  void uploadPicture(ProductionProgressModel model) async{
    await PurchaseOrderRepository().productionProgressUpload(order.code,model.id.toString(),model);
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
              child: Text(
                  '取消',
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                '确定',
                style: TextStyle(
                    color: Colors. black
                ),
              ),
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

  void _showMessage(BuildContext context,bool result,String message){
    _requestMessage(context,result == true? '${message}成功' : '${message}失败');
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

}
