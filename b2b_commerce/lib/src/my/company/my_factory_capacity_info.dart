import 'dart:ui';

import 'package:b2b_commerce/src/my/capacity/_shared/capacity_factory_info_item.dart';
import 'package:b2b_commerce/src/my/capacity/_shared/capacity_matching_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class MyCompanyCapacityInfo extends StatefulWidget {
  MyCompanyCapacityInfo(
    this.factory, {
    Key key,
    this.isSupplier,
  }) : super(key: key);

  final FactoryModel factory;
  final bool isSupplier;

  @override
  State createState() => _MyCompanyCapacityInfoState();
}

class _MyCompanyCapacityInfoState extends State<MyCompanyCapacityInfo> {
  final double TITLE_WIDTH = 90;
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, MyFactoryCapacityState state, _) => Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 15,left:15),
                child: Row(
                  children: <Widget>[
                    Text('空闲产能',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Opacity(
                      opacity: state.capacityIndex > 0 ? 1 : 0,
                      child: InkWell(
                        onTap: state.capacityIndex > 0 ? (){
                          state.capacityIndex -= 1;
                          pageController.jumpToPage(state.capacityIndex);
                        } : null,
                        child: SizedBox(
                          width: 30,
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        onPageChanged: (_index) {
                          state.capacityIndex = _index;
                        },
                        physics: AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: widget.factory.capacities
                            .map((capacity) => CapacityFactoryInfoItem(
                          model: capacity,
                        ))
                            .toList(),
                        controller: pageController,
                      ),
                    ),
                    Opacity(
                      opacity: state.capacityIndex <
                          widget.factory.capacities.length - 1
                          ? 1
                          : 0,
                      child: InkWell(
                        onTap: state.capacityIndex <
                            widget.factory.capacities.length - 1 ? (){
                          state.capacityIndex += 1;
                          pageController.jumpToPage(state.capacityIndex);
                        } : null,
                        child: SizedBox(
                          width: 30,
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
                child: Center(
                  child: Indicator(
                    pageIndex: state.capacityIndex,
                    itemCount: widget.factory.capacities.length,
                  ),
                ),
              )
            ],
          ),
        ),);
  }

  //格式化类别
  String formatCategoriesSelectText(List<CategoryModel> categories, int count) {
    String text = '';
    Map<String, List<String>> map = Map();
    if (categories != null) {
      text = '';
      for (int i = 0; i < categories.length; i++) {
        if (categories[i].parent == null) {
          return formatCategoriesSelectText2(categories, categories.length);
        }
        if (map[categories[i].parent.name] == null) {
          map[categories[i].parent.name] = [categories[i].name];
        } else {
          map[categories[i].parent.name].add(categories[i].name);
        }
      }

      map.forEach((key, value) {
        if (key != '大类') {
          text += key;
          text += '--';
        }
        for (int i = 0; i < value.length; i++) {
          if (i == value.length - 1) {
            text += value[i];
            if (map.keys.last != key) {
              text += '\n';
            }
          } else {
            text += value[i] + '、';
          }
        }
      });
    }

    return text;
  }

  //格式化类别
  String formatCategoriesSelectText2(
      List<CategoryModel> categories, int count) {
    String text = '';

    if (categories != null) {
      text = '';
      for (int i = 0; i < categories.length; i++) {
        if (i > count - 1) {
          text += '...';
          break;
        }

        if (i == categories.length - 1) {
          text += categories[i].name;
        } else {
          text += categories[i].name + '、';
        }
      }
    }

    return text;
  }
}

class Indicator extends StatelessWidget {
  Indicator({
    this.pageIndex,
    this.itemCount: 0,
  }) : assert(pageIndex != null);

  /// PageView的控制器
  final int pageIndex;

  /// 指示器的个数
  final int itemCount;

  /// 普通的颜色
  final Color normalColor = Colors.white;

  /// 选中的颜色
  final Color selectedColor = Color(0xffffd60c);

  /// 点的大小
  final double size = 20.0;

  /// 点的间距
  final double spacing = 5.0;

  /// 点的Widget
  Widget _buildIndicator(
      int index, int pageCount, double dotSize, double spacing) {
    // 是否是当前页面被选中
    bool isCurrentPageSelected = index == pageIndex;

    return new Container(
      height: size,
      width: size + (2 * spacing),
      child: new Center(
        child: new Container(
          width: dotSize,
          height: dotSize,
          child: Center(child: Text((index+1).toString())),
          decoration: BoxDecoration(
            color: isCurrentPageSelected ? selectedColor : normalColor,
            border: Border.all(),
            borderRadius: BorderRadius.circular(50)
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, (int index) {
        return _buildIndicator(index, itemCount, size, spacing);
      }),
    );
  }
}
