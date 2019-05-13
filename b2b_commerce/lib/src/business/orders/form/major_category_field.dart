import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MajorCategoryField extends StatefulWidget{
  final RequirementOrderModel item;
  MajorCategoryField(this.item);

  MajorCategoryFieldState createState() => MajorCategoryFieldState();
}

class MajorCategoryFieldState extends State<MajorCategoryField>{
  List<EnumModel> _mojarEnumSelected = [];
  List<CategoryModel> _majorCategory ;

  String formatEnumSelectText(List<EnumModel> enums) {
    String text = '选取';
    if (enums != null && enums.length > 0) text = enums[0].name;
    return text;
  }

  @override
  void initState() {
    ProductRepositoryImpl().majorCategories().then((categorys)=>_majorCategory = categorys);
    _mojarEnumSelected = widget.item.details.majorCategory != null ? [EnumModel(widget.item.details.majorCategory.code, widget.item.details.majorCategory.name)] : [];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '面料类别',
                style: TextStyle(
                  fontSize: 16,
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
                widget.item.details.majorCategory = null;
              }else{
                widget.item.details.majorCategory = CategoryModel(code: _mojarEnumSelected[0].code,name: _mojarEnumSelected[0].name);
              }
            });
          });
        });
  }
}