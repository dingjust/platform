import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class MaxExpectedPriceField extends StatefulWidget{
  final RequirementOrderModel item;
  MaxExpectedPriceField(this.item);

  MaxExpectedPriceFieldState createState() => MaxExpectedPriceFieldState();
}

class MaxExpectedPriceFieldState extends State<MaxExpectedPriceField>{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '期望价格',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text('${widget.item.details?.maxExpectedPrice ?? '填写'}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PopupWindowPage(
                fieldText: '期望价格',
                text:widget.item.details.maxExpectedPrice == null ? null : widget.item.details.maxExpectedPrice.toString(),
              ),
            ),
            //接收返回数据并处理
          ).then((value){
            if(value.trim() == ''){
              widget.item.details.maxExpectedPrice = null;
            }else{
              widget.item.details.maxExpectedPrice = double.parse(value);
            }
          });
        });
  }
}