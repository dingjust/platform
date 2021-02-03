import 'package:b2b_commerce/src/_shared/widgets/employee_select.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

///接单页(人员设置)
class OrderAcceptPage extends StatefulWidget {
  final SalesProductionOrderModel order;

  const OrderAcceptPage({Key key, this.order}) : super(key: key);

  @override
  _OrderAcceptPageState createState() => _OrderAcceptPageState();
}

class _OrderAcceptPageState extends State<OrderAcceptPage> {
  SalesProductionOrderModel order;

  @override
  void initState() {
    if (widget.order != null) {
      order = widget.order;
    } else {
      order = SalesProductionOrderModel();
    }

    //默认跟单员当前用户
    if (order.productionLeader == null) {
      UserModel currentUser = UserBLoC.instance.currentUser;
      order.productionLeader =
          B2BCustomerModel(id: currentUser.id, name: currentUser.name);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('接单人员设置'),
        elevation: 0.5,
      ),
      body: Material(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: ListView(
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Text('跟单员'),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  order?.productionLeader?.id == null
                      ? '请选择跟单员'
                      : '${order.productionLeader.name}',
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: onSelectProductionLeader,
              ),
              Divider(),
              Container(
                child: Row(
                  children: [
                    Text('审核'),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Checkbox(
                        value: order.auditNeeded,
                        onChanged: (val) {
                          setState(() {
                            order.auditNeeded = val;
                          });
                        }),
                    Text('需要审核'),
                  ],
                ),
              ),
              _buildApproversRow(),
              Divider(),
            ],
          ),
        ),
      ),
      bottomSheet: _buildBtns(),
    );
  }

  Widget _buildApproversRow() {
    String title = '请选择审核人员';

    if (order.approvers != null && order.approvers.isNotEmpty) {
      title = order.approvers.map((e) => e.name).toString();
    }

    return order.auditNeeded
        ? ListTile(
            title: Text(
              '$title',
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: onSelectApprovers,
          )
        : Container();
  }

  Widget _buildBtns() {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                height: 55,
                child: FlatButton(
                    shape: RoundedRectangleBorder(),
                    disabledColor: Colors.grey,
                    onPressed: _onAccept,
                    color: Constants.THEME_COLOR_MAIN,
                    child: Text('接单',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ))),
              ))
        ],
      ),
    );
  }

  void _onAccept() async {
    //校验
    if (order?.productionLeader?.id == null) {
      BotToast.showText(text: '请选择跟单员');
      throw Exception('请选择跟单员');
    }
    if (order.auditNeeded &&
        (order.approvers == null || order.approvers.isEmpty)) {
      BotToast.showText(text: '请选择审批人');
      throw Exception('请选择审批人');
    }
    Function cancelFunc =
        BotToast.showLoading(crossPage: false, clickClose: true);
    BaseResponse response = await ExternalSaleOrderRespository().accept(order);
    cancelFunc.call();
    if (response != null && response.code == 1) {
      BotToast.showText(text: '接单成功');
      Navigator.of(context).pop(true);
    } else if (response != null && response.code == 0) {
      BotToast.showText(text: '${response.msg}');
    } else {
      BotToast.showText(text: '操作失败');
    }
  }

  ///选择跟单员
  void onSelectProductionLeader() async {
    List<B2BCustomerModel> b2bCusomers =
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EmployeeSelectPage(
                  selected: order.productionLeader != null
                      ? [order.productionLeader]
                      : [],
                )));
    if (b2bCusomers[0] != null) {
      setState(() {
        order.productionLeader = b2bCusomers[0];
      });
    }
  }

  ///选择审核人员
  void onSelectApprovers() async {
    // List<>

    List<B2BCustomerModel> b2bCusomers =
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EmployeeSelectPage(
                  multi: true,
                  max: 5,
                  selected: order.approvers != null
                      ? (order.approvers as List<B2BCustomerModel>)
                      : [],
                )));
    setState(() {
      order.approvers = b2bCusomers;
    });
  }
}
