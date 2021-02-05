import 'package:flutter/material.dart';
import 'package:models/models.dart';

///地区显示
class OrientationsText extends StatelessWidget {
  final List<RegionModel> regions;

  const OrientationsText({Key key, this.regions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '区域：${regionsStr()}',
      style: TextStyle(color: Color.fromRGBO(97, 95, 95, 1)),
      overflow: TextOverflow.ellipsis,
    );
  }

  String regionsStr() {
    if (regions == null || regions.isEmpty) {
      return '';
    }
    List<String> strs = regions.map((e) => e.name).toList();
    return strs.join('、');
  }
}
