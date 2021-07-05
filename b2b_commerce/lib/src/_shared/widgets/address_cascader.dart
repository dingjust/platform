import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';

///地区级联选择
class AddressCascaderPage extends StatefulWidget {
  ///多选
  bool multi;

  final int max;

  final List<dynamic> selected;

  AddressCascaderPage(
      {Key key, this.multi = false, this.selected, this.max = 99})
      : super(key: key);

  @override
  _AddressCascaderPageState createState() => _AddressCascaderPageState();
}

class _AddressCascaderPageState extends State<AddressCascaderPage> {
  ///数据树
  List<dynamic> dataTree;

  ///当前页面显示选择项
  List items;

  ///当前页面节点
  // dynamic node;

  ///字体颜色
  static const TextStyle _textStyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87);

  ///选中员工
  List<dynamic> selected;

  dynamic region;

  dynamic city;

  @override
  void initState() {
    if (widget.selected != null) {
      selected = widget.selected;
    } else {
      selected = [];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('地区选择'),
            elevation: 0.5,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(selected);
                  },
                  child: Text('确定'))
            ],
          ),
          body:
              Column(children: [_buildHeader(), _buildBody(), _buildBottom()]),
        ),
        onWillPop: onPop);
  }

  ///头部
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(children: [
        GestureDetector(
          onTap: () {
            setState(() {
              items = dataTree;
              region = null;
              city = null;
            });
          },
          child: Container(
            child: Row(
              children: [
                Container(
                  width: 5,
                ),
                Text(
                  region != null ? '${region['name']}' : '省',
                  style: TextStyle(
                      color: region == null ? Colors.blueAccent : Colors.grey),
                ),
                Container(
                  width: 5,
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[300],
                )
              ],
            ),
          ),
        ),
        region != null
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    city = null;
                    items = region["cities"];
                  });
                },
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                      ),
                      Text(
                        city != null ? '${city['name']}' : '市',
                        style: TextStyle(
                            color:
                                city == null ? Colors.blueAccent : Colors.grey),
                      ),
                      Container(
                        width: 5,
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[300],
                      )
                    ],
                  ),
                ),
              )
            : Container(),
        city != null
            ? Container(
                child: Row(
                  children: [
                    Container(
                      width: 5,
                    ),
                    Text(
                      '区',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    Container(
                      width: 5,
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[300],
                    )
                  ],
                ),
              )
            : Container(),
      ]),
    );
  }

  Widget _buildBody() {
    return Expanded(
        child: Container(
            color: Colors.white,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: FutureBuilder<List>(
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.data != null) {
                  return ListView(
                    children: [
                      for (dynamic e in items) _buildDeptRow(e),
                    ],
                  );
                } else {
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
              initialData: null,
              future: _getDataTree(),
            )));
  }

  ///底部按钮
  Widget _buildBottom() {
    return Container(
      // height: 80,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[300], width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '已选: ',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          Expanded(
              child: Wrap(
            spacing: 10,
            children: [
              for (dynamic i in selected ?? [])
                Chip(
                  label: Text('${i['name']}'),
                  backgroundColor: Colors.grey[100],
                  onDeleted: () {
                    setState(() {
                      selected.removeWhere(
                          (element) => element['code'] == i['code']);
                    });
                  },
                )
            ],
          )),
        ],
      ),
    );
  }

  ///部门行
  Widget _buildDeptRow(dynamic deptNode) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            if (deptNode["cities"] != null) {
              region = deptNode;
              items = deptNode["cities"];
              print(items.first);
            } else if (deptNode["districts"] != null) {
              city = deptNode;
              items = deptNode["districts"];
            } else {
              // selected.add(deptNode);
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical:
                  (deptNode['cities'] == null && deptNode['districts'] == null)
                      ? 5
                      : 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
          child: Row(
            children: [
              widget.multi &&
                      deptNode['cities'] == null &&
                      deptNode['districts'] == null
                  ? Checkbox(
                      value: selected.indexWhere((element) =>
                              element["code"] == deptNode["code"]) >
                          -1,
                      onChanged: (value) {
                        setState(() {
                          if (value) {
                            //判断最大限制数
                            if (selected.length < widget.max) {
                              selected.add(deptNode);
                            }
                          } else {
                            selected.removeWhere((element) =>
                                element["code"] == deptNode["code"]);
                          }
                        });
                      },
                    )
                  : Container(
                      height: 30,
                      width: 15,
                    ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${deptNode['name']}',
                    style: _textStyle,
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  void addCustomer(B2BCustomerModelExt model) {
    setState(() {
      if (!selected.any((element) => element.id == model.id)) {
        if (!widget.multi) {
          //单选判断
          if (selected.length == 0) {
            selected.add(model);
          }
        } else {
          //判断最大限制
          if (selected.length < widget.max) {
            selected.add(model);
          }
        }
      } else {
        selected.removeWhere((element) => element.id == model.id);
      }
    });
  }

  ///遍历节点所有人数
  int getNodeMembersNum(dynamic node) {
    int result = 0;
    result += node.children.length;
    if (node.children != null) {
      node.children.forEach((element) {
        result += getNodeMembersNum(element);
      });
    }
    return result;
  }

  ///遍历当前节点是否被全部选中
  bool isNodeAllSelected(dynamic cNode) {
    //当前节点所有员工
    List<B2BCustomerModelExt> customers = getCustomersByNode(cNode);
    if (customers != null && customers.isNotEmpty) {
      return customers
          .every((element) => selected.any((item) => item.id == element.id));
    }
    return false;
  }

  ///获取节点下所有员工
  List<dynamic> getCustomersByNode(dynamic cNode) {
    List<dynamic> result = [];
    if (cNode.children != null) {
      result.addAll(cNode.children);
      if (cNode.children != null) {
        cNode.children.forEach((element) {
          result.addAll(getCustomersByNode(element));
        });
      }
    }
    return result;
  }

  ///返回监听
  Future<bool> onPop() async {
    if (region == null) {
      return true;
    } else {
      setState(() {
        //回退到市选择
        if (city != null && region['cities'] != null) {
          items = region['cities'];
          city = null;
        } else if (region != null && city == null) {
          //回退到省选择
          items = dataTree;
          city = null;
          region = null;
        }
      });
    }
  }

  Future<List> _getDataTree() async {
    if (dataTree == null) {
      String v = await rootBundle.loadString('data/province.json');
      List data = json.decode(v);
      if (data != null && items == null) {
        items = data;
      }
      dataTree = data;
    }
    return dataTree;
  }
}
