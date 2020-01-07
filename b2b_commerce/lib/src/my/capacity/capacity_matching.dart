import 'package:b2b_commerce/src/helper/login_check.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:flutter/material.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import '_shared/capacity_matching_appbar.dart';
import '_shared/capacity_matching_list.dart';
import '_shared/category_selector.dart';
import '_shared/region_city_selector.dart' as yj;
import '_shared/sort_condition.dart';

class CapacityMatchingPage extends StatefulWidget
    implements PreferredSizeWidget {
  _CapacityMatchingPageState createState() => _CapacityMatchingPageState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;
}

class _CapacityMatchingPageState extends State<CapacityMatchingPage>
    with LoginCheck {
  List<String> _dropDownHeaderItemStrings = ['全国', '品类', '时间', '筛选'];
  List<SortCondition> _distanceSortConditions = [];
  SortCondition _selectDistanceSortCondition;
  GZXDropdownMenuController _dropdownMenuController =
  GZXDropdownMenuController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => checkLoginStatus(context));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CapacityMatchingState>(
      builder: (context) => CapacityMatchingState(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          elevation: 0.5,
          title: CapacitySearch(),
          // bottom: PreferredSize(
          //     preferredSize: Size(75, 20), child: CapacityCondition()),
        ),
        // endDrawer: Drawer(child: Container()),
        drawer: Drawer(
          child: Container(),
        ),

        body: Stack(
          key: _stackKey,
          fit: StackFit.expand,
          // GZXDropDownHeader
          children: <Widget>[
            Column(
              children: <Widget>[
//              SizedBox(height: 20,),
                // 下拉菜单头部
                Builder(
                  builder: (headerContext) =>
                      GZXDropDownHeader(
                        // 下拉的头部项，目前每一项，只能自定义显示的文字、图标、图标大小修改
                        items: [
                          GZXDropDownHeaderItem(_dropDownHeaderItemStrings[0]),
                          GZXDropDownHeaderItem(_dropDownHeaderItemStrings[1]),
                          GZXDropDownHeaderItem(_dropDownHeaderItemStrings[2]),
                          GZXDropDownHeaderItem(_dropDownHeaderItemStrings[3],
                              iconData: Icons.menu, iconSize: 18),
                        ],
                        // GZXDropDownHeader对应第一父级Stack的key
                        stackKey: _stackKey,
                        // controller用于控制menu的显示或隐藏
                        controller: _dropdownMenuController,
                        // 当点击头部项的事件，在这里可以进行页面跳转或openEndDrawer
                        onItemTap: (index) {
                          if (index == 2) {
                            _onDateRangeSelect(headerContext);
                          }
                          if (index == 3) {
                            _scaffoldKey.currentState.openEndDrawer();
                          }
                        },
//                // 头部的高度
//                height: 40,
//                // 头部背景颜色
//                color: Colors.red,
//                // 头部边框宽度
                        borderWidth: 0,
//                // 头部边框颜色
                        borderColor: Colors.white,
//                // 分割线高度
                        dividerHeight: 0,
//                // 分割线颜色
//                dividerColor: Color(0xFFeeede6),
//                // 文字样式
                        // style: TextStyle(color: Colors.ye, fontSize: 13),
//                // 下拉时文字样式
                        dropDownStyle:
                        TextStyle(fontSize: 13, color: Colors.orange),
//                // 图标大小
//                iconSize: 20,
//                // 图标颜色
//                iconColor: Color(0xFFafada7),
//                // 下拉时图标颜色
                        iconDropDownColor: Colors.orange,
                      ),
                ),
                Expanded(
                  flex: 1,
                  child: CapacityMatchingListPage(),
                )
              ],
            ), // 下拉菜单
            Builder(
              builder: (dropMenuContext) =>
                  GZXDropDownMenu(
                    // controller用于控制menu的显示或隐藏
                    controller: _dropdownMenuController,
                    // 下拉菜单显示或隐藏动画时长
                    animationMilliseconds: 0,
                    // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
                    menus: [
                      GZXDropdownMenuBuilder(
                        dropDownHeight: 40 * 8.0,
                        dropDownWidget: yj.RegionCitySelector(
                            cancell: _onCancel,
                            callBack: (region, cities) =>
                                _onRegionCitySelectCallBack(
                                    region, cities, dropMenuContext)),
                      ),
                      GZXDropdownMenuBuilder(
                          dropDownHeight: 40 * 8.0,
                          dropDownWidget: Builder(
                            builder: (selectContext) =>
                                CategorySelector(
                                  callBack: (category) =>
                                      _onCategorySelectCallBacck(
                                          category, dropMenuContext),
                                ),
                          )),
                    ],
                  ),
            )
          ],
        ),
      ),
    );
  }

  ///取消
  void _onCancel() {
    _dropdownMenuController.hide();
  }

  ///地址选择回调
  void _onRegionCitySelectCallBack(RegionModel region, List<CityModel> cities,
      BuildContext selectContext) {
    CapacityMatchingState state =
    Provider.of<CapacityMatchingState>(selectContext);

    if (region != null) {
      _dropDownHeaderItemStrings[0] = region.name;
    } else {
      _dropDownHeaderItemStrings[0] = '全国';
    }
    state.setRegion(region);
    if (cities != null && cities.length != 0) {
      state.setCity(cities[0]);
    } else {
      state.setCity(null);
    }
    state.clear();
    _dropdownMenuController.hide();
    setState(() {});
  }

  ///品类选择回调
  void _onCategorySelectCallBacck(CategoryModel category,
      BuildContext selectContext) {
    CapacityMatchingState state =
    Provider.of<CapacityMatchingState>(selectContext);
    if (category != null) {
      _dropDownHeaderItemStrings[1] = category.name;
      state.setCategory(category);
    } else {
      _dropDownHeaderItemStrings[1] = '品类';
      state.setCategory(null);
    }
    _dropdownMenuController.hide();
    setState(() {});
  }

  void _onDateRangeSelect(BuildContext selectContext) async {
    DateTime firstDate;
    DateTime lastDate;
    CapacityMatchingState state =
    Provider.of<CapacityMatchingState>(selectContext);

    if (state.dateStartPoint == null) {
      firstDate = DateTime.now();
      lastDate = firstDate.add(Duration(days: 7));
    } else {
      firstDate = state.dateStartPoint;
      if (state.dateEndPoint == null) {
        lastDate = firstDate.add(Duration(days: 7));
      } else {
        lastDate = state.dateEndPoint;
      }
    }

    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: firstDate,
        initialLastDate: lastDate,
        firstDate: DateTime(2019),
        lastDate: DateTime(2099));
    if (picked != null && picked.length == 1) {
      _dropDownHeaderItemStrings[2] = '${picked[0]}';
      state.setDateStartPoint(picked[0]);
      state.setDateEndPoint(null);
      state.clear();
      setState(() {});
    }

    if (picked != null && picked.length == 2) {
      _dropDownHeaderItemStrings[2] =
      '${picked[0].month}.${picked[0].day}-${picked[1].month}.${picked[1].day}';
      state.setDateStartPoint(picked[0]);
      state.setDateEndPoint(picked[1]);
      state.clear();
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
