import 'package:flutter/material.dart';
import 'package:models/models.dart';
import '../apparel_product_attributes_input.dart';

class AttributesField extends StatefulWidget {
  AttributesField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _AttributesFieldState();
}

class _AttributesFieldState extends State<AttributesField> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
//                  print(widget.item.attributes.styles);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApparelProductAttributesInputPage(
                  item: widget.item?.attributes,
                ),
              ),
            );
          },
          child: ListTile(
            title: Text('属性'),
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