import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/empty.dart';
import 'package:b2b_commerce/src/_shared/widgets/nodata_show.dart';
import 'package:b2b_commerce/src/business/orders/requirement/requirement_list_item.dart';
import 'package:b2b_commerce/src/helper/dialog_helper.dart';
import 'package:b2b_commerce/src/home/factory/factory_item_v2.dart';
import 'package:b2b_commerce/src/home/product/product_grid_item.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class MyFavoritePage extends StatefulWidget {
  @override
  _MyFavoritePageState createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  List<int> selectedIds = [];

  ///正在编辑
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyFavoriteTabSectionState>(
        create: (context) => MyFavoriteTabSectionState(),
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBarFactory.buildDefaultAppBar('我的收藏', actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  child: Text(isEditing ? '完成' : '编辑'))
            ]),
            body: Scaffold(
              appBar: TabBar(
                tabs: [
                  Tab(
                    child: Text('需求'),
                  ),
                  Tab(
                    child: Text('工厂'),
                  ),
                  Tab(
                    child: Text('款式'),
                  )
                ],
                indicatorSize: TabBarIndicatorSize.label,
              ),
              body: TabBarView(
                children: <Widget>[
                  _RequirementsListView(
                    onSelect: onSelect,
                    selected: selectedIds,
                    isEditing: isEditing,
                  ),
                  _FactoryListView(
                    onSelect: onSelect,
                    selected: selectedIds,
                    isEditing: isEditing,
                  ),
                  _ProductGridView(
                    onSelect: onSelect,
                    selected: selectedIds,
                    isEditing: isEditing,
                  ),
                ],
              ),
              bottomSheet: _buildBottom(),
            ),
          ),
        ));
  }

  Widget _buildBottom() {
    return Container(
      height: isEditing ? 60 : 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Builder(
              builder: (btnContext) => GestureDetector(
                    onTap: () => onCancel(btnContext),
                    child: Container(
                      height: 35,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 5),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.orange[400],
                                Color(0xffffd60c),
                              ])),
                      child: Center(
                        child: Text(
                          '取消收藏(${selectedIds.length})',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ))
        ],
      ),
    );
  }

  void onSelect(int id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  void onCancel(BuildContext btnContext) {
    if (selectedIds.length > 0) {
      DialogHelper.showConfirm(
          confirm: () {
            _onCancel(btnContext);
          },
          content: '确认取消${selectedIds.length}个收藏吗？');
    }
  }

  void _onCancel(BuildContext btnContext) async {
    Function cancelFunc =
        BotToast.showLoading(clickClose: false, crossPage: false);
    BaseResponse response = await FavoriteRepository.delBatch(selectedIds);
    cancelFunc.call();
    if (response != null && response.code == 1) {
      BotToast.showText(text: '取消成功');
      setState(() {
        selectedIds = [];
      });
      //更新状态
      Provider.of<MyFavoriteTabSectionState>(btnContext, listen: false)
          .refresh();
      Provider.of<MyFavoriteState>(context, listen: false).getData();
    } else {
      BotToast.showText(text: '取消失败');
    }
  }
}

class _FavoriteDetector extends StatelessWidget {
  final Widget child;

  final bool checked;

  final Function(bool) onChanged;

  final bool isEditing;

  const _FavoriteDetector(
      {Key key,
      this.child,
      this.checked,
      this.onChanged,
      this.isEditing = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isEditing
              ? Checkbox(value: checked, onChanged: onChanged)
              : Container(),
          Expanded(child: child)
        ],
      ),
    );
  }
}

class _RequirementsListView extends StatelessWidget {
  final List<int> selected;

  final ValueChanged<int> onSelect;

  final bool isEditing;

  const _RequirementsListView(
      {Key key,
      this.selected = const [],
      this.onSelect,
      this.isEditing = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MyFavoriteTabSectionState>(
        builder: (context, MyFavoriteTabSectionState state, _) =>
            Container(child: _buildBody(state)));
  }

  Widget _buildBody(MyFavoriteTabSectionState state) {
    if (state.requirementsFavorites == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state.requirementsFavorites.isNotEmpty) {
      return RefreshIndicator(
          child: ListView.builder(
              padding: EdgeInsets.only(top: 5),
              itemCount: state.requirementsFavorites.length,
              itemBuilder: (BuildContext context, int index) {
                RequirementOrderModel item = state.requirementsFavorites[index];
                return _FavoriteDetector(
                  checked: selected.contains(item.favoriteId),
                  onChanged: (val) => onSelect?.call(item.favoriteId),
                  isEditing: isEditing,
                  child: RequirementListItem(
                    model: item,
                  ),
                );
              }),
          onRefresh: () async {
            state?.refresh();
          });
    }
    return Empty();
  }
}

class _FactoryListView extends StatelessWidget {
  final List<int> selected;

  final ValueChanged<int> onSelect;

  final bool isEditing;

  const _FactoryListView(
      {Key key,
      this.selected = const [],
      this.onSelect,
      this.isEditing = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MyFavoriteTabSectionState>(
        builder: (context, MyFavoriteTabSectionState state, _) =>
            Container(child: _buildBody(state)));
  }

  Widget _buildBody(MyFavoriteTabSectionState state) {
    if (state.factoryFavorites == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state.factoryFavorites.isNotEmpty) {
      return RefreshIndicator(
          child: ListView.builder(
              padding: EdgeInsets.only(top: 5),
              itemCount: state.factoryFavorites.length,
              itemBuilder: (BuildContext context, int index) {
                FactoryModel item = state.factoryFavorites[index];
                return _FavoriteDetector(
                  checked: selected.contains(item.favoriteId),
                  onChanged: (val) => onSelect?.call(item.favoriteId),
                  isEditing: isEditing,
                  child: FactoryItem(
                    model: item,
                  ),
                );
              }),
          onRefresh: () async {
            state?.refresh();
          });
    }
    return Empty();
  }
}

class _ProductGridView extends StatelessWidget {
  final List<int> selected;

  final ValueChanged<int> onSelect;

  final bool isEditing;

  const _ProductGridView(
      {Key key,
      this.selected = const [],
      this.onSelect,
      this.isEditing = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MyFavoriteTabSectionState>(
        builder: (context, MyFavoriteTabSectionState state, _) =>
            Container(child: _buildBody(state)));
  }

  Widget _buildBody(MyFavoriteTabSectionState state) {
    if (state.productFavorites == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state.productFavorites.isNotEmpty) {
      return RefreshIndicator(
          child: GridView.builder(
              padding: EdgeInsets.only(top: 5),
              itemCount: state.productFavorites.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //每行三列
                  childAspectRatio: 0.68, //显示区域宽高相等
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0),
              itemBuilder: (BuildContext context, int index) {
                ApparelProductModel item = state.productFavorites[index];
                return _FavoriteDetector(
                  checked: selected.contains(item.favoriteId),
                  onChanged: (val) => onSelect?.call(item.favoriteId),
                  isEditing: isEditing,
                  child: ProductGridItem(
                    model: item,
                  ),
                );
              }),
          onRefresh: () async {
            state?.refresh();
          });
    }
    return Empty();
  }
}
