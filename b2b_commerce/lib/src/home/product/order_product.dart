import 'package:b2b_commerce/src/_shared/widgets/category_selector.dart';
import 'package:b2b_commerce/src/_shared/widgets/filter_condition_selector.dart';
import 'package:b2b_commerce/src/_shared/widgets/region_city_selector.dart'
as yj;
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../_shared/widgets/scroll_to_top_button.dart';
import 'order_product_condition_page.dart';
import 'order_product_view.dart';

class ProductsPage extends StatefulWidget {
  String keyword;
  String factoryUid;

  ProductsPage({Key key, this.keyword, this.factoryUid}) : super(key: key);

  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  GlobalKey _productsPageKey = GlobalKey();
  ProductCondition productCondition;

  List<CategoryModel> cascadedCategories;

  bool showFilterMenu = false;

  List<FilterConditionEntry> conditionEntries = <FilterConditionEntry>[
    FilterConditionEntry(label: '排序', value: null),
    FilterConditionEntry(label: '价格升序', value: 'steppedPrice-asc'),
    FilterConditionEntry(label: '价格降序', value: 'steppedPrice-desc'),
    FilterConditionEntry(
      label: '工厂星级',
      value: 'starLevel',
    ),
    FilterConditionEntry(label: '接单数量', value: 'totalOrdersCount'),
  ];

  String _title = '看款下单';
  String _textSelect = '全部品类';

  List<String> historyKeywords;

  List<String> _dropDownHeaderItemStrings = ['排序', '地区', '品类', '筛选'];
  GZXDropdownMenuController _dropdownMenuController =
  GZXDropdownMenuController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getCascadedCategories());
    productCondition = ProductCondition([], widget.keyword ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.factoryUid != null) {
      _title = '现款商品';
    } else if (productCondition.keyword == null ||
        productCondition.keyword == '') {
      _title = '${productCondition.keyword}';
    }

    return BLoCProvider<OrderByProductBLoc>(
      // key: _productsPageKey,
      bloc: OrderByProductBLoc.instance,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          elevation: 0.5,
          title: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: 32,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    dynamic result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HistorySearch(
                                historyKey: GlobalConfigs
                                    .ORDER_PRODUCT_HISTORY_KEYWORD_KEY,
                                hintText: '请输入编码，名称，货号搜索',
                                keyword: productCondition.keyword,
                              )),
                    );

                    if (result != null) {
                      productCondition.keyword = result;
                      OrderByProductBLoc.instance.clearProducts();
                    }
                  },
                  child: Container(
                    height: 28,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[300], width: 0.5),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(B2BIcons.search,
                            color: Colors.grey, size: 18),
                        Text(
                          '${productCondition.keyword != null &&
                              productCondition.keyword != '' ? productCondition
                              .keyword : '请输入编码，名称，货号搜索'}',
                          style:
                          const TextStyle(color: Colors.grey, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Scaffold(
            key: _scaffoldKey,
            endDrawer: Drawer(
              child: ProductConditionPage(
                productCondition: productCondition,
                factoryUid: widget.factoryUid,
              ),
            ),
            body: Stack(
              key: _stackKey,
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GZXDropDownHeader(
                      items: [
                        GZXDropDownHeaderItem(_dropDownHeaderItemStrings[0]),
                        GZXDropDownHeaderItem(_dropDownHeaderItemStrings[1]),
                        GZXDropDownHeaderItem(_dropDownHeaderItemStrings[2]),
                        GZXDropDownHeaderItem(_dropDownHeaderItemStrings[3],
                            iconData: Icons.menu, iconSize: 18),
                      ],
                      stackKey: _stackKey,
                      controller: _dropdownMenuController,
                      onItemTap: (index) {
                        if (index == 3) {
                          _scaffoldKey.currentState.openEndDrawer();
                        }
                      },
                      dividerHeight: 0,
                      color: Colors.grey[100],
                      dropDownStyle:
                      TextStyle(fontSize: 13, color: Colors.orange),
                      iconDropDownColor: Colors.orange,
                    ),
                    Expanded(
                      flex: 1,
                      child: ProductsView(
                        productCondition: productCondition,
                        factoryUid: widget.factoryUid,
                      ),
                    )
                  ],
                ),
                Builder(
                  builder: (dropMenuContext) =>
                      GZXDropDownMenu(
                        controller: _dropdownMenuController,
                        // 下拉菜单显示或隐藏动画时长
                        animationMilliseconds: 0,
                        menus: [
                          GZXDropdownMenuBuilder(
                            dropDownHeight: 40.0 * conditionEntries.length + 20,
                            dropDownWidget: FilterConditionSelector(
                              // cancell: () {},
                                entries: conditionEntries,
                                callBack: (entry) => _onConditionSelect(entry)),
                          ),
                          GZXDropdownMenuBuilder(
                            dropDownHeight: 40 * 8.0,
                            dropDownWidget: yj.RegionCitySelector(
                                cancell: () {},
                                maximum: 1,
                                callBack: (region, cities) =>
                                    _onCitySelect(region, cities)),
                          ),
                          GZXDropdownMenuBuilder(
                              dropDownHeight: 40 * 8.0,
                              dropDownWidget: Builder(
                                builder: (selectContext) =>
                                    CategorySelector(
                                        callBack: (category) =>
                                            _onCategorySelect(category)),
                              )),
                        ],
                      ),
                )
              ],
            )),
        floatingActionButton: ScrollToTopButton<OrderByProductBLoc>(),
      ),
    );
  }

  void _onConditionSelect(FilterConditionEntry condition) {
    _dropdownMenuController.hide();
    setState(() {
      _dropDownHeaderItemStrings[0] = '${condition.label}';
      if (condition.value == 'steppedPrice-asc') {
        productCondition.sortCondition = 'steppedPrice';
        productCondition.sort = 'asc';
      } else if (condition.value == 'steppedPrice-desc') {
        productCondition.sortCondition = 'steppedPrice';
        productCondition.sort = 'desc';
      } else {
        productCondition.sortCondition = condition.value;
      }
    });

    _dataUpdate();
  }

  void _onCitySelect(RegionModel region, List<CityModel> cities) {
    _dropdownMenuController.hide();
    setState(() {
      _dropDownHeaderItemStrings[1] = '${region?.name ?? '全国'}';
      productCondition.region = region;
      productCondition.cities = cities ?? [];
    });
    _dataUpdate();
  }

  void _onCategorySelect(CategoryModel category) {
    _dropdownMenuController.hide();
    setState(() {
      if (category == null) {
        _dropDownHeaderItemStrings[2] = '品类';
        productCondition.categories = [];
      } else {
        productCondition.categories = [category];
        _dropDownHeaderItemStrings[2] = category.name;
      }
    });
    _dataUpdate();
  }

  void _dataUpdate() {
    ///条件更新数据
    if (widget.factoryUid == null) {
      OrderByProductBLoc.instance.getData(productCondition);
    } else {
      OrderByProductBLoc.instance.getCashProducts(widget.factoryUid);
    }
  }

  String generateCategoryStr() {
    String result = productCondition.categories
        .map((category) => category.name)
        .toList()
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '');
    if (result.isEmpty) {
      return _textSelect;
    } else {
      return result;
    }
  }

  void getCascadedCategories() async {
    cascadedCategories = await ProductRepositoryImpl().cascadedCategories();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    OrderByProductBLoc.instance.clear();
    super.dispose();
  }
}
