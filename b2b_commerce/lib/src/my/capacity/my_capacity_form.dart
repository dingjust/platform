import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:core/core.dart';

class MyCapacityFormPage extends StatefulWidget {
  FactoryCapacityModel model;

  MyCapacityFormPage({Key key, this.model}) : super(key: key);

  _MyCapacityFormPageState createState() => _MyCapacityFormPageState();
}

class _MyCapacityFormPageState extends State<MyCapacityFormPage> {
  FactoryCapacityModel form;

  TextEditingController titleController = TextEditingController();
  bool longTerm = false;
  List<_CapacityEntry> capacityEntries = [];
  ApparelProductModel product;
  List<CategoryModel> _category;
  List<CategoryModel> _categorySelected = [];
  DateTime dateStartPoint;
  DateTime dateEndPoint;
  var _futureBuilderFuture;

  void initState() {
    _futureBuilderFuture = getData();
    super.initState();
    if (widget.model != null) {
      form = widget.model;
      titleController.text = form.title;
      dateStartPoint = widget.model.dateStartPoint;
      dateEndPoint = widget.model.dateEndPoint;
      widget.model.categoryCapacities.forEach((categoryCapacity) {
        capacityEntries.add(_CapacityEntry(
            textController: TextEditingController(), model: categoryCapacity));
      });
    } else {
      form = FactoryCapacityModel(
        categoryCapacities: [],
      );
    }
  }

  Future<List<CategoryModel>> getData() async {
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
        body: FutureBuilder<List<CategoryModel>>(
          builder: (BuildContext context,
              AsyncSnapshot<List<CategoryModel>> snapshot) {
            if (snapshot != null) {
              return Container(
                child: ListView(
                  children: <Widget>[
                    _buildHead(),
                    _buildTime(),
                    _buildCapacityList(),
                    _buildAddButton(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '最多选择3个品类',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          initialData: null,
          future: _futureBuilderFuture,
        ),
        bottomNavigationBar: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: 50,
            child: _buildSubmitBtn()));
  }

  Widget _buildHead() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            child: TextFieldComponent(
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

  Widget _buildTime() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                dateStartPoint != null
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${DateFormatUtil.formatYMD(dateStartPoint)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.date_range,
                          size: 20,
                          color: !longTerm ? Colors.black87 : Colors.grey,
                        ),
                      ),
              ],
            ),
          ),
          Container(
            child: Text(
              '－',
              style: TextStyle(fontSize: 16),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (!longTerm) {
                _showDatePicker(2);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                dateEndPoint != null
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${DateFormatUtil.formatYMD(dateEndPoint)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.date_range,
                          size: 20,
                          color: !longTerm ? Colors.black87 : Colors.grey,
                        ),
                      ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Switch(
                  value: longTerm,
                  activeColor: Color.fromRGBO(255, 214, 12, 1), // 激活时原点颜色
                  onChanged: (bool val) {
                    this.setState(() {
                      longTerm = !longTerm;
                      dateStartPoint = null;
                      dateEndPoint = null;
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

  Widget _buildAddButton() {
    return Container(
      color: Colors.white10,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5),
      height: 50,
      child: RaisedButton(
        color: Colors.white,
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
          if (product != null) return;
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
            setState(() {
              if (_categorySelected.isNotEmpty && capacityEntries.length < 3) {
                if (!containCategory(_categorySelected[0])) {
                  capacityEntries.add(_CapacityEntry(
                      textController: TextEditingController(),
                      model: FactoryCategoryCapacityModel(
                          category: _categorySelected[0])));
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
          children: capacityEntries
              .map((entry) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text(
                                    '${entry.model.category.parent.name}－－${entry.model.category.name}'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  capacityEntries.remove(entry);
                                });
                              },
                              child: Container(
                                child: Text(
                                  '删除',
                                  style: TextStyle(color: Colors.red),
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
                              child: TextFieldComponent(
                                textAlign: TextAlign.right,
                                focusNode: FocusNode(),
                                controller: entry.textController,
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
                  ))
              .toList()),
    );
  }

  //打开日期选择器`````````
  void _showDatePicker(int index) {
    _selectDate(context, index);
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context, int index) async {
    DateTime nowTime = DateTime.now();
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: nowTime,
        firstDate: nowTime,
        lastDate: DateTime(2999));

    if (_picked != null) {
      setState(() {
        if (index == 1) {
          dateStartPoint = _picked;
        }
        if (index == 2) {
          dateEndPoint = _picked;
        }
      });
    }
  }

  Widget _buildSubmitBtn() {
    return Container(
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: FlatButton(
        color: Color.fromRGBO(255, 214, 12, 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        onPressed: onSubmit,
        child: Text(
          '保存',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  bool containCategory(CategoryModel categoryModel) {
    bool result = false;
    capacityEntries.forEach((capacity) {
      if (capacity.model.category.code == categoryModel.code) {
        result = true;
      }
    });
    return result;
  }

  void onSubmit() {
    //组合表单数据
    form.dateEndPoint = dateEndPoint;
    form.dateStartPoint = dateStartPoint;
    form.title = titleController.text;
    form.categoryCapacities = capacityEntries.map((entry) {
      entry.model.capacityRange = int.parse(entry.textController.text);
      return entry.model;
    }).toList();
    CapacityRepository().save(form);
  }
}

class _CapacityEntry {
  final TextEditingController textController;

  final FactoryCategoryCapacityModel model;

  _CapacityEntry({this.textController, this.model});
}
