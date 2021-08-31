import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/dialog_helper.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'sales_production/external_sale_order/external_sale_order_detail.dart';

///订单导入页面
class OrderImportPage extends StatefulWidget {
  final String code;

  const OrderImportPage({Key key, this.code}) : super(key: key);

  @override
  _OrderImportPageState createState() => _OrderImportPageState();
}

class _OrderImportPageState extends State<OrderImportPage> {
  int checkCode = 0;
  String checkResult = '';

  SalesProductionOrderModel order;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: (BuildContext context,
          AsyncSnapshot<SalesProductionOrderModel> snapshot) {
        if (snapshot.hasData && order != null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('订单导入'),
              elevation: 0.5,
              brightness: Brightness.light,
              centerTitle: true,
            ),
            body: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [_buildBody()],
                )),
            bottomNavigationBar: _buildBottomBtn(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('订单导入'),
              elevation: 0.5,
              brightness: Brightness.light,
              centerTitle: true,
            ),
            body: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }

  ///主体
  Widget _buildBody() {
    if (order.code != null) {
      return _OrderInfo(order);
    } else {
      // 没有内容显示
      return Container(
        height: 100,
        child: Center(
          child: Text('$checkResult'),
        ),
      );
    }
  }

  Widget _buildBottomBtn() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 50,
      child: RaisedButton(
          color: Color.fromRGBO(255, 214, 12, 1),
          child: Text(
            '确认导入',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50))),
          onPressed: order != null ? onSubmit : null),
    );
  }

  ///检索
  Future<SalesProductionOrderModel> _getData() async {
    if (order == null) {
      BaseResponse response =
          await ExternalSaleOrderRespository().qrCodePreview(widget.code);
      if (response != null) {
        if (response.code == 1) {
          order = SalesProductionOrderModel.fromJson(response.data);
        } else if (response.code == 0 && response.msg != null) {
          String orderId = response.msg;
          //列表筛出来ID
          // int id = await queryIdFromList(orderCode);
          // if (id != null) {
          //   order = await ExternalSaleOrderRespository().getOrderDetail(id);
          // }
          Navigator.of(context).pushReplacementNamed(
              AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS_DETAIL,
              arguments: {'id': orderId, 'title': '外发订单明细'});
        }

        //判断是否已接单
        if (order.originCooperator != null && order.targetCooperator != null) {
          //甲乙双方确定则跳转到订单详情
          Navigator.of(context).pushReplacementNamed(
              AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS_DETAIL,
              arguments: {'id': order.id, 'title': '外发订单明细'});
        }
      }
    }
    return order;
  }

  void onSubmit() {
    DialogHelper.showConfirm(title: '确定导入订单?', content: '', confirm: submit);
  }

  ///确定
  void submit() async {
    Function cancelFunc =
        BotToast.showLoading(clickClose: true, crossPage: false);

    BaseResponse response = await ExternalSaleOrderRespository().qrCodeImport(
        code: widget.code, merchandiser: UserBLoC.instance.currentUser.id);
    cancelFunc.call();
    //导入成功
    if (response != null && response.code == 1) {
      BotToast.showText(text: '导入成功');
      Navigator.of(context).pushReplacementNamed(
          AppRoutes.ROUTE_EXTERNAL_SALE_ORDERS_DETAIL,
          arguments: {'id': order.id, 'title': '外发订单明细'});
    } else if (response != null && response.code == 0) {
      BotToast.showText(text: '${response.msg}');
    } else {
      BotToast.showText(text: '操作失败');
    }
  }

  Future<int> queryIdFromList(String code) async {
    Response<Map<String, dynamic>> response;

    try {
      response = await http$.post('/{baseSiteId}/out/order/search', data: {
        'name': code
      }, queryParameters: {
        'size': 10,
      });
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      try {
        List<dynamic> content = response.data['content'];
        var result = content.firstWhere((element) => element['code'] == code,
            orElse: () => null);
        if (result != null) {
          print('=====================${result['id']}');
          return result['id'];
        }
      } catch (e) {
        print(e);
      }
    }
    return null;
  }
}

class _OrderInfo extends StatelessWidget {
  final SalesProductionOrderModel order;

  const _OrderInfo(this.order, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text('订单号：${order.code}')),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      '合作商：${order?.originCooperator?.name ?? ''}',
                    )),
              ],
            ),
          ),
          Divider(),
          for (final t in order.taskOrderEntries ?? []) _buildProductRow(t),
          MainInfo(
            order: order,
          ),
        ],
      ),
    ));
  }

  Widget _buildProductRow(ProductionTaskOrderModel entry) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      color: Colors.grey[100],
      child: Row(
        children: [
          ImageFactory.buildThumbnailImage(entry.product.thumbnail),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${entry.product.name}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '货号：${entry.product.skuID}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ))),
          Text('交期：${DateFormatUtil.formatYMD(entry.deliveryDate)}')
        ],
      ),
    );
  }
}
