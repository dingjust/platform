import 'package:flutter/material.dart';
import 'package:models/models.dart';

///地区显示
class OrientationsText extends StatelessWidget {
  final List<RegionModel> regions;

  final TextStyle textStyle;

  const OrientationsText({
    Key key,
    this.regions,
    this.textStyle = const TextStyle(color: Color.fromRGBO(97, 95, 95, 1)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '区域：${regionsStr()}',
      style: textStyle,
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

///地区显示(区)
class DistrictsOrientationsText extends StatelessWidget {
  final List<DistrictModel> districts;

  final TextStyle textStyle;

  const DistrictsOrientationsText({
    Key key,
    this.districts,
    this.textStyle = const TextStyle(color: Color.fromRGBO(97, 95, 95, 1)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '区域：${districtsStr()}',
      style: textStyle,
      overflow: TextOverflow.ellipsis,
    );
  }

  String districtsStr() {
    if (districts == null || districts.isEmpty) {
      return '';
    }
    List<String> strs = districts.map((e) => e.name).toList();
    return strs.join('、');
  }
}
