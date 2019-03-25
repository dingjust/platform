import 'package:flutter/material.dart';
import 'package:models/models.dart';

class AttributeTable extends StatelessWidget {
  final ApparelProductAttributesModel attributes;

  const AttributeTable({Key key, @required this.attributes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: ListView(
        children: <Widget>[
          Table(
            columnWidths: {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(width: 1.0, color: Colors.grey[300]),
            children: [
              _buildRow(label: '风格', values: attributes.styles),
              _buildRow(label: '面料成分', value: attributes.fabricComposition),
              _buildRow(label: '版型', value: attributes.editionType),
              _buildRow(label: '款式', value: attributes.pattern),
              _buildRow(label: '袖型', value: attributes.sleeveType),
              _buildRow(label: '袖长/裤腿', value: attributes.sleeveLength),
              _buildRow(label: '图案', values: attributes.decorativePatterns),
              _buildRow(label: '流行元素', values: attributes.popularElements),
              _buildRow(label: '填充物', value: attributes.filler),
              _buildRow(label: '厚薄', value: attributes.thickness),
              _buildRow(label: '季节', value: attributes.season),
              _buildRow(label: '是否有吊牌', value: attributes.taggable ? '是' : '否'),
              _buildRow(label: '门襟', value: attributes.placket),
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
