import 'package:flutter/material.dart';
import 'package:models/models.dart';
import '../apparel_product_privacy_select.dart';

class PrivacyField extends StatefulWidget {
  PrivacyField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _PrivacyFieldState();
}

class _PrivacyFieldState extends State<PrivacyField> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApparelProductPrivacySelectPage(),
              ),
            );
          },
          child: ListTile(
            title: Text('款式保护'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(height: 0, color: Colors.grey[400]),
        ),
      ],
    );
  }
}