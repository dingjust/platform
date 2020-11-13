import 'package:b2b_commerce/src/business/cooperator/cooperator_item.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/production_task_order/components/production_task_orders_select_page.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class FormTitle extends StatelessWidget {
  final String title;

  const FormTitle(
    this.title, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('$title'),
      ],
    );
  }
}

class FormLabel extends StatelessWidget {
  final String label;

  final bool require;

  const FormLabel(this.label, {Key key, this.require = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
          '$label',
          style:
              TextStyle(color: Color(0xff455a64), fontWeight: FontWeight.bold),
        ))
      ],
    );
  }
}

class FormBlock extends StatelessWidget {
  final List<Widget> children;

  const FormBlock({Key key, @required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: children,
      ),
    );
  }
}

///合作商
class FormCooperatorsSelect extends StatelessWidget {
  final GestureTapCallback onCooperatorSelect;

  final CooperatorModel value;

  const FormCooperatorsSelect({Key key, this.onCooperatorSelect, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBlock(
      children: [
        FormLabel('合作对象'),
        GestureDetector(
          onTap: onCooperatorSelect,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          border:
                          Border.all(color: Colors.grey[300], width: 0.5)),
                      child: value != null
                          ? CooperatorItem(
                        model: value,
                        onItemTap: (val) => onCooperatorSelect(),
                      )
                          : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Text(
                          '点击选择合作商',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ))),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
        )
      ],
    );
  }
}

///生产详情
class FormProduction extends StatelessWidget {
  final List<ProductionTaskOrderModel> entries;

  final ValueChanged<List<ProductionTaskOrderModel>> onEntriesChange;

  const FormProduction({Key key, this.entries, this.onEntriesChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBlock(
      children: [
        FormLabel('生产详情'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 10,
            ),
            Text('外发工单数：'),
            Expanded(
                child: Text(
                  '1',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
            MaterialButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductionTaskOrdersSelectPage()));
                },
                child: Text(
                  '选择工单',
                ),
                color: Constants.THEME_COLOR_MAIN,
                textColor: Colors.white)
          ],
        )
      ],
    );
  }
}
