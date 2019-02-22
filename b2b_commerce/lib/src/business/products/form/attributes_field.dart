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
  ApparelProductAttributesModel _attributesModel;

  @override
  void initState() {
    _attributesModel = widget.item?.attributes;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () async{
//                  print(widget.item.attributes.styles);
            ApparelProductAttributesModel attribute = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApparelProductAttributesInputPage(
                  item: _attributesModel,
                ),
              ),
            );

            _attributesModel = attribute;
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