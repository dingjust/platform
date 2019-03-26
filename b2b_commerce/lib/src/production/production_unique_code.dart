import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductionUniqueCodePage extends StatefulWidget {
  final ApparelProductModel product;

  ProductionUniqueCodePage({this.product});

  _ProductionUniqueCodePageState createState() =>
      _ProductionUniqueCodePageState();
}

class _ProductionUniqueCodePageState extends State<ProductionUniqueCodePage> {
  TextEditingController _textEditingController = TextEditingController();

  PurchaseOrderModel uniqueCodeEntry;
  String userType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('导入唯一码'),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,
        ),
        body: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '请输入唯一码',
                          style: TextStyle(
                              color: Color.fromRGBO(100, 100, 100, 1),
                              fontSize: 18),
                        ),
                        TextField(
                          autofocus: true,
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              suffix: GestureDetector(
                            onTap: () async{
                              String unique = _textEditingController.text;
                              //请求参数
                              Map data = {
                                'salesApplications': unique,
                              };
                              Response<Map<String, dynamic>> response;

                              PurchaseOrderModel _purchaseOrder = await PurchaseOrderRepository().getDetailsForUniqueCode(unique);

                              setState(() {
                                uniqueCodeEntry = _purchaseOrder;
                              });
                            },
                            child: Text(
                              '检索',
                              style: TextStyle(color: Color.fromRGBO(255,214,12, 1)),
                            ),
                          )),
                        )
                      ],
                    ),
                  ),
                  uniqueCodeEntry == null
                      ? Container(
                    child: Center(
                      child: Text(
                        '请输入正确且有效的唯一码匹配！',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )
                      : Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '唯一码对应订单信息',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              uniqueCodeEntry != null ?
                              UniqueCodeItem(
                                order: uniqueCodeEntry,
                              ) : Container()
                            ],
                          ),
                        ),
                ],
              ),
                  Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 40),
                      child: FlatButton(
                        color: Color(0xFFFF9516),
                        child: Text(
                          '确定导入',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        disabledColor : Color(0xffBC8F8F),
                        disabledTextColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        onPressed: uniqueCodeEntry == null ? null : () async {
                          bool result = false;
                          try{
                            result = await PurchaseOrderRepository().linkUniqueCode(uniqueCodeEntry.uniqueCode);
                          }catch(e){
                            print(e);
                          }
                          _showMessage(context,result,'绑定唯一码',uniqueCodeEntry.code);
                        },
                      ),
                    ),
            ],
          ),
        ));
  }


  void _showMessage(BuildContext context,bool result,String message,String code){
    _requestMessage(context,result == true? '${message}成功' : '${message}失败',result,code);
  }

  Future<void> _requestMessage(BuildContext context,String message,bool result,String code) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: SingleChildScrollView(
              child: Text(
                '${message}',
                style: TextStyle(
                  fontSize: 22,
                ),
              )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                PurchaseOrderModel model = await PurchaseOrderRepository().getPurchaseOrderDetail(code);
                ProductionBLoC.instance.refreshData();

                Navigator.of(context).pop();
                result == true ?
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>
                        PurchaseOrderDetailPage(order: model)
                    ), ModalRoute.withName('/')) : null;
              },
            ),
          ],
        );
      },
    );
  }


}

class UniqueCodeItem extends StatelessWidget {
  const UniqueCodeItem({Key key, this.order}) : super(key: key);

  final PurchaseOrderModel order;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => PurchaseOrderDetailPage(order: order),
        //   ),
        // );
      },
      child: Container(
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            Column(
              children: _buildEntries(),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    String userType;
      final bloc = BLoCProvider.of<UserBLoC>(context);
      if(bloc.isBrandUser){
        userType = 'brand';
      }else{
        userType = 'factory';
      }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  userType != null && userType == 'brand'?
                  '工厂：${order.belongTo.name}':'品牌：${order.purchaser.name}',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Text(
                '${PurchaseOrderStatusLocalizedMap[order.status]}',
                style: TextStyle(
                    color: Color.fromRGBO(86, 194, 117, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEntries() {
    return order.entries
        .map((entry) => Container(
              color: Color.fromRGBO(250, 250, 250, 1),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: order.product.thumbnail != null
                              ? NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${order.product.thumbnail.url}')
                              : AssetImage(
                                  'temp/picture.png',
                                  package: "assets",
                                ),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                entry.product.name,
                                style: TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  '货号：' + entry.product.skuID,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(150, 150, 150, 1)),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '生产订单号：${order.code}',
                                style: TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '报价时间：${DateFormatUtil.format(order.creationTime)}',
                                style: TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

}
