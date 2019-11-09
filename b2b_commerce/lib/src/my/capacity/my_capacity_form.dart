import 'package:core/core.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyCapacityFormPage extends StatefulWidget {
  FactoryCapacityModel model;

  MyCapacityFormPage({Key key, this.model}) : super(key: key);

  _MyCapacityFormPageState createState() => _MyCapacityFormPageState();
}

class _MyCapacityFormPageState extends State<MyCapacityFormPage> {
  FactoryCapacityModel form;

  TextEditingController titleController = TextEditingController();
  FocusNode _contentFocusNode = FocusNode();

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
      if (widget.model.longTerm == null) {
        form.longTerm = false;
      }
      widget.model.categoryCapacities.forEach((categoryCapacity) {
        capacityEntries.add(_CapacityEntry(
            textController: TextEditingController(
                text: categoryCapacity.capacityRange.toString()),
            model: categoryCapacity));
      });
    } else {
      form = FactoryCapacityModel(
        longTerm: true,
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
              focusNode: _contentFocusNode,
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
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: _showDatePicker,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
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
                            color: !form.longTerm
                                ? Colors.black87
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Text(
                        '－',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Row(
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
                            color: !form.longTerm
                                ? Colors.black87
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          Container(
            child: Column(
              children: <Widget>[
                Switch(
                  value: form.longTerm,
                  activeColor: Color.fromRGBO(255, 214, 12, 1), // 激活时原点颜色
                  onChanged: (bool val) {
                    this.setState(() {
                      form.longTerm = !form.longTerm;
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
                        child: Text('${entry.model?.category?.name}'),
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
  void _showDatePicker() async {
    _contentFocusNode.unfocus();

    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: new DateTime.now(),
        initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
        firstDate: DateTime(2019),
        lastDate: DateTime(2099));
    print(picked);
    setState(() {
      if (picked != null && picked.length == 1) {
        dateStartPoint = picked[0];
      } else if (picked != null && picked.length == 2) {
        dateStartPoint = picked[0];
        dateEndPoint = picked[1];
      }
      form.longTerm = false;
    });
  }

  Widget _buildSubmitBtn() {
    return Consumer<MyCapacityState>(
      builder: (context, MyCapacityState myCapacityState, _) =>
          Container(
            height: 40,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: FlatButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              onPressed: () => onSave(myCapacityState),
              child: Text(
                '保存',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
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

  void onSave(MyCapacityState myCapacityState) {
    if (capacityEntries.length == 0) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.CONFIRM_DIALOG,
              contentText1: '请添加品类',
              isNeedConfirmButton: true,
              confirmButtonText: '确定',
              cancelButtonText: '以后再说',
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    } else {
      onSubmit(myCapacityState);
    }
  }

  void onSubmit(MyCapacityState myCapacityState) {
    //组合表单数据
    form.dateEndPoint = dateEndPoint;
    form.dateStartPoint = dateStartPoint;
    form.title = titleController.text;
    if (form.longTerm) {
      form.dateStartPoint = null;
      form.dateEndPoint = null;
    }
    form.categoryCapacities = capacityEntries.map((entry) {
      if (entry.textController.text == '') {
        entry.model.capacityRange = 0;
      } else {
        entry.model.capacityRange = int.parse(entry.textController.text);
      }

      return entry.model;
    }).toList();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: CapacityRepository().save(form),
            outsideDismiss: false,
            loadingText: '保存中。。。',
            entrance: 'purchaseOrders',
          );
        }).then((value) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              successTips: '保存成功',
              failTips: '保存失败',
              callbackResult: value,
              confirmAction: () {
                myCapacityState.clear();
                Navigator.of(context).pop();
              },
            );
          }).then((v) {
        myCapacityState.clear();
        Navigator.of(context).pop();
      });
    });
  }
}

class _CapacityEntry {
  final TextEditingController textController;

  final FactoryCategoryCapacityModel model;

  _CapacityEntry({this.textController, this.model});
}
