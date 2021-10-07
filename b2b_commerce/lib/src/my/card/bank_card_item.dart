import 'package:flutter/material.dart';
import 'package:models/models.dart';

class BankCardItem extends StatelessWidget {
  final BankCardModel model;

  final VoidCallback onTap;

  final VoidCallback onLongPress;

  const BankCardItem({Key key, this.model, this.onTap, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      onLongPress: () {
        onLongPress?.call();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            _buildRow1(),
            _buildRow2(),
            _buildRow3(),
          ],
        ),
      ),
    );
  }

  Widget _buildRow1() {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: Text(
            '${model.bankName}',
            style: TextStyle(fontSize: 16, color: Color(0xFF222222)),
          ))
        ],
      ),
    );
  }

  Widget _buildRow2() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(
            '${model.accountName}',
            style: TextStyle(color: Color(0xFF222222)),
          ))
        ],
      ),
    );
  }

  Widget _buildRow3({int size = 4}) {
    List<String> strs = [];
    int groupLength;
    int a = model.cardNumber.length % size;
    if (a == 0) {
      groupLength = model.cardNumber.length ~/ size;
    } else {
      groupLength = model.cardNumber.length ~/ size + 1;
    }

    for (int i = 0; i < groupLength; i++) {
      if (i != groupLength - 1) {
        strs.add(model.cardNumber.substring(i * size, (i + 1) * size));
      } else {
        strs.add(model.cardNumber.substring(i * size));
      }
    }

    return Container(
      child: Row(
          children: strs
              .map((e) => Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      '$e',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF222222)),
                    ),
                  ))
              .toList()),
    );
  }
}
