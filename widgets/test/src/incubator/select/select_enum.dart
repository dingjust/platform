import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'enum_select.dart';
import 'category_select.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SelectEnumPage(),
    );
  }
}

class SelectEnumPage extends StatefulWidget {
  SelectEnumPageState createState() => SelectEnumPageState();
}

class SelectEnumPageState extends State<SelectEnumPage> {
  List<EnumModel> _enumSelect = <EnumModel>[];
  List<CategoryModel> _categorySelect = [];
  final List<Map<CategoryModel, List<CategoryModel>>> _minCategorys = [
    {
      CategoryModel(code: 'C01', name: '男装'): [
        CategoryModel(code: 'C001', name: 'T恤'),
        CategoryModel(code: 'C002', name: '衬衫'),
        CategoryModel(code: 'C003', name: '卫衣'),
        CategoryModel(code: 'C004', name: '卫裤'),
        CategoryModel(code: 'C005', name: '卫裤'),
        CategoryModel(code: 'C006', name: '卫裤'),
        CategoryModel(code: 'C007', name: '卫裤'),
        CategoryModel(code: 'C008', name: '卫裤'),
        CategoryModel(code: 'C009', name: '羽绒服'),
        CategoryModel(code: 'C010', name: '绒服地方'),
        CategoryModel(code: 'C011', name: '卫裤'),
        CategoryModel(code: 'C012', name: '卫裤'),
      ],
      CategoryModel(code: 'C02', name: '女装'): [
        CategoryModel(code: 'C013', name: '棉服服'),
        CategoryModel(code: 'C014', name: '羽绒服地方'),
        CategoryModel(code: 'C015', name: '背带裤'),
        CategoryModel(code: 'C016', name: '牛仔裤'),
        CategoryModel(code: 'C017', name: '牛仔裤'),
        CategoryModel(code: 'C018', name: '牛仔裤'),
        CategoryModel(code: 'C019', name: '牛仔裤'),
        CategoryModel(code: 'C020', name: '牛仔裤'),
        CategoryModel(code: 'C021', name: '牛仔裤'),
        CategoryModel(code: 'C022', name: '牛仔裤裤'),
        CategoryModel(code: 'C023', name: '牛仔裤'),
        CategoryModel(code: 'C024', name: '牛仔裤'),
      ],
    },
  ];
  List<CategoryModel> maxCategorys = <CategoryModel>[
    CategoryModel(code: 'C1',name: '针织'),
    CategoryModel(code: 'C2',name: '针织'),
    CategoryModel(code: 'C3',name: '针织'),
    CategoryModel(code: 'C4',name: '针织'),
    CategoryModel(code: 'C5',name: '其他'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择枚举'),
      ),
      body: ListView(
        children: _enumSelect.map((enumModel) {
          return Text(enumModel.name);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
//        onPressed: () => Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => SelectEnum2Page(
//                      enumSelect: _enumSelect,
//                      multiple: true,
//                      categorySelect: _categorySelect,
//                      categorys:_minCategorys,
//                    ),
//              ),
//            ),
      onPressed: (){
        showModalBottomSheet(context: context, builder: (context){
          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('大类'),
                  ),
                  EnumSelectPage(enumSelect: _enumSelect,multiple: false,enumModels: maxCategorys.map((category) => EnumModel(category.code, category.name)).toList(),)
                ],
              ),
              Divider(),
              Expanded(child: CategorySelectPage(categorys: _minCategorys,multiple: true,categorySelect: _categorySelect,verticalDividerOpacity: 0.5,)),
            ],
          );
        });
      },
      ),
    );
  }
}
