import 'package:b2b_commerce/src/business/cooperator/cooperators_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'form_components.dart';

class OutOrderForm extends StatefulWidget {
  @override
  _OutOrderFormState createState() => _OutOrderFormState();
}

class _OutOrderFormState extends State<OutOrderForm> {
  SalesProductionOrderModel form;

  @override
  void initState() {
    form = SalesProductionOrderModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              '创建外发订单',
              style: TextStyle(
                  color: Color(0xff455a64), fontWeight: FontWeight.bold),
            ),
            elevation: 0.5,
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                _buildOutTypeRadio(),
                FormCooperatorsSelect(
                  onCooperatorSelect: onCooperatorSelect,
                  value: form.cooperator,
                ),
                FormProduction(
                  onEntriesChange: (entries) {
                    setState(() {
                      form.taskOrderEntries = entries;
                    });
                  },
                  entries: form.taskOrderEntries,
                ),
                // _EntriesInfo(
                //   order: order,
                // ),
                // _MainInfo(
                //   order: order,
                // ),
                // OrderContractsBlock(
                //   agreements: order.agreements,
                // ),
                // _OrderInfo(
                //   order: order,
                // ),
                // //底部占位
                // Container(
                //   height: 80,
                // )
              ],
            ),
          ),
          // bottomSheet: OrderDetailBtnGroup(
          //   order: order,
          //   listCallback: listPageCallback,
          //   detailCallback: _getData,
          //   needCallbackPop: needCallbackPop,
          // ),
          resizeToAvoidBottomPadding: true,
        ),
        onWillPop: onPop);
  }

  ///管理方式选择行
  Widget _buildOutTypeRadio() {
    return FormBlock(
      children: [
        FormLabel('订单管理方式'),
        Row(children: [
          for (ManagementMode val in ManagementMode.values) _typeRadio(val)
        ])
      ],
    );
  }

  ///单选项
  Widget _typeRadio(ManagementMode val) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            value: val,
            groupValue: form.managementMode,
            onChanged: (ManagementMode value) {
              setState(() {
                form.managementMode = value;
              });
            },
          ),
          Text('${ManagementModeLocalizedMap[val]}'),
        ],
      ),
    );
  }

  void onCooperatorSelect() async {
    List<CooperatorModel> cooperators = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CooperatorsPage(
                  selectedData:
                      form.cooperator != null ? [form.cooperator] : [],
                  selectingMode: true,
                  categories: [CooperatorCategory.SUPPLIER],
                  max: 1,
                )));
    if (cooperators != null) {
      setState(() {
        if (cooperators.isNotEmpty) {
          form.cooperator = cooperators.first;
        } else {
          form.cooperator = null;
        }
      });
    }
  }

  ///页面回退回调
  Future<bool> onPop() async {
    return true;
    // if (callBackPop) {
    //   Navigator.of(context).pop(true);
    //   return false;
    // } else {
    //   return true;
    // }
  }
}
