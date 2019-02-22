import 'package:b2b_commerce/src/business/products/apparel_product_size_stock_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductColorSizeSelectPage extends StatefulWidget {
  List<ColorSelectEntry> colorEntries;
  List<SizeSelectEntry> sizeEntries;

  ProductColorSizeSelectPage(
      {Key key, @required this.colorEntries, @required this.sizeEntries})
      : super(key: key);

  _ProductColorSizeSelectPageState createState() =>
      _ProductColorSizeSelectPageState();
}

class _ProductColorSizeSelectPageState
    extends State<ProductColorSizeSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text('选择颜色尺码'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text('选择颜色'),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 5,
              padding: const EdgeInsets.all(5),
              children: colorChips,
            ),
            Text('选择尺码'),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 5,
              padding: const EdgeInsets.all(5),
              children: sizeChips,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get colorChips {
    return widget.colorEntries
        .map((entry) => ChoiceChip(
              avatar: entry.selected
                  ? Icon(
                      Icons.done,
                      size: 18,
                      color: Colors.white,
                    )
                  : null,
              labelPadding: entry.selected ? EdgeInsets.only(right: 10) : null,
              backgroundColor:
                  Color(int.parse('0xFF' + entry.colorModel.colorCode)),
              selectedColor:
                  Color(int.parse('0xFF' + entry.colorModel.colorCode)),
              key: ValueKey<String>(entry.colorModel.code),
              label: Text(
                entry.colorModel.name,
                style: TextStyle(color: Colors.white),
              ),
              selected: entry.selected,
              onSelected: (value) {
                setState(() {
                  entry.selected = value;
                });
              },
            ))
        .toList();
  }

  List<Widget> get sizeChips {
    return widget.sizeEntries
        .map((entry) => FilterChip(
              labelPadding: entry.selected ? EdgeInsets.only(right: 10) : null,
              selectedColor: Color.fromRGBO(255, 149, 22, 1),
              key: ValueKey<String>(entry.sizeModel.code),
              label: Text(entry.sizeModel.name),
              selected: entry.selected,
              onSelected: (value) {
                setState(() {
                  entry.selected = value;
                });
              },
            ))
        .toList();
  }
}

class ColorSelectEntry {
  final ColorModel colorModel;
  bool selected;

  ColorSelectEntry({@required this.colorModel, this.selected = false});
}

class SizeSelectEntry {
  final SizeModel sizeModel;
  bool selected;
  SizeSelectEntry({
    @required this.sizeModel,
    this.selected = false,
  });
}
