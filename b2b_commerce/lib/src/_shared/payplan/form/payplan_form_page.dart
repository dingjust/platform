import 'package:b2b_commerce/src/business/orders/sales_production/out_order/form/form_components.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../payplan_helper.dart';

///账务方案表单页
class PayPlanFormPage extends StatefulWidget {
  @override
  _PayPlanFormPageState createState() => _PayPlanFormPageState();
}

class _PayPlanFormPageState extends State<PayPlanFormPage> {
  CompanyPayPlanModel form;

  TextEditingController nameTextController;
  FocusNode nameFocusNode;
  TextEditingController remarksTextController;
  FocusNode remarksFocusNode;

  final Color highlightColor = Colors.orangeAccent;

  @override
  void initState() {
    super.initState();
    form = CompanyPayPlanModel(
        isHaveDeposit: true,
        payPlanType: PayPlanType.PHASEONE,
        payPlanItems: [
          getInitModel(),
          getInitModel(moneyType: PayMoneyType.PHASEONE)
        ]);
    nameTextController = TextEditingController();
    nameFocusNode = FocusNode();
    remarksTextController = TextEditingController();
    remarksFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建账务方案'),
        elevation: 0.5,
        brightness: Brightness.light,
        centerTitle: true,
        actions: <Widget>[
          FlatButton(child: Text('确定'), onPressed: _onSubmit),
        ],
      ),
      body: Container(
        child: ListView(
          children: [_buildBlock1(), _buildBlock2(), _Preview(form)],
        ),
      ),
    );
  }

  Widget _buildBlock1() {
    return FormBlock(
      children: [
        FormTitle(
          '方案名称：',
          require: true,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldBorderComponent(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '请输入方案名称',
            controller: nameTextController,
            focusNode: nameFocusNode,
            onChanged: (value) {
              form.name = value;
            },
          ),
        ),
        Divider(),
        FormTitle('备注：'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldBorderComponent(
            padding: EdgeInsets.all(0),
            hideDivider: true,
            isRequired: true,
            textAlign: TextAlign.left,
            hintText: '请输入备注留言...',
            controller: remarksTextController,
            maxLength: 120,
            focusNode: remarksFocusNode,
            onChanged: (value) {
              form.remarks = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBlock2() {
    return FormBlock(children: [
      FormLabel('账务设置'),
      FormTitle(
        '有无定金：',
        require: true,
      ),
      Row(children: [
        _depositRadios(true),
        _depositRadios(false),
      ]),
      Divider(),
      FormTitle(
        '尾款期数',
        require: true,
      ),
      Wrap(children: [
        for (PayPlanType val in _formPayPlanType) _payTypeRadios(val)
      ]),
      Divider(),
      for (PayMoneyType type in [
        PayMoneyType.DEPOSIT,
        PayMoneyType.PHASEONE,
        PayMoneyType.PHASETWO,
        PayMoneyType.PHASETHREE
      ])
        for (Widget widget in _itemsWidgets(type)) widget,
      for (Widget widget in _monthlyOneRow()) widget,
      for (Widget widget in _monthlyTwoRow()) widget,
    ]);
  }

  ///定金单选项
  Widget _depositRadios(bool val) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            value: val,
            groupValue: form.isHaveDeposit,
            onChanged: (bool value) {
              setState(() {
                form.isHaveDeposit = value;
                if (value) {
                  if (!form.payPlanItems.any(
                      (element) => element.moneyType == PayMoneyType.DEPOSIT)) {
                    form.payPlanItems.add(getInitModel());
                  }
                } else {
                  form.payPlanItems.removeWhere(
                      (element) => element.moneyType == PayMoneyType.DEPOSIT);
                }
              });
            },
          ),
          Text('${val ? '有' : '无'}定金'),
        ],
      ),
    );
  }

  ///尾款期数选项
  Widget _payTypeRadios(PayPlanType val) {
    return Container(
      width: 120,
      child: Row(
        children: [
          Radio(
              value: val,
              groupValue: form.payPlanType,
              onChanged: onPayPlanTypeChange),
          Text('${PayPlanTypeLocalizedMap[val]}'),
        ],
      ),
    );
  }

  ///期款行
  List<Widget> _itemsWidgets(PayMoneyType payMoneyType) {
    var item = form.payPlanItems.firstWhere(
        (element) => element.moneyType == payMoneyType,
        orElse: () => null);

    if (item == null) {
      return [Container()];
    }

    return [
      Row(
        children: [
          Container(
            width: 80,
            child: FormTitle('${PayMoneyTypeLocalizedMap[payMoneyType]}:'),
          ),
          Text('事件'),
          Container(
            width: 110,
            child: PopupMenuButton(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        '${TriggerEventLocalizedMap[item.triggerEvent]}',
                        style: TextStyle(color: highlightColor),
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  )),
              onSelected: (e) {
                setState(() {
                  item.triggerEvent = e;
                });
              },
              itemBuilder: (BuildContext context) {
                return TriggerEvent.values
                    .map(
                      (e) => PopupMenuItem(
                        child: Text(
                          '${TriggerEventLocalizedMap[e]}',
                          style: TextStyle(
                              color: e == item.triggerEvent
                                  ? Constants.THEME_COLOR_MAIN
                                  : Colors.black87),
                        ),
                        value: e,
                      ),
                    )
                    .toList();
              },
            ),
          ),
          Text('后时长'),
          Container(
            width: 60,
            child: NumberStepper(
              initVal: item.triggerDays.toDouble(),
              min: 1.0,
              iconSize: 16,
              onChange: (val) {
                setState(() {
                  item.triggerDays = val.toInt();
                });
              },
            ),
          ),
          Text('天'),
        ],
      ),
      Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 80),
            child: Text('付款'),
          ),
          isLastItem(payMoneyType)
              ? Text('剩余全部款项')
              : Container(
                  width: 90,
                  child: PopupMenuButton(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Text(
                              '${(item.payPercent * 100).toStringAsFixed(0)}%',
                              style: TextStyle(color: highlightColor),
                            ),
                            Icon(Icons.arrow_drop_down)
                          ],
                        )),
                    onSelected: (e) {
                      setState(() {
                        item.payPercent = e * 0.01;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      List<PopupMenuItem> items = [];
                      for (int i = 1; i < 100; i++) {
                        items.add(PopupMenuItem(
                          child: Text(
                            '$i%',
                            style: TextStyle(
                                color: i == item.payPercent * 100
                                    ? Constants.THEME_COLOR_MAIN
                                    : Colors.black87),
                          ),
                          value: i,
                        ));
                      }
                      return items;
                    },
                  ),
                )
        ],
      ),
      Divider()
    ];
  }

  ///一月一结行/一月两结第一行
  List<Widget> _monthlyOneRow() {
    var item = form.payPlanItems.firstWhere(
        (element) =>
            (element.moneyType == PayMoneyType.MONTHLY_SETTLEMENT_ONE ||
                element.moneyType == PayMoneyType.MONTHLY_SETTLEMENT_TWO),
        orElse: () => null);

    var nextItem = form.payPlanItems.firstWhere(
        (element) =>
            (element.moneyType == PayMoneyType.MONTHLY_SETTLEMENT_TWO &&
                element.isLast),
        orElse: () => null);

    if (item == null) {
      return [Container()];
    }

    return [
      FormTitle('${PayPlanTypeLocalizedMap[form.payPlanType]}:'),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('每月'),
            _DaySelect(
              value: item.monthlyEndDayNum,
              onChanged: (val) {
                setState(() {
                  item.monthlyEndDayNum = val;
                  if (nextItem != null) {
                    nextItem.monthlyStartDayNum = val;
                  }
                });
              },
            ),
            Text('前完成事件'),
            Container(
              width: 110,
              child: PopupMenuButton(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          '${TriggerEventLocalizedMap[item.triggerEvent]}',
                          style: TextStyle(color: highlightColor),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    )),
                onSelected: (e) {
                  setState(() {
                    item.triggerEvent = e;
                    if (nextItem != null) {
                      nextItem.triggerEvent = e;
                    }
                  });
                },
                itemBuilder: (BuildContext context) {
                  return [
                    TriggerEvent.DELIVERY_CONFIRMED,
                    TriggerEvent.RECONCILIATION_CONFIRMED,
                    TriggerEvent.INVOICE_RECEIVED
                  ]
                      .map(
                        (e) => PopupMenuItem(
                          child: Text(
                            '${TriggerEventLocalizedMap[e]}',
                            style: TextStyle(
                                color: e == item.triggerEvent
                                    ? Constants.THEME_COLOR_MAIN
                                    : Colors.black87),
                          ),
                          value: e,
                        ),
                      )
                      .toList();
                },
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text('后于'),
            Container(
              width: 90,
              child: PopupMenuButton(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          '${MonthTypeLocalizedMap[item.monthType]}',
                          style: TextStyle(color: highlightColor),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    )),
                onSelected: (e) {
                  setState(() {
                    item.monthType = e;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return MonthType.values
                      .map((e) => PopupMenuItem(
                            child: Text(
                              '${MonthTypeLocalizedMap[e]}',
                              style: TextStyle(
                                  color: e == item.monthType
                                      ? Constants.THEME_COLOR_MAIN
                                      : Colors.black87),
                            ),
                            value: e,
                          ))
                      .toList();
                },
              ),
            ),
            _DaySelect(
              value: item.payDayNum,
              onChanged: (val) {
                setState(() {
                  item.payDayNum = val;
                });
              },
            ),
            Text('支付相应款项'),
          ],
        ),
      ),
      Divider()
    ];
  }

  ///一月两结行第二行
  List<Widget> _monthlyTwoRow() {
    var item = form.payPlanItems.firstWhere(
        (element) =>
            (element.moneyType == PayMoneyType.MONTHLY_SETTLEMENT_TWO &&
                element.isLast),
        orElse: () => null);

    if (item == null) {
      return [Container()];
    }

    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('当月'),
            Text(
                item.monthlyStartDayNum == -1
                    ? '月底'
                    : '${item.monthlyStartDayNum}号',
                style: TextStyle(color: highlightColor)),
            Text('至'),
            _DaySelect(
              value: item.payDayNum,
              onChanged: (val) {
                setState(() {
                  item.payDayNum = val;
                });
              },
            ),
            Text('前完成事件'),
            Text('${TriggerEventLocalizedMap[item.triggerEvent]}',
                style: TextStyle(color: highlightColor)),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text('后于'),
            Container(
              width: 90,
              child: PopupMenuButton(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Text(
                          '${MonthTypeLocalizedMap[item.monthType]}',
                          style: TextStyle(color: highlightColor),
                        ),
                        Icon(Icons.arrow_drop_down)
                      ],
                    )),
                onSelected: (e) {
                  setState(() {
                    item.monthType = e;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return MonthType.values
                      .map((e) => PopupMenuItem(
                            child: Text(
                              '${MonthTypeLocalizedMap[e]}',
                              style: TextStyle(
                                  color: e == item.monthType
                                      ? Constants.THEME_COLOR_MAIN
                                      : Colors.black87),
                            ),
                            value: e,
                          ))
                      .toList();
                },
              ),
            ),
            _DaySelect(
              value: item.monthlyEndDayNum,
              onChanged: (val) {
                setState(() {
                  item.monthlyEndDayNum = val;
                });
              },
            ),
            Text('支付相应款项'),
          ],
        ),
      ),
      Divider()
    ];
  }

  ///款项类型改变
  void onPayPlanTypeChange(PayPlanType type) {
    List<AbstractPayPlanItemModel> result;

    switch (type) {
      case PayPlanType.PHASEONE:
        result = [
          getInitModel(
            moneyType: PayMoneyType.PHASEONE,
          ),
        ];
        break;
      case PayPlanType.PHASETWO:
        result = [
          getInitModel(moneyType: PayMoneyType.PHASEONE),
          getInitModel(
            moneyType: PayMoneyType.PHASETWO,
          )
        ];
        break;
      case PayPlanType.PHASETHREE:
        result = [
          getInitModel(moneyType: PayMoneyType.PHASEONE),
          getInitModel(
            moneyType: PayMoneyType.PHASETWO,
          ),
          getInitModel(
            moneyType: PayMoneyType.PHASETHREE,
          )
        ];
        break;
      case PayPlanType.MONTHLY_SETTLEMENT_ONE:
        result = [
          CompanyPayPlanItemModel(
              monthlyEndDayNum: 1,
              payDayNum: 10,
              moneyType: PayMoneyType.MONTHLY_SETTLEMENT_ONE,
              triggerEvent: TriggerEvent.DELIVERY_CONFIRMED,
              monthType: MonthType.CURRENT_MONTH)
        ];
        break;
      case PayPlanType.MONTHLY_SETTLEMENT_TWO:
        result = [
          CompanyPayPlanItemModel(
              monthlyEndDayNum: 1,
              payDayNum: 10,
              isRange: false,
              isLast: false,
              moneyType: PayMoneyType.MONTHLY_SETTLEMENT_TWO,
              triggerEvent: TriggerEvent.DELIVERY_CONFIRMED,
              monthType: MonthType.CURRENT_MONTH),
          CompanyPayPlanItemModel(
              monthlyStartDayNum: 1,
              monthlyEndDayNum: 11,
              isRange: true,
              isLast: true,
              payDayNum: 10,
              moneyType: PayMoneyType.MONTHLY_SETTLEMENT_TWO,
              triggerEvent: TriggerEvent.DELIVERY_CONFIRMED,
              monthType: MonthType.NEXT_MONTH)
        ];
        break;
      default:
        result = [];
    }

    //定金项
    if (form.isHaveDeposit) {
      AbstractPayPlanItemModel depostItem = form.payPlanItems.firstWhere(
          (element) => element.moneyType == PayMoneyType.DEPOSIT,
          orElse: () => null);
      if (depostItem != null) {
        result.add(depostItem);
      }
    }

    setState(() {
      form.payPlanItems = result;
      form.payPlanType = type;
    });
  }

  ///是否为最后一行款项
  bool isLastItem(PayMoneyType payMoneyType) {
    if (payMoneyType == PayMoneyType.DEPOSIT) {
      return false;
    }

    switch (form.payPlanType) {
      case PayPlanType.PHASEONE:
        return true;
        break;
      case PayPlanType.PHASETWO:
        return payMoneyType == PayMoneyType.PHASETWO;
        break;
      case PayPlanType.PHASETHREE:
        return payMoneyType == PayMoneyType.PHASETHREE;
        break;
      default:
        return false;
    }
  }

  static CompanyPayPlanItemModel getInitModel(
      {PayMoneyType moneyType = PayMoneyType.DEPOSIT,
      TriggerEvent triggerEvent = TriggerEvent.ORDER_CONFIRMED,
      int triggerDays = 5,
      double payPercent = 0.3}) {
    return CompanyPayPlanItemModel(
        moneyType: moneyType,
        triggerEvent: triggerEvent,
        triggerDays: triggerDays,
        payPercent: payPercent);
  }

  ///表单校验
  bool validateForm() {
    List<FormValidateItem> validateItems = [
      FormValidateItem(
          (form.name == null || form.name.trim() == ''), '请填写方案名称！'),
    ];

    FormValidateItem item = validateItems
        .firstWhere((element) => element.result, orElse: () => null);

    if (item == null) {
      return true;
    } else {
      BotToast.showText(
          text: '${item.message}',
          onlyOne: true,
          crossPage: false,
          clickClose: true);
      return false;
    }
  }

  void _onSubmit() async {
    if (validateForm()) {
      Function cancelFunc =
          BotToast.showLoading(crossPage: false, clickClose: false);
      form.previewText = PayPlanHelper.getPreviewText(form);
      String response = await PayPlanRepositoryImpl.create(form);
      cancelFunc.call();
      if (response != null) {
        BotToast.showText(text: '创建成功！');
        Navigator.of(context).pop(true);
      } else {
        BotToast.showText(text: '操作失败！');
      }
    }
  }
}

class _DaySelect extends StatelessWidget {
  final double width;

  final int value;

  final ValueChanged<int> onChanged;

  final Color highlightColor;

  const _DaySelect(
      {Key key,
      this.width = 76,
      this.onChanged,
      this.value,
      this.highlightColor = Colors.orangeAccent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: PopupMenuButton(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value == -1 ? '月底' : '$value号',
                  style: TextStyle(color: highlightColor),
                ),
                Icon(Icons.arrow_drop_down)
              ],
            )),
        onSelected: (e) {
          onChanged.call(e);
        },
        itemBuilder: (BuildContext context) {
          List<PopupMenuItem> items = [];
          for (int i = 1; i < 28; i++) {
            items.add(PopupMenuItem(
              child: Text(
                '$i号',
                style: TextStyle(
                    color: i == value
                        ? Constants.THEME_COLOR_MAIN
                        : Colors.black87),
              ),
              value: i,
            ));
          }
          items.add(PopupMenuItem(
            child: Text(
              '月底',
              style: TextStyle(
                  color: -1 == value
                      ? Constants.THEME_COLOR_MAIN
                      : Colors.black87),
            ),
            value: -1,
          ));
          return items;
        },
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  final CompanyPayPlanModel form;

  const _Preview(
    this.form, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBlock(
      children: [
        FormLabel('预览'),
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300], width: 1),
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: Text('${PayPlanHelper.getPreviewText(form)}'))
              ],
            ))
      ],
    );
  }
}

///表单付款类型
var _formPayPlanType = [
  PayPlanType.PHASEONE,
  PayPlanType.PHASETWO,
  PayPlanType.PHASETHREE,
  PayPlanType.MONTHLY_SETTLEMENT_ONE,
  PayPlanType.MONTHLY_SETTLEMENT_TWO,
];
