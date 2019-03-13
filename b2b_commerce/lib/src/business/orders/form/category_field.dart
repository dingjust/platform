import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class CategoryField extends StatefulWidget{
  final RequirementOrderModel item;
  ApparelProductModel product;
  CategoryField(this.item,this.product);


  CategoryFieldState createState() => CategoryFieldState();
}

class CategoryFieldState extends State<CategoryField>{
  List<CategoryModel> _category;
  List<CategoryModel> _categorySelected = [];

  void initState(){
    ProductRepositoryImpl().cascadedCategories().then((categorys)=>_category = categorys);
    super.initState();
  }

  String formatCategorySelectText(List<CategoryModel> categorys) {
    String text = '选取';
    if (categorys.isNotEmpty) text = categorys[0].name;
    return text;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.product?.minorCategory != null) _categorySelected = [widget.product.minorCategory];
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '商品类目',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Container(
                  width: 150,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(formatCategorySelectText(_categorySelected),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                        overflow: TextOverflow.ellipsis),
                  ))),
        ),
        onTap: () {
          if(widget.product == null){
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: CategorySelect(
                    categorys: _category,
                    multiple: false,
                    verticalDividerOpacity: 1,
                    categorySelect: _categorySelected,
                  ),
                );
              },
            ).then((a) {
              setState(() {
                if(_categorySelected.isEmpty){
                  widget.item.details.category = null;
                }else{
                  widget.item.details.category = _categorySelected[0];
                }
              });
            });
          }
        });
  }
}