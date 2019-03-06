import 'package:b2b_commerce/src/business/orders/requirement_order_input_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ExpectedMachiningQuantityField extends StatefulWidget {
  RequirementOrderModel item;

  ExpectedMachiningQuantityField(this.item);

  ExpectedMachiningQuantityFieldState createState() => ExpectedMachiningQuantityFieldState();
}

class ExpectedMachiningQuantityFieldState extends State<ExpectedMachiningQuantityField> {
  @override
  Widget build(BuildContext context) {
        TextEditingController(
            text: widget.item.details.expectedMachiningQuantity == null
                ? ''
                : widget.item.details.expectedMachiningQuantity.toString());
    return GestureDetector(
      child: Container(
        child: ListTile(
          leading: Text(
            '加工数量',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Text(
            widget.item.details.expectedMachiningQuantity == null
                ? '填写'
                : widget.item.details.expectedMachiningQuantity.toString(),
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RequirementOrderInputPage(fieldText: '加工数量',inputType: TextInputType.number)),
          //接收返回数据并处理
        ).then((value) {
          setState(() {
            widget.item.details.expectedMachiningQuantity = int.parse(value);
          });
        });
      },
    );
  }
}
