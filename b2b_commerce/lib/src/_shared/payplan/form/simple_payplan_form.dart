import 'package:b2b_commerce/src/business/orders/sales_production/external_sale_order/form/form_components.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class SimplePayPlanForm extends StatelessWidget {
  final ValueChanged<CompanyPayPlanModel> onChange;

  CompanyPayPlanModel form;

  SimplePayPlanForm({Key key, this.form, this.onChange}) : super(key: key);

  TextEditingController depositTextController = TextEditingController();
  FocusNode depositFocusNode = FocusNode();

  final Color highlightColor = Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    if (form.isHaveDeposit) {
      AbstractPayPlanItemModel item = depositItem;
      if (item != null) {
        depositTextController.text = (item.payPercent * 100).toStringAsFixed(0);
      }
    }

    return Container(
        child: FormBlock(children: [
      Row(
        children: [
          FormLabel('定金设置'),
          _QuestionIcon(
            text: '定金设置适用于包工包料订单模式',
          )
        ],
      ),
      FormTitle(
        '有无定金：',
      ),
      Row(children: [
        _depositRadios(true),
        _depositRadios(false),
      ]),
      ...form.isHaveDeposit
          ? [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text('定金比例：'),
                    Container(
                      child: Expanded(
                        child: Slider(
                          value: depositItem.payPercent,
                          min: 0.10,
                          max: 0.99,
                          divisions: 89,
                          label:
                              '${(depositItem.payPercent * 100).toStringAsFixed(0)}%',
                          onChanged: (value) {
                            depositItem.payPercent = value;
                            tailItem.payPercent = 1 - value;
                            onChange?.call(form);
                          },
                          onChangeStart: (value) {},
                          onChangeEnd: (value) {},
                        ),
                      ),
                    ),
                    Text(
                        '${(depositItem.payPercent * 100).toStringAsFixed(0)}%')
                  ],
                ),
              ),
              FormTitle(
                '定金支付时间：',
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text('确认订单后：'),
                    PopupMenuButton(
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                '${depositItem.triggerDays}天',
                                style: TextStyle(color: highlightColor),
                              ),
                              Icon(Icons.arrow_drop_down)
                            ],
                          )),
                      onSelected: (e) {
                        depositItem.triggerDays = e;
                        onChange?.call(form);
                      },
                      itemBuilder: (BuildContext context) {
                        List<PopupMenuItem> items = [];
                        for (int i = 1; i < 30; i++) {
                          items.add(PopupMenuItem(
                            child: Text(
                              '$i天',
                              style: TextStyle(
                                  color: i == depositItem.triggerDays
                                      ? Constants.THEME_COLOR_MAIN
                                      : Colors.black87),
                            ),
                            value: i,
                          ));
                        }
                        return items;
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text('天内'),
                    ),
                    _QuestionIcon(
                      text: '工厂将收到定金后安排生产',
                    )
                  ],
                ),
              ),
            ]
          : [],
      FormTitle(
        '尾款支付时间：',
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text('确认《对账单》后：'),
            PopupMenuButton(
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        '${tailItem.triggerDays}天',
                        style: TextStyle(color: highlightColor),
                      ),
                      Icon(Icons.arrow_drop_down)
                    ],
                  )),
              onSelected: (e) {
                tailItem.triggerDays = e;
                onChange?.call(form);
              },
              itemBuilder: (BuildContext context) {
                List<PopupMenuItem> items = [];
                for (int i = 1; i < 30; i++) {
                  items.add(PopupMenuItem(
                    child: Text(
                      '$i天',
                      style: TextStyle(
                          color: i == tailItem.triggerDays
                              ? Constants.THEME_COLOR_MAIN
                              : Colors.black87),
                    ),
                    value: i,
                  ));
                }
                return items;
              },
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text('天内'),
            ),
            _QuestionIcon(
              text: '时间长短将影响工厂收到尾款',
            )
          ],
        ),
      )
    ]));
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
              onChange?.call(form);
            },
          ),
          Text('${val ? '有' : '无'}定金'),
        ],
      ),
    );
  }

  ///定金项
  AbstractPayPlanItemModel get depositItem {
    return form.payPlanItems.firstWhere(
        (element) => element.moneyType == PayMoneyType.DEPOSIT,
        orElse: () => null);
  }

  ///尾款项
  AbstractPayPlanItemModel get tailItem {
    return form.payPlanItems.firstWhere(
        (element) => element.moneyType == PayMoneyType.PHASEONE,
        orElse: () => null);
  }

  static CompanyPayPlanItemModel getInitModel(
      {PayMoneyType moneyType = PayMoneyType.DEPOSIT,
      TriggerEvent triggerEvent = TriggerEvent.CONTRACT_SIGNED,
      int triggerDays = 5,
      double payPercent = 0.3}) {
    return CompanyPayPlanItemModel(
        moneyType: moneyType,
        triggerEvent: triggerEvent,
        triggerDays: triggerDays,
        payPercent: payPercent);
  }
}

class _QuestionIcon extends StatelessWidget {
  final String text;

  const _QuestionIcon({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          B2BIcons.question,
          color: Colors.red,
          size: 15,
        ),
        onPressed: () {
          BotToast.showCustomText(
              onlyOne: true,
              duration: null,
              clickClose: true,
              crossPage: false,
              backgroundColor: Colors.black38,
              toastBuilder: (cancelFunc) => AlertDialog(
                    content: Container(
                        height: 80,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('提示'),
                                Icon(
                                  B2BIcons.question,
                                  color: Colors.grey[400],
                                  size: 18,
                                ),
                              ],
                            ),
                            Expanded(
                                child: Center(
                              child: Text(
                                '$text',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              ),
                            ))
                          ],
                        )),
                  ));
        });
  }
}
