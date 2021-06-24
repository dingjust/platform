import 'package:b2b_commerce/src/_shared/widgets/employee_select.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/out_order/form/form_components.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///接单页(人员设置)
class OrderAcceptPage extends StatefulWidget {
  final SalesProductionOrderModel order;

  const OrderAcceptPage({Key key, this.order}) : super(key: key);

  @override
  _OrderAcceptPageState createState() => _OrderAcceptPageState();
}

class _OrderAcceptPageState extends State<OrderAcceptPage> {
  SalesProductionOrderModel order;

  TextEditingController payNameController;
  TextEditingController payNoController;
  TextEditingController payProvController;

  FocusNode payNameNode;
  FocusNode payNoNode;
  FocusNode payProvNode;

  @override
  void initState() {
    payNameController = TextEditingController();
    payNoController = TextEditingController();
    payProvController = TextEditingController();
    payNameNode = FocusNode();
    payNoNode = FocusNode();
    payProvNode = FocusNode();

    if (widget.order != null) {
      order = widget.order;
    } else {
      order = SalesProductionOrderModel();
    }

    if (order.paymentAccount == null &&
        order.payOnline != null &&
        order.payOnline) {
      //默认为银行卡方式TODO:增加收款方式
      order.paymentAccount =
          OrderPaymentAccountData(type: OrderPaymentAccountType.BANK);
      //代运营需要设置服务费用比例
      if (UserBLoC.instance.currentUser.agent != null &&
          UserBLoC.instance.currentUser.agent) {
        order.serviceFeePercent = 0.05;
      }
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
              _buildPaymentAccount(),
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
              _buildBtns()
            ],
          ),
        ),
      ),
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

  ///收款信息
  Widget _buildPaymentAccount() {
    if (order.payOnline != null && order.payOnline) {
      return FormBlock(
        children: [
          FormLabel('收款信息（银行卡）'),
          FormTitle('收款人姓名：'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '收款人姓名',
              controller: payNameController,
              focusNode: payNameNode,
              onChanged: (value) {
                order.paymentAccount.name = value;
              },
            ),
          ),
          Divider(),
          FormTitle('开户行：'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '请输入开户行',
              controller: payProvController,
              focusNode: payProvNode,
              onChanged: (value) {
                order.paymentAccount.serviceProvider = value;
              },
            ),
          ),
          Divider(),
          FormTitle('卡号：'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextFieldBorderComponent(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '请输入卡号',
              controller: payNoController,
              focusNode: payNoNode,
              onChanged: (value) {
                order.paymentAccount.no = value;
              },
            ),
          ),
          Divider(),
          ...UserBLoC.instance.currentUser.agent
              ? [
                  FormTitle('服务费用扣除比例（代运营方）：'),
                  Slider(
                    value: order.serviceFeePercent ?? 0.05,
                    min: 0.05,
                    max: 0.3,
                    divisions: 25,
                    label:
                        '${(order.serviceFeePercent * 100).toStringAsFixed(0)}%',
                    onChanged: (value) {
                      setState(() {
                        order.serviceFeePercent = value;
                      });
                    },
                    onChangeStart: (value) {},
                    onChangeEnd: (value) {},
                  ),
                  Text(
                    '${(order.serviceFeePercent * 100).toStringAsFixed(0)}%',
                    style: TextStyle(color: Colors.red),
                  )
                ]
              : [],
        ],
      );
    }
    return Container();
  }

  Widget _buildBtns() {
    return Container(
      height: 55,
      margin: EdgeInsets.only(top: 50),
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
    if (order.payOnline != null && order.payOnline) {
      //线上支付类型校验
      if (order?.paymentAccount?.name == null ||
          order?.paymentAccount?.no == null ||
          order?.paymentAccount?.serviceProvider == null) {
        BotToast.showText(text: '请填写收款信息');
        throw Exception('请填写收款信息');
      }
    }

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
