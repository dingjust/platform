import 'dart:async';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './address_picker.dart';
import './find_factory_by_map.dart';
import '../home/factory/factory_list.dart';

List<CategoryModel> _categories;

final List<CategoryModel> _majorCategory = [
  CategoryModel(code: 'C2', name: '针织'),
  CategoryModel(code: 'C3', name: '针织'),
  CategoryModel(code: 'C4', name: '针织'),
];

final List<EnumModel> processingTypeList = [
  EnumModel.fromJson({'code': 'FOB', 'name': 'FOB'}),
  EnumModel.fromJson({'code': 'PURE_PROCESSING', 'name': 'PURE_PROCESSING'}),
  EnumModel.fromJson({'code': 'ODM', 'name': 'ODM'}),
  EnumModel.fromJson({'code': 'OEM', 'name': 'OEM'}),
];

final List<EnumModel> technologyList = [
  EnumModel.fromJson({'code': '全工艺', 'name': '全工艺'}),
  EnumModel.fromJson({'code': '打板', 'name': '打板'}),
  EnumModel.fromJson({'code': '车缝', 'name': '车缝'}),
  EnumModel.fromJson({'code': '裁剪', 'name': '裁剪'}),
  EnumModel.fromJson({'code': '印花', 'name': '印花'}),
  EnumModel.fromJson({'code': '后枕', 'name': '后枕'}),
];

class ScreenConditions extends StatefulWidget {
  ScreenConditions({@required this.route});

  final String route;

  _ScreenConditionsState createState() => _ScreenConditionsState();
}

class _ScreenConditionsState extends State<ScreenConditions> {
  List<CategoryModel> _majorSelected = [];
  List<EnumModel> _majorEnumSelected = [];
  List<CategoryModel> _categorySelected = [];
  List<EnumModel> _processingTypeSelected = [];
  List<EnumModel> _technologySelected = [];
  String major = '点击选取';
  String category = '点击选取';
  bool _isShowA = false;
  bool _isShowB = false;
  bool _isShowC = false;
  bool _isShowD = false;
  String requestCount = '输入';
  TextEditingController inputNumber;
  bool _isShowMore = true;
  String address = '点击选取';
  String processingType = '点击选取';
  String technology = '点击选取';

  @override
  void initState() {
    _isShowA = false;
    _isShowB = false;
    _isShowC = false;
    _isShowD = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: Text('要生产什么'),
        ),
        body: Container(
            child: ListView(
          children: <Widget>[
            _buildBody(context),
            _buildHideBody(context),
            _buildCommitButton(context),
          ],
        )));
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            _buildTips(context),
            _buildMajor(context),
            _buildCategory(context),
            _buildRequestCount(context),
            _buildAddress(context),
            _buildHideTips(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHideBody(BuildContext context) {
    return Offstage(
        offstage: _isShowMore,
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                _buildScreenFactory(context),
                _buildCooperationModes(context),
                _buildTechnology(context),
              ],
            ),
          ),
        ));
  }

  Widget _buildTips(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
        "描述需求可以帮您更快速的找到合适的工厂",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMajor(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ListTile(
              leading: Text(
                "大类",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Container(
                  width: 150,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(major,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis),
                  ))),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onTap: () {
          _showMajorCategorySelect();
        });
  }

  Widget _buildCategory(BuildContext context) {
    return GestureDetector(
        child: Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: ListTile(
                leading: Text(
                  "小类",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
                    width: 150,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(category,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis),
                    ))),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(16),
            )),
        onTap: () {
          _showCategorySelect();
        });
  }

  Widget _buildRequestCount(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ListTile(
            leading: Text(
              "需求数量",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              requestCount,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onTap: () {
          _neverSatisfied(context);
        });
  }

  Widget _buildAddress(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ListTile(
            leading: Text(
              "生产地区",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              address,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onTap: () {
          address = '';
          AddressPicker(cacel: () {
            Navigator.pop(context);
          }).showAddressPicker(
            context,
            selectProvince: (province) {
              address += province['name'];
            },
            selectCity: (city) {
              address += city['name'];
            },
            selectArea: (area) {
              address += area['name'];
              setState(() {
                address = address;
              });
            },
          );
          setState(() {
            address = address;
          });
        });
  }

  Widget _buildHideTips(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(""),
                  ),
                  Text(
                    "更多条件",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(255, 214, 12, 1),
                    ),
                  ),
                  Icon(
                    _isShowMore
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Color.fromRGBO(255, 214, 12, 1),
                    size: 28,
                  ),
                ],
              )),
        ),
        onTap: () {
          setState(() {
            _isShowMore = !_isShowMore;
          });
        });
  }

  Widget _buildScreenFactory(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      height: 90,
      child: GridView.count(
        childAspectRatio: 10 / 2.5,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: <Widget>[
          CheckboxListTile(
            title: Text('品牌工厂'),
            value: _isShowA,
            onChanged: (T) {
              setState(() {
                _isShowA = !_isShowA;
              });
            },
          ),
          CheckboxListTile(
            title: Text('担保交易'),
            value: _isShowB,
            onChanged: (T) {
              setState(() {
                _isShowB = !_isShowB;
              });
            },
          ),
          CheckboxListTile(
            title: Text('免费打样'),
            value: _isShowC,
            onChanged: (T) {
              setState(() {
                _isShowC = !_isShowC;
              });
            },
          ),
          CheckboxListTile(
            title: Text('认证工厂'),
            value: _isShowD,
            onChanged: (T) {
              setState(() {
                _isShowD = !_isShowD;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCooperationModes(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ListTile(
            leading: Text(
              "加工类型",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              processingType,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onTap: () {
          _showTypeSelect();
        });
  }

  Widget _buildTechnology(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: ListTile(
            leading: Text(
              "工艺",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              technology,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onTap: () {
          _showTechnologySelect();
        });
  }

  Widget _buildCommitButton(BuildContext context) {
    return Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: RaisedButton(
          color: Color.fromRGBO(255, 214, 12, 1),
          child: Text(
            '确定',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          onPressed: () {
            String _selected = '';
            if (_isShowA) {
              _selected += '品牌工厂,';
            }
            if (_isShowB) {
              _selected += '担保交易,';
            }
            if (_isShowC) {
              _selected += '免费打样,';
            }
            if (_isShowD) {
              _selected += '认证工厂,';
            }
            print('大类：' +
                major +
                '\n小类：' +
                category +
                '\n需求数量：' +
                requestCount +
                '\n生产地区：' +
                address +
                '\n勾选条件：' +
                _selected +
                '\n加工类型：' +
                processingType +
                '\n工艺：' +
                technology);

            if (widget.route == '地图找厂') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FindFactoryByMap()),
              );
            } else {
              Navigator.push(
                context,
//                  MaterialPageRoute(builder: (context) => RequirementPoolAll()),
                MaterialPageRoute(
                    builder: (context) => FactoryPage(
                          FactoryCondition(
                              starLevel: 0,
                              adeptAtCategories: [],
                              labels: [],
                              cooperationModes: []),
                          route: widget.route,
                        )),
              );
            }
          },
        ));
  }

  //大类
  void _showMajorCategorySelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: EnumSelection(
            enumModels: _majorCategory
                .map((category) => EnumModel(category.code, category.name))
                .toList(),
            multiple: false,
            enumSelect: _majorEnumSelected,
          ),
        );
      },
    ).then((val) {
      major = '';
      _majorSelected = _majorEnumSelected
          .map((enumModel) =>
              CategoryModel(code: enumModel.code, name: enumModel.name))
          .toList();
      if (_majorSelected.isNotEmpty) {
        for (int i = 0; i < _majorSelected.length; i++) {
          major += _majorSelected[i].name + ',';
        }
      }
      setState(() {
        major = major;
      });
    });
  }

  //小类
  void _showCategorySelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: CategorySelect(
            categories: _categories,
            multiple: false,
            verticalDividerOpacity: 1,
            categorySelect: _categorySelected,
          ),
        );
      },
    ).then((val) {
      category = '';
      if (_categorySelected.isNotEmpty) {
        for (int i = 0; i < _categorySelected.length; i++) {
          category += _categorySelected[i].name + ',';
        }
      }
      setState(() {
        category = category;
      });
    });
  }

  //加工类型
  void _showTypeSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: EnumSelection(
            enumModels: processingTypeList,
            multiple: true,
            enumSelect: _processingTypeSelected,
          ),
        );
      },
    ).then((val) {
      processingType = '';
      if (_processingTypeSelected.isNotEmpty) {
        for (int i = 0; i < _processingTypeSelected.length; i++) {
          processingType += _processingTypeSelected[i].name + ',';
        }
      }
      setState(() {
        processingType = processingType;
      });
    });
  }

  //工艺
  void _showTechnologySelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: EnumSelection(
            enumModels: technologyList,
            multiple: true,
            enumSelect: _technologySelected,
          ),
        );
      },
    ).then((val) {
      technology = '';
      if (_technologySelected.isNotEmpty) {
        for (int i = 0; i < _technologySelected.length; i++) {
          technology += _technologySelected[i].name + ',';
        }
      }
      setState(() {
        technology = technology;
      });
    });
  }

  //数量
  Future<void> _neverSatisfied(BuildContext context) async {
    inputNumber = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入数量'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: inputNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '请输入数量',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if (inputNumber.text != null) {
                  print(inputNumber.text);
                  setState(() {
                    requestCount = inputNumber.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //最后确认提交
  Future<void> _showResult(BuildContext context) async {
    inputNumber = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('结果'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: inputNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '请输入数量',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
