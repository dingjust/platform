import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class MinorCategoryField extends StatefulWidget{
  final RequirementOrderModel item;
  List<CategoryModel> categorySelected = [];
  MinorCategoryField(this.item,this.categorySelected);


  MinorCategoryFieldState createState() => MinorCategoryFieldState();
}

class MinorCategoryFieldState extends State<MinorCategoryField>{

  final List<Map<CategoryModel, List<CategoryModel>>> _category = [
    {
      CategoryModel(code: 'W01', name: '女装'): [
        CategoryModel(
            code: 'W0101',
            name: '女式毛衣',
            parent: CategoryModel(code: 'W01', name: '女装')),
        CategoryModel(
            code: 'W0102',
            name: '女式马夹',
            parent: CategoryModel(code: 'W01', name: '女装')),
        CategoryModel(
            code: 'W0103',
            name: '女式西服',
            parent: CategoryModel(code: 'W01', name: '女装')),
        CategoryModel(
            code: 'W0104',
            name: '女式夹克',
            parent: CategoryModel(code: 'W01', name: '女装')),
        CategoryModel(
            code: 'W0105',
            name: '女式风衣',
            parent: CategoryModel(code: 'W01', name: '女装')),
        CategoryModel(
            code: 'W0106',
            name: '女式棉衣',
            parent: CategoryModel(code: 'W01', name: '女装')),
        CategoryModel(
            code: 'W0107',
            name: '女式羽绒',
            parent: CategoryModel(code: 'W01', name: '女装')),
      ],
      CategoryModel(code: 'M01', name: '男装'): [
        CategoryModel(
            code: 'M0101',
            name: '男式POLO衫',
            parent: CategoryModel(code: 'M01', name: '男装')),
        CategoryModel(
            code: 'M0102',
            name: '男式衬衫',
            parent: CategoryModel(code: 'M01', name: '男装')),
        CategoryModel(
            code: 'M0103',
            name: '男式卫衣',
            parent: CategoryModel(code: 'M01', name: '男装')),
        CategoryModel(
            code: 'M0104',
            name: '男式线衫',
            parent: CategoryModel(code: 'M01', name: '男装')),
        CategoryModel(
            code: 'M0105',
            name: '男式毛衣',
            parent: CategoryModel(code: 'M01', name: '男装')),
        CategoryModel(
            code: 'M0106',
            name: '男式马夹',
            parent: CategoryModel(code: 'M01', name: '男装')),
        CategoryModel(
            code: 'M0107',
            name: '男式西服',
            parent: CategoryModel(code: 'M01', name: '男装')),
      ],
    }
  ];

  String formatCategorySelectText(List<CategoryModel> categorys) {
    String text = '选取';
    if (categorys.isNotEmpty) text = categorys[0].name;
    return text;
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Text(formatCategorySelectText(widget.categorySelected),
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
                child: CategorySelect(
                  categorys: _category,
                  multiple: false,
                  verticalDividerOpacity: 1,
                  categorySelect: widget.categorySelected,
                ),
              );
            },
          ).then((a) {
            setState(() {
              if(widget.categorySelected.isEmpty){
                widget.item.details.category = null;
              }else{
                widget.item.details.category = widget.categorySelected[0];
              }
            });
          });
        });
  }
}