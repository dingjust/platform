import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ProductSizeColorNum extends StatefulWidget {
  final List<EditApparelSizeVariantProductEntry> editData;

  final List<ApparelSizeVariantProductEntry> data;

  final bool update;

  const ProductSizeColorNum(
      {Key key, this.data, this.update = false, this.editData})
      : super(key: key);

  @override
  _ProductSizeColorNumState createState() => _ProductSizeColorNumState();
}

class _ProductSizeColorNumState extends State<ProductSizeColorNum> {
  @override
  Widget build(BuildContext context) {
    // Naviga

    return Scaffold(
      appBar: AppBar(
        title: Text('选择颜色尺码数量'),
        elevation: 0.5,
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context, widget.data);
            },
            child: Text(
              '确定',
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: widget.update
                  ? ColorSizeNumTable(
                      data: widget.data,
                    )
                  : EditColorSizeNumTable(
                      data: widget.editData,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
