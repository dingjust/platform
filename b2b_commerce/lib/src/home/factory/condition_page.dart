import 'package:b2b_commerce/src/business/products/product_category.dart';
import 'package:b2b_commerce/src/my/address/region_select.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ConditionPage extends StatefulWidget {
  final FactoryCondition factoryCondition;

  /// 大类
  final List<CategoryModel> categories;

  ConditionPage({Key key, @required this.categories, this.factoryCondition})
      : super(key: key);

  @override
  _ConditionPageState createState() => _ConditionPageState();
}

class _ConditionPageState extends State<ConditionPage> {
  PopulationScale populationScale;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, widget.factoryCondition);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('更多'),
            centerTitle: true,
            elevation: 0.5,
          ),
          body: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                      _buildCategoryBlock(),
                      _buildPopulationBlock(),
                      _buildAddressBlock(),
                      _buildStarsBlock(),
                      _buildMachiningTypeBlock(),
                      _buildMajorCategoryBlock()
                    ]),
                  )
                ],
              )),
        ));
  }

  Widget _buildCategoryBlock() {
    return ConditionBlock(
        label: '分类',
        height: 100,
        child: GestureDetector(
            onTap: () async {
              // 加载条
              showDialog(
                context: context,
                builder: (context) =>
                    ProgressIndicatorFactory.buildDefaultProgressIndicator(),
              );
              await ProductRepositoryImpl()
                  .cascadedCategories()
                  .then((categories) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategorySelectPage(
                          minCategorySelect:
                              widget.factoryCondition.adeptAtCategories,
                          categories: categories,
                          categoryActionType: CategoryActionType.none,
                        ),
                  ),
                );
              });
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.factoryCondition.adeptAtCategories.isEmpty
                        ? '选择分类'
                        : '${widget.factoryCondition.adeptAtCategories[0].name}',
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(Icons.chevron_right)
                ],
              ),
            )));
  }

  Widget _buildPopulationBlock() {
    return ConditionBlock(
        label: '规模',
        height: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: PopulationScale.values
              .map(
                (scale) => RadioListTile(
                      onChanged: (value) {
                        setState(() {
                          populationScale = value;
                        });
                      },
                      groupValue: populationScale,
                      value: scale,
                      title: Text('${PopulationScaleLocalizedMap[scale]}'),
                    ),
              )
              .toList(),
        ));
  }

  Widget _buildMachiningTypeBlock() {
    return ConditionBlock(
        label: '加工类型',
        height: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: CooperationModes.values
              .map(
                (type) => RadioListTile(
                      onChanged: (value) {
                        setState(() {
                          populationScale = value;
                        });
                      },
                      groupValue: populationScale,
                      value: type,
                      title: Text('${CooperationModesLocalizedMap[type]}'),
                    ),
              )
              .toList(),
        ));
  }

  Widget _buildAddressBlock() {
    return ConditionBlock(
        label: '地区',
        height: 100,
        child: GestureDetector(
            onTap: () async {
              RegionModel result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegionSelectPage(
                        RegionRepositoryImpl(),
                        onlySelectRegion: true,
                      ),
                ),
              );

              if (result != null) {
                setState(() {
                  widget.factoryCondition.productiveOrientations = result;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.factoryCondition.productiveOrientations == null
                        ? '请选择'
                        : '${widget.factoryCondition.productiveOrientations.name}',
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(Icons.chevron_right)
                ],
              ),
            )));
  }

  Widget _buildStarsBlock() {
    return ConditionBlock(
        label: '星级',
        height: 100,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StarsRating(
                starRate: widget.factoryCondition.starLevel,
                size: 30,
                onChanged: _handleStarChanged,
              ),
            ],
          ),
        ));
  }

  Widget _buildMajorCategoryBlock() {
    return ConditionBlock(
        label: '大类',
        height: 320,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget.categories
              .map(
                (categoryItem) => RadioListTile(
                      onChanged: (value) {
                        setState(() {
                          widget.factoryCondition.categories = value;
                        });
                      },
                      groupValue: widget.factoryCondition.categories,
                      value: categoryItem.code,
                      title: Text('${categoryItem.name}'),
                    ),
              )
              .toList(),
        ));
  }

  void _handleStarChanged(int newValue) {
    setState(() {
      widget.factoryCondition.starLevel = newValue;
    });
  }
}

class ConditionBlock extends StatelessWidget {
  final double height;

  final String label;

  final Widget child;

  const ConditionBlock({Key key, this.height = 100, this.label, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 1,
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.grey[300], width: 0.5))),
              ),
              Text(
                '$label',
                style: TextStyle(color: Color.fromRGBO(180, 180, 180, 1)),
              ),
              Container(
                width: 50,
                height: 1,
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: Colors.grey[300], width: 0.5))),
              )
            ],
          ),
          Container(
            width: double.infinity,
            child: child,
          )
        ],
      ),
    );
  }
}
