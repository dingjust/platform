import 'package:b2b_commerce/src/_shared/payplan/form/simple_payplan_form.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class RequirementPayForm extends StatefulWidget {
  final CompanyPayPlanModel form;

  const RequirementPayForm({Key key, this.form}) : super(key: key);

  @override
  _RequirementPayFormState createState() => _RequirementPayFormState();
}

class _RequirementPayFormState extends State<RequirementPayForm> {
  CompanyPayPlanModel form;

  @override
  void initState() {
    super.initState();
    if (widget.form != null) {
      form = widget.form;
    } else {
      form = CompanyPayPlanModel(
          isHaveDeposit: true,
          payPlanType: PayPlanType.PHASEONE,
          payPlanItems: [
            AbstractPayPlanItemModel(
                moneyType: PayMoneyType.DEPOSIT,
                triggerEvent: TriggerEvent.ORDER_CONFIRMED,
                triggerDays: 5,
                payPercent: 0.3),
            AbstractPayPlanItemModel(
              moneyType: PayMoneyType.PHASEONE,
              triggerEvent: TriggerEvent.RECONCILIATION_CONFIRMED,
              triggerDays: 5,
            )
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('需求发布-找工厂'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(form);
              },
              child: Text('确定'))
        ],
      ),
      body: Container(
        child: SimplePayPlanForm(
            form: form,
            onChange: (val) {
              setState(() {
                form = val;
              });
            }),
      ),
    );
  }
}
