import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/tab_factory.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'cooperators_list.dart';

///合作商列表页
class CooperatorsPage extends StatefulWidget {
  ///数据选择数组
  final List<CooperatorModel> selectedData;

  ///选择模式
  final bool selectingMode;

  ///选择模式下最大限制
  final int max;

  /// [selectingMode]=true 时为选择合作商
  ///
  /// 示例：
  ///
  /// ```dart preamble
  /// List<CooperatorModel> cooperators = await Navigator.push(
  ///     context,
  ///     MaterialPageRoute(
  ///         builder: (context) => CooperatorsPage(
  ///               selectingMode: true,
  ///               max:1
  ///             )));
  /// ```
  const CooperatorsPage(
      {Key key, this.selectedData, this.selectingMode = false, this.max = 99})
      : super(key: key);

  @override
  _CooperatorsPageState createState() => _CooperatorsPageState();
}

class _CooperatorsPageState extends State<CooperatorsPage> {
  bool isSearching = false;
  TextEditingController controller;
  FocusNode focusNode;

  ///用于选择模式中的数据
  List<CooperatorModel> selectedData;

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();

    selectedData = [];
    if (widget.selectedData != null) {
      selectedData.addAll(widget.selectedData);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CooperatorV2State>(
      create: (context) => CooperatorV2State(
          selectedData: selectedData,
          onItemTap: widget.selectingMode ? onItemTap : null),
      child: Scaffold(
        appBar: _buildAppbar(),
        body: DefaultTabController(
          length: _statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(_statuses, scrollable: false),
            body: TabBarView(
              children: _statuses
                  .map((status) => CooperatorsView(status: status))
                  .toList(),
            ),
          ),
        ),
        floatingActionButton: _AddButton(),
        bottomSheet: _buildBottomBtns(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Widget _buildSearchButton() {
    return IconButton(
        icon: const Icon(B2BIcons.search, size: 20),
        onPressed: () {
          setState(() {
            isSearching = true;
          });
        });
  }

  Widget _buildAppbar() {
    return isSearching
        ? AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            title: Consumer<CooperatorV2State>(
              builder: (context, CooperatorV2State state, _) =>
                  SearchAppbarTitle(
                controller: controller,
                focusNode: focusNode,
                hintText: '请输入合作商名称',
                onSearch: () {
                  state.setKeyword(controller.text);
                  if (controller.text == '') {
                    setState(() {
                      isSearching = false;
                    });
                  }
                },
                onChange: (v) {
                  state.setKeyword(controller.text);
                },
              ),
            ))
        : AppBarFactory.buildDefaultAppBar('合作商管理',
            actions: <Widget>[_buildSearchButton()]);
  }

  Widget _buildBottomBtns({double height = 55}) {
    return widget.selectingMode
        ? Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      height: height,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(),
                          disabledColor: Colors.grey,
                          onPressed: () {
                            setState(() {
                              selectedData.clear();
                            });
                          },
                          child: Text('重置',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ))),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      height: height,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(),
                          disabledColor: Colors.grey,
                          onPressed: () {
                            Navigator.of(context).pop(selectedData);
                          },
                          color: Constants.THEME_COLOR_MAIN,
                          child: Text('确定',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ))),
                    ))
              ],
            ),
          )
        : Container(
            height: 0,
          );
  }

  ///选择
  void onItemTap(CooperatorModel model) {
    setState(() {
      if (selectedData.any((element) => element.id == model.id)) {
        selectedData.removeWhere((element) => element.id == model.id);
      } else {
        if (selectedData.length < widget.max) {
          selectedData.add(model);
        }
      }
    });
  }
}

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context)
            .pushNamed(AppRoutes.ROUTE_COOPERATORS_CREATE)
            .then((value) {});
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}

const _statuses = <EnumModel>[
  EnumModel('SUPPLIER', '加工厂'),
  EnumModel('CUSTOMER', '客户'),
  EnumModel('FABRIC_SUPPLIER', '面辅料商'),
];
