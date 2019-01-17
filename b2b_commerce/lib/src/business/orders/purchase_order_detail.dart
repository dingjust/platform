import 'dart:io';

import 'package:b2b_commerce/src/business/orders/production_progresses.dart';
import 'package:b2b_commerce/src/business/orders/status_line.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('WAIT_FOR_PROCESSING', '待处理'),
  EnumModel('PENDING_APPROVAL', '待确认'),
  EnumModel('IN_PRODUCTION', '生产中'),
  EnumModel('OUT_OF_STORE', '已出库'),
  EnumModel('COMPLETED', '已完成'),
];

final List<OrderStatusModel> _statusList = [
  OrderStatusModel.fromJson({
    'code': 'WAIT_FOR_PROCESSING',
    'name': '待处理',
    'sort': 1,
  }),
  OrderStatusModel.fromJson({
    'code': 'PENDING_APPROVAL',
    'name': '待确认',
    'sort': 2,
  }),
  OrderStatusModel.fromJson({
    'code': 'IN_PRODUCTION',
    'name': '生产中',
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

final List<Widget> _list = new List();

final String defaultPicUrl = "https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg";

class PurchaseOrderDetailPage extends StatefulWidget{
  final PurchaseOrderModel order;

  PurchaseOrderDetailPage({Key key, @required this.order}) : super(key: key);

  _PurchaseDetailPageState createState() =>
      _PurchaseDetailPageState(order: order);
}


class _PurchaseDetailPageState extends State<PurchaseOrderDetailPage> {
  DateTime _blDate;
  String _blNumber;
  TextEditingController dialogText;
  File _image;

  final PurchaseOrderModel order;
  _PurchaseDetailPageState({this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('采购订单明细'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Container(
            child: ListView(
              children: <Widget>[
                StatusLine(
                  list: _statusList,
                  currentStatus: PurchaseOrderStatusLocalizedMap[order.status],
                  isScroll: false,
                ),
                _buildEntryUi(context),
                _buildPurchaseProductionProgresse(context),
                _buildFactoryInfo(context),
                _buildDocutment(context),
                _buildDeliveryAddress(context),
                _buildBottom(context)
              ],
            )
        )
    );
  }

  //包装订单行
  Widget _buildEntryUi(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children:
        _buildOrderEntry(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
//构建订单行UI
  List<Widget> _buildOrderEntry(BuildContext context){
    return order.entries.map((entry) {
      return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          children: <Widget>[
            Image.network(
              entry.product.thumbnail,
              width: 110,
              height: 110,
              fit: BoxFit.fill,
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              entry.product.name,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:FontWeight.w500
                              ),
                            )
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '货号：' + entry.product.skuID,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight:FontWeight.w500
                              ),
                            )
                        )
                      ],
                    )
                )
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      );
    }).toList();
  }
//构建底部UI
  Widget _buildBottom(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text('采购订单号：${order.code}'),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child:
              Text('需求订单号：${order.code}')
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('订单生成时间：${DateFormatUtil.format(order.creationTime)}')
          ),
          Align(
              alignment: Alignment.centerLeft,
              child:
              Text('预计交货时间：${DateFormatUtil.format(order.expectedDeliveryDate)}')
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
//构建工厂信息UI
  Widget _buildFactoryInfo(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(13),
            child:Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        order.belongTo.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.star),
                        Icon(Icons.star),
                        Icon(Icons.star),
                        Icon(Icons.star),
                        Icon(Icons.star),
                      ],
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                          '报价：',
                          style:TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.w500
                          )
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: <Widget>[
                            Text(order.belongTo.contactAddress.region.name+order.belongTo.contactAddress.city.name+order.belongTo.contactAddress.cityDistrict.name),
                            Icon(Icons.chevron_right),
                          ],
                        )
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('历史接单26单，报价成功率34%'),
                  ],
                )
              ],
            ),
          ),
          ListTile(
            title: Text('加工类型'),
            trailing: Text(order.machiningType),
          ),
          new Divider(),
          ListTile(
            title: Text('是否开具发票'),
            trailing: Text(order.invoiceNeeded==true?'是':'否'),
          ),
          new Divider(),
          ListTile(
            title: Text('合计金额'),
            trailing: Text(
                '￥'+order.totalPrice.toString(),
                style:TextStyle(
                    fontSize: 18,
                    color:Colors.red
                )
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
//构建收货信息UI
  Widget _buildDeliveryAddress(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.add_location,
              color: Colors.orange,
            ),
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(order.deliveryAddress.fullname),
                ),
                Expanded(
                    child: Text(order.deliveryAddress.cellphone)
                )
              ],
            ),
            subtitle: Text(order.deliveryAddress.region.name + order.deliveryAddress.city.name + order.deliveryAddress.cityDistrict.name + order.deliveryAddress.line1),
            trailing: Icon(Icons.chevron_right),
          ),
          Divider(
            height: 1,
            color: Colors.indigo,
          ),
          Divider(
            height: 1,
            color: Colors.red,
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
    for(int i=0;i<order.productionProgresses.length;i++){
      if(order.currentPhase == order.productionProgresses[i].phase){
        _index = order.productionProgresses[i].sequence;
        break;
      }
    }
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          _buildProductionProgress(context,order.productionProgresses[_index-1],false),
          _buildProductionProgress(context,order.productionProgresses[_index],true),
          Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(50, 0, 10, 0),
              child:
              RaisedButton(
                elevation:0,
                color: Colors.white,
                child: Text(
                  '查看全部', style: TextStyle(
                    color: Colors.orange),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductionProgressesPage(order: order),
                    ),
                  );
                },
              )
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
  //TimeLineUI
  Widget _buildProductionProgress(BuildContext context,ProductionProgressModel productionProgress,bool isCurrentStatus){
    return  Stack(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child:  _buildProgressTimeLine(context,productionProgress,isCurrentStatus)
        ),
        Positioned(
          top: 30.0,
          bottom: 0.0,
          left: 17.5,
          child: Container(
            height: double.infinity,
            width: 1.3,
            color: isCurrentStatus == true ? Colors.orangeAccent : Colors.black45,
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
              decoration:
              BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrentStatus == true ? Colors.orange : Colors.black
              ),
            ),
          ),
        )
      ],
    );
  }
//TimeLineUI右边的Card部分
  Widget _buildProgressTimeLine(BuildContext context,ProductionProgressModel productionProgress,bool isCurrentStatus){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          ListTile(
            title:  Text(
                ProductionProgressPhaseLocalizedMap[productionProgress.phase],
                style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCurrentStatus==true?Colors.orange:Colors.black54,
                    fontSize: 18
                )),
            trailing:  Text(
              '已延期2天',
              style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 18
              ),
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child:Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text(
                            '预计完成时间' ,
                            style:  TextStyle(
                                fontWeight: FontWeight.w500)),
                      ),
                      GestureDetector(
                          child:Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                '${DateFormatUtil.format(
                                    productionProgress.estimatedDate)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500)),
                          ),
                          onTap: () {
                            isCurrentStatus == true ? _showDatePicker():null;
                          }),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: isCurrentStatus == true ? _showDatePicker:null,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child:  Text(
                            '实际完成时间' ,
                            style:  TextStyle(
                                fontWeight: FontWeight.w500)),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                            '${DateFormatUtil.format(
                                productionProgress.finishDate)}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500)),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 48,
                          )
                      )
                    ],
                  ),
                ],
              )
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                height: 35,
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                          child: Text(
                              '数量',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500)
                          ),
                          onTap: () {
                            isCurrentStatus == true ? _showDialog() : null;
                          }
                      ),
                    ),
                    GestureDetector(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                              productionProgress.quantity.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500)),
                        ),
                        onTap: () {
                          isCurrentStatus == true ? _showDialog() : null;
                        }
                     ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: isCurrentStatus == true ? _showDialog : null,
                      ),
                    )
                  ],
                ),)
          ),
          Align(
              alignment: Alignment.center,
              child: Container(
                height: 35,
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                          child: Text(
                              '凭证',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500
                              )
                          ),
                          onTap: () {
                            isCurrentStatus == true ? _selectPapersImages() : null;
                          }
                      ),
                      flex: 4,
                    ),
                    Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.chevron_right),
                            onPressed: isCurrentStatus == true ? _selectPapersImages : null,
                          ),
                        )
                    ),
                  ],
                ),)
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
              child: Attachments(
                list: productionProgress.medias,
              )
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("备注"),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(productionProgress.remarks)
                    )
                  ]
              )
          ),
          Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: isCurrentStatus==true && (productionProgress.phase == ProductionProgressPhase.SAMPLE_CONFIRM ||
                  productionProgress.phase == ProductionProgressPhase.INSPECTION)?
              RaisedButton(
                color: Colors.orange,
                child: Text(
                  productionProgress.phase == ProductionProgressPhase.SAMPLE_CONFIRM?
                  '样衣确认':'验货完成',
                  style: TextStyle(
                    color: Colors.white),
                ),
                onPressed: () {
                  productionProgress.phase == ProductionProgressPhase.SAMPLE_CONFIRM?
                  _showTipsDialog('样衣确认'):_showTipsDialog('验货');
                },
              ):null
          )
        ],
      ),
    );
  }

  //构建附件UI
  Widget _buildDocutment(BuildContext context){
    return PurchaseDocument(order);
  }

  void _selectPapersImages() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('相机'),
              onTap: () async {
                var image =
                await ImagePicker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
//                    widget.images.add(image);
                    Navigator.pop(context);
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('相册'),
              onTap: () async {
                var image =
                await ImagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
//                    widget.images.add(image);
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }



//生成日期选择器
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2999)
    );

    if(_picked != null){
      print(_picked);
      setState(() {
        _blDate = _picked;
      });
    }
  }

  //确认完成按钮方法
  Future<void> _neverComplete(BuildContext context,String progresses) async {
    dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('是否'+progresses+'完成？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//生成Dialog控件
  Future<void> _neverSatisfied(BuildContext context) async {
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
              child: Text('确定'),
              onPressed: () {
                if(dialogText.text != null){
                  print(dialogText.text);
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
  void _showDatePicker() {
    _selectDate(context);
  }
//打开数量输入弹框
  void _showDialog(){
    _neverSatisfied(context);
  }

  //确认是否完成动作
  void _showTipsDialog(String progresses){
    _neverComplete(context,progresses);
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
    );;
  }

//  Widget _buildPicRow(BuildContext context){
////    return Row(
////        children: _buildPicList(context)
////    );
////  }
////
//////构造凭证横向图片UI
////  List<Widget> _buildPicList(BuildContext context) {
////    List<Widget> _listPic = new List();
////    int mediasNumber = 4;
////    if(progressModel.medias.length < 4){
////      mediasNumber = progressModel.medias.length;
////    }
////    for (int i = 0; i < mediasNumber; i++) {
////      _listPic.add(
////          Expanded(
////            child: Image.network(
////              progressModel.medias[i] == null ? defaultPicUrl : progressModel.medias[i],
////              width: 50,
////              height: 50,
////              fit: BoxFit.scaleDown,
////            ),
////          )
////      );
////    }
////    if(_listPic.length < 4){
////      for (int i = 0; i <= 4 - _listPic.length; i++) {
////        _listPic.add(
////            Expanded(
////              child: Image.network(
////                defaultPicUrl,
////                width: 50,
////                height: 50,
////                fit: BoxFit.scaleDown,
////              ),
////            )
////        );
////      }
////    }
////    return _listPic;
////  }

}

//附件
class PurchaseDocument extends StatelessWidget{
  final PurchaseOrderModel order;

  PurchaseDocument(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child:  Column(
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
      padding:EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '附件',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              )
            ],
          ),
          Attachments(
            list: order.attachments,
          )
        ],
      ),
    );
  }

//  List<Widget> _buildDocumentInfo(BuildContext context){
//    List<Widget> _docList = new List();
//    int docCount = 2;
//    if (order.attachments.length < 2) {
//      docCount = order.attachments.length;
//    }
//    for (int i = 0; i < docCount; i++) {
//      _docList.add(
//          Row(
//            children: <Widget>[
//              Expanded(
//                  child: Image.network(
//                    "http://img.aso.aizhan.com/icon/f7/d0/cc/f7d0cc9b577ff84ec59b6d9932606c33.jpg",
//                    width: 50,
//                    height: 50,
//                    fit: BoxFit.scaleDown,
//                  ),
//                flex: 1,
//              ),
//              Expanded(
//                child: Text(
//                  order.attachments[i],
//                  style: TextStyle(
//                    color: Colors.black54,
//                    fontSize: 20.0,
//                  ),
//                ),
//                flex: 4,
//              ),
//              Icon(Icons.keyboard_arrow_right),
//            ],
//          )
//      );
//      _docList.add(Divider());
//    }
//    _docList.removeLast();
//    return _docList;
//  }

}
