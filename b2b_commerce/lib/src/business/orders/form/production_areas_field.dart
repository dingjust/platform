import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';
import 'package:city_pickers/city_pickers.dart';

class ProductionAreasField extends StatefulWidget {
  RequirementOrderModel item;

  ProductionAreasField(this.item);

  ProductionAreasFieldState createState() => ProductionAreasFieldState();
}

class ProductionAreasFieldState extends State<ProductionAreasField> {
  List<EnumModel> _productionAreasSelected = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '生产地区',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              widget.item.productionAreas == null
                  ? '选取'
                  : formatEnumSelectsText(
                  widget.item.productionAreas, ProvinceEnum, 3),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
          ),
        ),
        onTap: () {
//          CityPickers.showCityPicker(
//            context: context,
//            showType: ShowType.p,
//            theme: ThemeData(primaryColor: Colors.orange),
//          ).then((result) {
//            print(result);
//          });
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 300,
                child: EnumSelection(
                  enumModels: ProvinceEnum,
                  multiple: true,
                  enumSelect: _productionAreasSelected,
                  hasButton: true,
                ),
              );
            },
          ).then((val) {
            setState(() {
              if (_productionAreasSelected.length > 0) {
                widget.item.productionAreas =
                    _productionAreasSelected.map((area) => area.code).toList();
              } else {
                widget.item.productionAreas = null;
              }
            });
          });
        });
  }
}
