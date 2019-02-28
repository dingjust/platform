import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class MajorCategoryField extends StatefulWidget{
  final RequirementOrderModel item;
  MajorCategoryField(this.item);

  MajorCategoryFieldState createState() => MajorCategoryFieldState();
}

class MajorCategoryFieldState extends State<MajorCategoryField>{
  List<EnumModel> _mojarEnumSelected = [];
  final List<CategoryModel> _majorCategory = [
    CategoryModel(code: 'C2', name: '针织'),
    CategoryModel(code: 'C3', name: '梭织'),
    CategoryModel(code: 'C4', name: '尼龙'),
  ];

  String formatEnumSelectText(List<EnumModel> enums) {
    String text = '选取';
    if (enums != null && enums.length > 0) text = enums[0].name;
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '商品大类',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Container(
                  width: 150,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(formatEnumSelectText(_mojarEnumSelected),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                        overflow: TextOverflow.ellipsis),
                  ))),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: EnumSelection(
                  enumModels: _majorCategory
                      .map((category) => EnumModel(category.code, category.name))
                      .toList(),
                  multiple: false,
                  enumSelect: _mojarEnumSelected,
                ),
              );
            },
          ).then((a) {
            setState(() {
              if(_mojarEnumSelected.length <= 0){
                widget.item.majorCategory = null;
              }else{
                widget.item.majorCategory = CategoryModel(code: _mojarEnumSelected[0].code,name: _mojarEnumSelected[0].name);
              }
            });
          });
        });
  }
}