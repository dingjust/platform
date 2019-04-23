import 'package:b2b_commerce/src/business/products/product_category.dart';
import 'package:b2b_commerce/src/my/address/region_select.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ConditionPage extends StatefulWidget {
  final FactoryCondition factoryCondition;

  final String requirementCode;

  List<LabelModel> labels;

  /// 大类
  final List<CategoryModel> categories;

  ConditionPage({Key key, @required this.categories, this.factoryCondition,this.requirementCode,this.labels})
      : super(key: key);

  @override
  _ConditionPageState createState() => _ConditionPageState();
}

class _ConditionPageState extends State<ConditionPage> {
  PopulationScale populationScale;

  @override
  void initState() {
    if(widget.factoryCondition.labels == null){
      widget.factoryCondition.labels = new List();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, widget.factoryCondition);
        },
        child: Scaffold(
//          appBar: AppBar(
//            title: Text('更多'),
//            centerTitle: true,
//            elevation: 0.5,
//          ),
          body: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: CustomScrollView(
                slivers: <Widget>[
                  _buildLabel('面料类别'),
                  _buildMajorCategoryBlock(),
                  _buildLabel('加工方式'),
                  _buildCooperationBlock(),
                  _buildLabel('规模'),
                  _buildPopulationBlock(),
                  SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
//                      _buildCategoryBlock(),
//                      _buildAddressBlock(),
                      _buildStarsBlock(),
                    ]),
                  ),
                  _buildLabel('工厂属性'),
                  _buildLabelsBlock(),
                ],
              )),
          persistentFooterButtons: <Widget>[
            Container(
              height: 40,
              child: Center(
                child: FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 20),
                    color: Colors.grey,
                    child: const Text(
                      '重置',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(20))),
                    onPressed: () {
                        setState(() {
                          widget.factoryCondition.populationScale = null;
                          widget.factoryCondition.cooperationModes = new List<CooperationModes>();
                          widget.factoryCondition.adeptAtCategories = new List<CategoryModel>();
                          widget.factoryCondition.categories = null;
                          widget.factoryCondition.starLevel = 0;
                          widget.factoryCondition.productiveOrientations = null;
                        });
                    }),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 50),
              height: 40,
              child:Center(
                child:  FlatButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 20),
                    color: Color(0xFFFFD600),
                    child: const Text(
                      '确定',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(20))),
                    onPressed: () {
                      ///条件更新数据
                      FactoryBLoC.instance.filterByCondition(
                        widget.factoryCondition,
                        requirementCode: widget.requirementCode,
                      );
                      Navigator.pop(context, widget.factoryCondition);
                    }),
              )
            ),
          ],
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
    return SliverPadding(
      padding: EdgeInsets.all(10),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //Grid按两列显示
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 4.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            //创建子widget
            return FilterChip(
              label: Text(
                  '${PopulationScaleLocalizedMap[PopulationScale.values[index]]}',
                  style: TextStyle(
                    fontSize: 18,
                  )),
              selectedColor: Color.fromRGBO(255, 214, 12, 1),
              backgroundColor: Colors.white,
              selected: widget.factoryCondition.populationScale ==
                  PopulationScale.values[index],
              onSelected: ((value) {
                setState(() {
                  if (value) {
                    widget.factoryCondition.populationScale =
                        PopulationScale.values[index];
                  } else {
                    widget.factoryCondition.populationScale = null;
                  }
                });
              }),
            );
          },
          childCount: PopulationScale.values.length,
        ),
      ),
    );
  }

  Widget _buildCooperationBlock() {
    return SliverPadding(
      padding: EdgeInsets.all(10),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //Grid按两列显示
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 4.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            //创建子widget
            return FilterChip(
              label: Text(
                  '${CooperationModesLocalizedMap[CooperationModes.values[index]]}',
                  style: TextStyle(
                    fontSize: 14,
                  )),
              selectedColor: Color.fromRGBO(255, 214, 12, 1),
              backgroundColor: Colors.white,
              selected: widget.factoryCondition.cooperationModes
                  .contains(CooperationModes.values[index]),
              onSelected: ((value) {
                setState(() {
                  if (value) {
                    widget.factoryCondition.cooperationModes
                        .add(CooperationModes.values[index]);
                  } else {
                    widget.factoryCondition.cooperationModes
                        .remove(CooperationModes.values[index]);
                  }
                });
              }),
            );
          },
          childCount: CooperationModes.values.length,
        ),
      ),
    );
  }

  Widget _buildLabelsBlock() {
      return SliverPadding(
        padding: EdgeInsets.all(10),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //Grid按两列显示
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0,
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              //创建子widget
              return FilterChip(
                label: Text('${widget.labels[index].name}',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                selectedColor: Color.fromRGBO(255, 214, 12, 1),
                backgroundColor: Colors.white,
                selected: widget.factoryCondition.labels.contains(widget.labels[index])
                    ,
                onSelected: ((value) {
                  print(value);
                  setState(() {
                    if (value) {
                      widget.factoryCondition.labels.add(
                          widget.labels[index]);
                    } else {
                      widget.factoryCondition.labels.remove(widget.labels[index]);
                    }
                  });
                }),
              );
            },
            childCount: widget.labels.length,
          ),
        ),
      );
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
    return SliverPadding(
      padding: EdgeInsets.all(10),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //Grid按两列显示
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 4.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            //创建子widget
            return FilterChip(
              label: Text('${widget.categories[index].name}',
                  style: TextStyle(
                    fontSize: 18,
                  )),
              selectedColor: Color.fromRGBO(255, 214, 12, 1),
              backgroundColor: Colors.white,
              selected: widget.factoryCondition.categories ==
                  widget.categories[index].code,
              onSelected: ((value) {
                setState(() {
                  if (value) {
                    widget.factoryCondition.categories =
                        widget.categories[index].code;
                  } else {
                    widget.factoryCondition.categories = null;
                  }
                });
              }),
            );
          },
          childCount: widget.categories.length,
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return SliverToBoxAdapter(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50,
            height: 1,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
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
                    bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
          )
        ],
      ),
    );
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
