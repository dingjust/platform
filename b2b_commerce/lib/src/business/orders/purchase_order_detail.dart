import 'package:b2b_commerce/src/business/orders/production_progresses.dart';
import 'package:b2b_commerce/src/production/production_generate_unique_code.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
                  '${SalesApplicationLocalizedMap[order.salesApplication]}',
                  style: TextStyle(color: Color(0xFFFFD600)),
                ),
              ),
            ),
          ],
        ),
        body: Container(
            child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 10),
              child: StatusStep(
                list: _statusList,
                currentStatus: PurchaseOrderStatusLocalizedMap[order.status],
                isScroll: false,
              ),
            ),
            _buildEntries(context),
            _buildProductEntry(context),
            _buildProductInfo(context),
            _buildRemarks(context),
            order.status == PurchaseOrderStatus.PENDING_PAYMENT &&
                order.depositPaid == false ?
            _buildTipsPayment(context)
                : _buildPurchaseProductionProgresse(context),
            _buildDeliveryAddress(context),
            userType != null && userType == 'brand' ?
            _buildFactoryInfo(context) :
            _buildBrandInfo(context),
            _buildDocutment(context),
            _buildBottom(context),
            widget.order.salesApplication == SalesApplication.BELOW_THE_LINE ?
            _buildOfflineButton(context) :
            _buildCommitButton(context),
          ],
            )));
  }

  Widget _buildEntries(BuildContext context) {
    return order.entries.isEmpty ?
    Container() :
    Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                      "${order.product.category.name} ${order.totalQuantity==null?'':order.totalQuantity}件",
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

  Widget _buildBottom(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
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
      child:order.belongTo == null ?
      Container(): Column(
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
                      Container() :
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
                    Text(
                        '历史接单${order.belongTo == null || order.belongTo.historyOrdersCount == null ? '0' : order.belongTo.historyOrdersCount}单，报价成功率0%',
                      style: TextStyle(
                        color: Colors.grey
                      ),
                    ),
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
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              B2BIcons.location,
              color: Colors.black,
            ),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: order.deliveryAddress == null ||
                      order.deliveryAddress.fullname == null ?
                  Container() :
                  Text(order.deliveryAddress.fullname),
                ),
                Expanded(child:
                order.deliveryAddress == null ||
                    order.deliveryAddress.cellphone == null ?
                Container() :
                Text(order.deliveryAddress.cellphone)
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
            trailing: Icon(Icons.chevron_right),
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
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(50, 0, 10, 0),
                    child: RaisedButton(
                      elevation: 0,
                      color:  Color(0xFFFFD600),
                      child: Text(
                        '查看全部',
                        style: TextStyle(color: Colors.white),
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
            )
          : Column(
              children: <Widget>[
                _buildProductionProgress(
                    context, order.progresses[_index - 1], false),
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
                        style: TextStyle(color: Colors.white),
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
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          ListTile(
            title: productionProgress.phase == null? Container():
            Text(
                ProductionProgressPhaseLocalizedMap[productionProgress.phase],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCurrentStatus == true
                        ? Color(0xFFFFD600)
                        : Colors.black54,
                    fontSize: 18)),
            trailing:
            productionProgress.phase == null? Container():
            Text(
              '',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                            child: Text('预计完成时间',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            onTap: () {
                              userType != null && userType == 'factory' && isCurrentStatus == true ?
                              _showDatePicker(productionProgress) : null;
                            }),
                      ),
                      GestureDetector(
                          child:Align(
                            alignment: Alignment.centerRight,
                            child:
                            productionProgress.estimatedDate == null? Container():
                            Text('${DateFormatUtil.formatYMD(
                                productionProgress.estimatedDate)}',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          onTap: () {
                            userType != null && userType == 'factory' && isCurrentStatus == true ?
                            _showDatePicker(productionProgress) : null;
                          }),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            icon: Icon(Icons.date_range),
                            onPressed: () {
                              userType != null && userType == 'factory' && isCurrentStatus == true ?
                              _showDatePicker(productionProgress) : null;
                            }
                        ),
                      )
                    ],
                  ),
                  isCurrentStatus == true
                      ? Container()
                      : Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('实际完成时间',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: productionProgress.finishDate == null? Container():
                              Text(
                                  '${DateFormatUtil.formatYMD(productionProgress.finishDate)}',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ),
//                            工厂端动作
                            Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: 48,
                                ))
                          ],
                        ),
                ],
              )),
          Align(
              alignment: Alignment.center,
              child: Container(
                height: 35,
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                          child: Text('数量',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          onTap: () {
                            userType != null && userType == 'factory' && isCurrentStatus == true ?
                            _showDialog(productionProgress): null;
                          }),
                    ),
                    GestureDetector(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: productionProgress.quantity == null? Container():
                          Text('${productionProgress.quantity}',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        onTap: () {
                          userType != null && userType == 'factory' && isCurrentStatus == true ?
                          _showDialog(productionProgress): null;
                        }
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          icon: Icon(Icons.keyboard_arrow_right),
                          onPressed: (){
                            userType != null && userType == 'factory' && isCurrentStatus == true ?
                            _showDialog(productionProgress) : null;
                          }
                      ),
                    )
                  ],
                ),
              )),
          Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '凭证',
                        )
                      ],
                    ),
                    userType == 'factory' ?
                    EditableAttachments(list: productionProgress.medias)
                        : Attachments(list: productionProgress.medias)
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }

  //提示付款信息
  Widget _buildTipsPayment(BuildContext context){
    final bloc = BLoCProvider.of<UserBLoC>(context);
    return order.balancePaid == false?Container(
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

  //Entry表格
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
                      //todo 跳转报价
                    },
                  ),
                ),
              ),
            ),
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

  Widget _buildProductEntry(BuildContext context){
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                    isHide?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,
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
    return PurchaseDocument(order);
  }

  Widget _buildCommitButton(BuildContext context) {
    return Container(
      child: userType == 'brand' ?
      _buildShowBrandButton(context):
      _buildShowFactoryButton(context),
    );
  }

  Widget _buildOfflineButton(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        height: 40,
        child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '唯一码',
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
                    onPressed: () {})
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
                        barrierDismissible: false,
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
                                      '${order.deliveryAddress.region ==
                                          null ||
                                          order.deliveryAddress.region
                                              .name == null ? ''
                                          : order.deliveryAddress.region
                                          .name} ${ order.deliveryAddress
                                          .city == null ||
                                          order.deliveryAddress.city
                                              .name == '' ? '' : order
                                          .deliveryAddress.city
                                          .name} ${ order.deliveryAddress
                                          .cityDistrict == null ||
                                          order.deliveryAddress
                                              .cityDistrict.name == ''
                                          ? ''
                                          : order.deliveryAddress
                                          .cityDistrict.name}  ${ order
                                          .deliveryAddress.line1 == ''
                                          ? ''
                                          : order.deliveryAddress.line1}',
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

  Widget _buildShowFactoryButton(BuildContext context){
    return Container(
        child:
        order.status != PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE ?
        _statusButton[order.status] :
        _buildWaitBalance(context)
    );
  }

  Widget _buildWaitBalance(BuildContext context) {
    return Container(
      child: order.balancePaid == true ?
      _statusButton[PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE] :
      Container(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.only(right: 20),
              width: 150,
              child: FlatButton(
                  color: Colors.red,
                  child: Text(
                    '待付尾款',
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
      ),
    );
  }

  static Map<PurchaseOrderStatus, Widget> _statusButton = {
    PurchaseOrderStatus.PENDING_PAYMENT: Container(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: EdgeInsets.only(right: 30),
            width: 150,
            child: FlatButton(
                color: Colors.red,
                child: Text(
                  '待付定金',
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
    ),
    PurchaseOrderStatus.IN_PRODUCTION: Container(
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
                onPressed: () {}
            ),
          ),
        )
    ),
    PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE: Container(
        child: Align(
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
                onPressed: () {}
            ),
          ),
        )
    ),
    PurchaseOrderStatus.OUT_OF_STORE: Container(
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
                onPressed: () {}
            ),
          ),
        )
    ),
  };

//生成日期选择器
  Future<Null> _selectDate(BuildContext context,ProductionProgressModel model) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2999)
    );

    if(_picked != null){
      model.estimatedDate = _picked;
      try{
        await PurchaseOrderRepository().productionProgressUpload(widget.order.code,model.id.toString(),model);
      }catch(e){
        print(e);
      }
      setState(() {
        _blDate = _picked;
      });
    }
  }

//生成Dialog控件
  Future<void> _neverSatisfied(BuildContext context,ProductionProgressModel model) async {
    dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                if(dialogText.text != null){
                  print(dialogText.text);
                  if(dialogText != null && dialogText.text != '') {
                    model.quantity = int.parse(dialogText.text);
                  }
                  try {
                    await PurchaseOrderRepository().productionProgressUpload(
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
}

//生产进度凭证图片
class PurchaseVoucherPic extends StatelessWidget {
  final ProductionProgressModel progressModel;

  @override
  PurchaseVoucherPic(this.progressModel);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
            list: progressModel.medias,
          )
        ],
      ),
    );
  }
}

//附件
class PurchaseDocument extends StatelessWidget {
  final PurchaseOrderModel order;

  PurchaseDocument(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          _buildDoc(context),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildDoc(BuildContext context) {
    return Container(
//      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '附件',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: Colors.grey,),
              )
            ],
          ),
          order.attachments == null || order.attachments.isEmpty ?
          Container() :
          Attachments(
            list: order.attachments,
          )
        ],
      ),
    );
  }
}
