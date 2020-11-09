import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class ExternalSaleOrderImportPage extends StatefulWidget {
  @override
  _ExternalSaleOrderImportPageState createState() =>
      _ExternalSaleOrderImportPageState();
}

class _ExternalSaleOrderImportPageState
    extends State<ExternalSaleOrderImportPage> {
  TextEditingController _textEditingController;

  int checkCode = 0;
  String checkResult = '';

  //外接订单数据TODO: model构建
  SalesProductionOrderModel order;

  @override
  void initState() {
    _textEditingController = TextEditingController(text: 'TJTspqC');
    super.initState();
  }

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
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [_buildInputRow(), Divider(), _buildBody()],
        ),
      ),
      bottomNavigationBar: _buildBottomBtn(),
    );
  }

  ///输入行
  Widget _buildInputRow() {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: '请输入7位唯一码'),
                ),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(245, 245, 245, 1),
                    borderRadius: BorderRadius.circular(5)),
              )),
              Container(
                child: FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Text(
                      '检索',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    onPressed: _onCheck),
              ),
            ],
          ),
        ));
  }

  ///主体
  Widget _buildBody() {
    if (checkCode == 1 && order != null) {
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
          onPressed: order != null ? _onSubmit : null),
    );
  }

  ///检索
  void _onCheck() async {
    Function cancelFunc =
    BotToast.showLoading(clickClose: true, crossPage: false);
    SalesProductionOrderModel model = await ExternalSaleOrderRespository()
        .uniqueCodePreview(_textEditingController.text);

    setState(() {
      if (model != null) {
        checkCode = 1;
        order = model;
      } else {
        checkCode = 0;
        checkResult = '检索无数据';
      }
    });
    cancelFunc();
  }

  ///确定
  void _onSubmit() async {
    Function cancelFunc =
    BotToast.showLoading(clickClose: true, crossPage: false);

    BaseResponse response = await ExternalSaleOrderRespository()
        .uniqueCodeImport(_textEditingController.text);
    cancelFunc.call();
    //导入成功
    if (response != null && response.code == 1) {
      BotToast.showText(text: '导入成功');
      Navigator.of(context).pop(true);
    } else if (response != null && response.code == 0) {
      BotToast.showText(text: '${response.msg}');
    } else {
      BotToast.showText(text: '操作失败');
    }
  }
}

class _OrderInfo extends StatelessWidget {
  final SalesProductionOrderModel order;

  const _OrderInfo(this.order, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(flex: 1, child: Text('订单号：${order.code}')),
            ],
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Text(
                    '合作商：${order.originCooperator.name}',
                  )),
            ],
          ),
          Divider(),
          for (final t in order.taskOrderEntries ?? []) _buildProductRow(t)
        ],
      ),
    ));
  }

  Widget _buildProductRow(ProductionTaskOrderModel entry) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 5),
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
