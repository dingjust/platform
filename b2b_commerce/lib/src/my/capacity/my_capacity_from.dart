import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:core/core.dart';

class MyCapacityFromPage extends StatefulWidget{
  _MyCapacityFromPageState createState() => _MyCapacityFromPageState();
}


class _MyCapacityFromPageState extends State<MyCapacityFromPage>{
  TextEditingController titleController = TextEditingController();
  DateTime validityStart;
  DateTime validityEnd;
  bool longTerm = false;
  List<Widget> capacityList = List();
  ApparelProductModel product;
  List<CategoryModel> _category;
  List<CategoryModel> _categorySelected = [];
  List<CategoryModel> _categories = [];
  var _futureBuilderFuture;
  List<SubmitData> submitList;

  void initState() {
    _futureBuilderFuture = getData();
    super.initState();
  }

  Future<List<CategoryModel>> getData() async{
    ProductRepositoryImpl()
        .cascadedCategories()
        .then((categories) => _category = categories);
    return _category;
  }

  String formatCategorySelectText(List<CategoryModel> categories) {
    String text = '选取';
    if (categories.isNotEmpty) text = categories[0].name;
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新增产能'),
        elevation: 0.5,
        centerTitle: true,
      ),
      body : FutureBuilder<List<CategoryModel>>(
        builder: (BuildContext context,
            AsyncSnapshot<List<CategoryModel>> snapshot) {
          if (snapshot != null) {
            return Container(
              child: ListView(
                children: <Widget>[
                  _buildHead(),
                  _buildTime(),
                  _buildAddButton(),
                  _buildCapacityList(),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }, initialData: null,
        future: _futureBuilderFuture,
      ),
    );
  }

  Widget _buildHead(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '标题：',
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 100,
            child:TextFieldComponent(
              textAlign: TextAlign.left,
              focusNode: FocusNode(),
              controller: titleController,
              autofocus: true,
              inputType: TextInputType.number,
              hideDivider: true,
              hintText: '请输入标题',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTime(){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Text(
              '空闲时间：',
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!longTerm) {
                _showDatePicker(1);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                validityStart != null?
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '${DateFormatUtil.formatYMD(validityStart)}',
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                ):
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.date_range,
                    size: 20,
                    color: !longTerm?Colors.black87:Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              '－',
              style: TextStyle(
                  fontSize: 16
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              if(!longTerm) {
                _showDatePicker(2);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                validityEnd != null?
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '${DateFormatUtil.formatYMD(validityEnd)}',
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                ):
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.date_range,
                    size: 20,
                    color: !longTerm?Colors.black87:Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 100,
            child: Column(
              children: <Widget>[
                Switch(
                  value: longTerm,
                  activeColor: Color.fromRGBO(255, 214, 12, 1),     // 激活时原点颜色
                  onChanged: (bool val) {
                    this.setState(() {
                      longTerm = !longTerm;
                      validityStart = null;
                      validityEnd = null;
                    });
                  },
                ),
                Container(
                  child: Text('长期有效'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(){
    return Container(
      color: Colors.white10,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5),
      height: 50,
      child: RaisedButton(
        color: Color.fromRGBO(255, 214, 12, 1),
        child: Text(
          '添加生产品类',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        onPressed: () {
          if(product != null) return;
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: CategorySelect(
                  categories: _category,
                  multiple: false,
                  verticalDividerOpacity: 1,
                  categorySelect: _categorySelected,
                  categoryActionType: CategoryActionType.TO_POP,
                ),
              );
            },
          ).then((a) {
            print(_categorySelected[0].parent.name);
            setState(() {
              if (_categorySelected.isNotEmpty && capacityList.length < 3) {
                if (!_categories.contains(_categorySelected[0])) {
                  _categories.add(_categorySelected[0]);
//                  SubmitData submitData = SubmitData();
//                  submitData.code = _categorySelected[0].code;
//                  submitList.add(submitData);
                  int index = capacityList.length;
                  capacityList.add(
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      '${_categorySelected[0].parent.name}－－${_categorySelected[0].name}'
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      capacityList.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    child: Text(
                                      '删除',
                                      style: TextStyle(
                                        color: Colors.red
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      '日产能：',
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 100,
                                  child:TextFieldComponent(
                                    textAlign: TextAlign.right,
                                    focusNode: FocusNode(),
                                    controller: titleController,
                                    autofocus: false,
                                    inputType: TextInputType.number,
                                    hideDivider: true,
                                    hintText: '请输入日产能（件）',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      )
                  );
                }
                _categorySelected = [];
              }
            });
          });
        },
      ),
    );
  }

  Widget _buildCapacityList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: capacityList,
      ),
    );
  }


  //打开日期选择器`````````
  void _showDatePicker(int index) {
    _selectDate(context,index);
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context,int index) async {
    DateTime nowTime = DateTime.now();
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: nowTime,
        firstDate: nowTime,
        lastDate: DateTime(2999));

    if (_picked != null) {
      setState(() {
        if(index == 1) {
          validityStart = _picked;
        }
        if(index == 2){
          validityEnd = _picked;
        }
      });
    }
  }

}

class SubmitData{
  String code;
  int capacityNumber;
}