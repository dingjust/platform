import 'package:flutter/material.dart';
import 'package:models/models.dart';

class AttributeTable extends StatelessWidget {
  final ApparelProductModel product;

  const AttributeTable({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Set<String> colorSet = Set();
    Set<String> sizeSet = Set();
    String colorString = '';
    String sizeString = '';

    product.variants.forEach((variant) {
      colorSet.add(variant.color.name);
      sizeSet.add(variant.size.name);
    });

    colorSet.forEach((color) {
      colorString = "${colorString} ${color}";
    });

    sizeSet.forEach((size) {
      sizeString = "${sizeString} ${size}";
    });

    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: ListView(
        children: <Widget>[
          Table(
            columnWidths: {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(width: 1.0, color: Colors.grey[300]),
            children: [
              _buildRow(label: '商品货号', value: product.skuID ?? ''),
              _buildRow(label: '商品类目', value: product.category.name ?? ''),
              _buildRow(label: '颜色', value: colorString),
              _buildRow(label: '尺码', value: sizeString),
              _buildRow(label: '品牌', value: product.brand ?? ''),
              _buildRow(
                  label: '重量',
                  value: product.gramWeight != null
                      ? product.gramWeight.toString()
                      : ''),
              _buildRow(label: '风格', values: product.attributes.styles ?? []),
              _buildRow(
                  label: '面料成分',
                  value: product.attributes.fabricComposition ?? ''),
              _buildRow(
                  label: '版型', value: product.attributes.editionType ?? ''),
              _buildRow(label: '款式', value: product.attributes.pattern ?? ''),
              _buildRow(
                  label: '袖型', value: product.attributes.sleeveType ?? ''),
              _buildRow(
                  label: '袖长/裤腿', value: product.attributes.sleeveLength ?? ''),
              _buildRow(
                  label: '图案',
                  values: product.attributes.decorativePatterns ?? []),
              _buildRow(
                  label: '流行元素',
                  values: product.attributes.popularElements ?? []),
              _buildRow(label: '填充物', value: product.attributes.filler ?? ''),
              _buildRow(label: '厚薄', value: product.attributes.thickness ?? ''),
              _buildRow(label: '季节', value: product.attributes.season ?? ''),
              _buildRow(
                  label: '是否有吊牌',
                  value: product.attributes.taggable == null
                      ? ''
                      : product.attributes.taggable ? '是' : '否'),
              _buildRow(label: '门襟', value: product.attributes.placket ?? ''),
            ],
          )
        ],
      ),
    );
  }

  TableRow _buildRow({String label, String value, List<String> values}) {
    return TableRow(
      children: <Widget>[
        TableCell(
            child: Container(
          color: Color.fromRGBO(250, 250, 250, 1),
          alignment: Alignment.center,
          child: Text(
            '${label}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
          ),
          height: 40.0,
        )),
        TableCell(
            child: Container(
          color: Color.fromRGBO(250, 250, 250, 1),
          alignment: Alignment.center,
          child: Text(
            '${generateValue(value: value, values: values)}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
          ),
          height: 40.0,
        )),
      ],
    );
  }

  String generateValue({String value, List<String> values}) {
    if (value != null && values == null) {
      return value;
    } else if (values != null && value == null) {
      String result = '';
      values.forEach((str) {
        result = '${result} ${str}';
      });
      return result;
    }
  }
}
