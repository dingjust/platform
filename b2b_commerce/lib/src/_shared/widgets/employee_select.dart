import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

///员工选择
class EmployeeSelectPage extends StatefulWidget {
  ///多选
  bool multi;

  final _Node node;

  final int max;

  final List<B2BCustomerModel> selected;

  EmployeeSelectPage(
      {Key key, this.multi = false, this.node, this.selected, this.max = 99})
      : super(key: key);

  @override
  _EmployeeSelectPageState createState() => _EmployeeSelectPageState();
}

class _EmployeeSelectPageState extends State<EmployeeSelectPage> {
  ///当前页面节点
  _Node node;

  ///字体颜色
  static const TextStyle _textStyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87);

  ///选中员工
  List<B2BCustomerModel> selectedCustomers;

  @override
  void initState() {
    if (widget.node != null) {
      node = widget.node;
    }
    if (widget.selected != null) {
      selectedCustomers = widget.selected;
    } else {
      selectedCustomers = [];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('人员选择'),
            elevation: 0.5,
          ),
          body: Column(children: [_buildHeader(), _buildBody()]),
          bottomSheet: _buildBottom(),
        ),
        onWillPop: onPop);
  }

  ///头部
  Widget _buildHeader() {
    List<_Node> nodes = _getNodeTrackingTree(node);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: nodes.map((e) {
          bool isActive = true;
          if (e != node) {
            isActive = false;
          }
          return GestureDetector(
            onTap: () {
              setState(() {
                node = e;
              });
            },
            child: Container(
              child: Row(
                children: [
                  Container(
                    width: 5,
                  ),
                  Text(
                    e != null ? '${e?.dept?.name}' : '公司',
                    style: TextStyle(
                        color: isActive ? Colors.blueAccent : Colors.grey),
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
          );
        }).toList(),
      ),
    );
  }

  ///获取导向树
  List<_Node> _getNodeTrackingTree(_Node cNode) {
    if (cNode?.parent != null) {
      List<_Node> newList = _getNodeTrackingTree(cNode.parent);
      newList.add(cNode);
      return newList;
    }
    return [cNode];
  }

  Widget _buildBody() {
    return Expanded(
        child: Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 10),
            child: FutureBuilder<_Node>(
              builder: (BuildContext context, AsyncSnapshot<_Node> snapshot) {
                if (snapshot.data != null) {
                  return ListView(
                    children: [
                      for (_Node e in snapshot.data.children) _buildDeptRow(e),
                      for (B2BCustomerModelExt v in snapshot.data.customers)
                        _buildCustomerRow(v)
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
              future: generateTree(),
            )));
  }

  ///底部按钮
  Widget _buildBottom() {
    return Container(
      height: 45,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[300], width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '已选择: ' +
                (selectedCustomers.length > 0
                    ? '${selectedCustomers.length}人'
                    : ''),
            style: TextStyle(color: Colors.blueAccent),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(selectedCustomers);
            },
            child: Text(
              '确定',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blueAccent,
          )
        ],
      ),
    );
  }

  ///部门行
  Widget _buildDeptRow(_Node deptNode) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          setState(() {
            node = deptNode;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
          child: Row(
            children: [
              widget.multi
                  ? Checkbox(
                      value: isNodeAllSelected(deptNode),
                      onChanged: (value) {
                        //当前节点的员工
                        List<B2BCustomerModelExt> cCustomers =
                            getCustomersByNode(deptNode);
                        setState(() {
                          if (value) {
                            //判断最大限制数
                            if (selectedCustomers.length < widget.max) {
                              selectedCustomers.addAll(cCustomers);
                            }
                          } else {
                            selectedCustomers.removeWhere((element) =>
                                cCustomers
                                    .any((item) => item.id == element.id));
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
                  RichText(
                      text: TextSpan(
                          text: '${deptNode.dept.name}',
                          style: _textStyle,
                          children: [
                        TextSpan(
                            text: '(${getNodeMembersNum(deptNode)}人)',
                            style: TextStyle(color: Colors.grey))
                      ])),
                  Row(
                    children: [
                      Icon(Icons.account_tree, color: Colors.blueAccent),
                      Text(
                        '下级',
                        style: TextStyle(color: Colors.blueAccent),
                      )
                    ],
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  ///员工行
  Widget _buildCustomerRow(B2BCustomerModelExt model) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          addCustomer(model);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
          child: Row(
            children: [
              Checkbox(
                value:
                    selectedCustomers.any((element) => element.id == model.id),
                onChanged: (value) {
                  addCustomer(model);
                },
              ),
              RichText(
                  text: TextSpan(
                text: '${model.name}',
                style: _textStyle,
              ))
            ],
          ),
        ),
      ),
    );
  }

  void addCustomer(B2BCustomerModelExt model) {
    setState(() {
      if (!selectedCustomers.any((element) => element.id == model.id)) {
        if (!widget.multi) {
          //单选判断
          if (selectedCustomers.length == 0) {
            selectedCustomers.add(model);
          }
        } else {
          //判断最大限制
          if (selectedCustomers.length < widget.max) {
            selectedCustomers.add(model);
          }
        }
      } else {
        selectedCustomers.removeWhere((element) => element.id == model.id);
      }
    });
  }

  ///构建数据树
  Future<_Node> generateTree() async {
    //已有则不构建
    if (node != null) {
      return node;
    }

    List<B2BDeptModel> depts = [];
    List<B2BCustomerModelExt> b2bCustomers = [];

    //获取数据
    List<B2BDeptModel> cDepts =
        await Provider.of<B2BDeptState>(context, listen: false).getTreeList();
    List<B2BCustomerModelExt> cB2bCustomers =
        await Provider.of<B2BCustomersState>(context, listen: false).list();
    if (cDepts != null && cB2bCustomers != null) {
      depts.addAll(cDepts);
      b2bCustomers.addAll(cB2bCustomers);
    } else {
      BotToast.showText(text: '获取数据失败');
      return null;
    }

    B2BDeptModel company = B2BDeptModel(children: depts, depth: 0, name: '公司');
    //主账号
    B2BCustomerModelExt rootCustomer =
        b2bCustomers.firstWhere((element) => element.root);
    node = _Node(
      dept: company,
      customers: [rootCustomer],
    );
    List<_Node> children =
        depts.map((e) => generateNode(e, b2bCustomers, node)).toList();
    node.children = children;
    return node;
  }

  ///递归构建节点
  _Node generateNode(
      B2BDeptModel dept, List<B2BCustomerModelExt> b2bCustomers, _Node parent) {
    //筛选当前部门员工
    List<B2BCustomerModelExt> customers = b2bCustomers
        .where((element) => element?.b2bDept?.id == dept.id)
        .toList();
    b2bCustomers.removeWhere((element) => element?.b2bDept?.id == dept.id);
    _Node cNode = _Node(dept: dept, customers: customers, parent: parent);
    if (dept.children != null) {
      List<_Node> children = dept.children
          .map((e) => generateNode(e, b2bCustomers, cNode))
          .toList();
      cNode.children = children;
    }
    return cNode;
  }

  ///遍历节点所有人数
  int getNodeMembersNum(_Node node) {
    int result = 0;
    result += node.customers.length;
    if (node.children != null) {
      node.children.forEach((element) {
        result += getNodeMembersNum(element);
      });
    }
    return result;
  }

  ///遍历当前节点是否被全部选中
  bool isNodeAllSelected(_Node cNode) {
    //当前节点所有员工
    List<B2BCustomerModelExt> customers = getCustomersByNode(cNode);
    if (customers != null && customers.isNotEmpty) {
      return customers.every(
              (element) =>
              selectedCustomers.any((item) => item.id == element.id));
    }
    return false;
  }

  ///获取节点下所有员工
  List<B2BCustomerModelExt> getCustomersByNode(_Node cNode) {
    List<B2BCustomerModelExt> result = [];
    if (cNode.customers != null) {
      result.addAll(cNode.customers);
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
    if (node.parent == null) {
      return true;
    } else {
      setState(() {
        node = node.parent;
      });
    }
  }
}

class _Node {
  B2BDeptModel dept;

  List<_Node> children;

  _Node parent;

  List<B2BCustomerModelExt> customers;

  _Node({this.dept, this.children, this.parent, this.customers});
}
