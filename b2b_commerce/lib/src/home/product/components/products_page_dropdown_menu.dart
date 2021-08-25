import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import 'b2b_gzxdropdown_menu.dart';

class ProductsDropDownMunu extends StatelessWidget {
  final List<String> menus;

  final GZXDropdownMenuController dropdownMenuController;

  const ProductsDropDownMunu(
      {Key key, this.dropdownMenuController, this.menus = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductState>(builder: (context, ProductState state, _) {
      return B2BGZXDropDownMenu(
          //重写Menu组件
          controller: dropdownMenuController,
          maskColor: Color.fromRGBO(34, 34, 34, 0.3),
          // 下拉菜单显示或隐藏动画时长
          animationMilliseconds: 0,
          menus: menus
              .map((e) => GZXDropdownMenuBuilder(
                  dropDownHeight: 263,
                  dropDownWidget: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12))),
                    child: Consumer(
                      builder: (context, CategoryState categoryState, _) =>
                          FutureBuilder(
                        future: categoryState.getCascadedCategories(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<CategoryModel>> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return _buildGridView(
                                snapshot.data
                                    .firstWhere((element) => element.name == e)
                                    .children,
                                state);
                          }
                        },
                      ),
                    ),
                  )))
              .toList());
    });
  }

  Widget _buildGridView(List<CategoryModel> models, ProductState state) {
    return GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, //每行三列
            // childAspectRatio: 0.75, //显示区域宽高相等
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 20.0),
        itemCount: models.length,
        itemBuilder: (context, index) => _CategoryItem(
              model: models[index],
              selected: state?.category?.code == models[index].code,
              onChanged: (category) {
                if (state?.category?.code == category.code) {
                  state.category = null;
                } else {
                  state.category = category;
                }
                state.clear();
                dropdownMenuController.hide();
              },
            ));
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryModel model;

  final ValueChanged<CategoryModel> onChanged;

  final bool selected;

  const _CategoryItem(
      {Key key, this.model, this.onChanged, this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged?.call(model);
      },
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CachedNetworkImage(
            imageUrl: '${model?.thumbnail?.actualUrl}',
            imageBuilder: (context, imageProvider) => Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12)),
            ),
            placeholder: (context, url) => SpinKitRing(
              color: Colors.black12,
              lineWidth: 2,
              size: 40,
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.photo_outlined,
              color: Colors.grey,
              size: 40,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text('${model.name}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: selected ? Colors.orange : Color(0xff222222),
                        fontSize: 12,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.w500)),
              )
            ],
          ),
        ],
      )),
    );
  }
}
