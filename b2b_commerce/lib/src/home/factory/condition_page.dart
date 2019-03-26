import 'package:b2b_commerce/src/business/products/product_category.dart';
import 'package:b2b_commerce/src/my/address/region_select.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class CondtionPage extends StatefulWidget {
  final List<CategoryModel> categories;

  const CondtionPage({Key key, @required this.categories}) : super(key: key);

  @override
  _CondtionPageState createState() => _CondtionPageState();
}

class _CondtionPageState extends State<CondtionPage> {
  PopulationScale populationScale;
  DistrictModel districtModel;
  int starsRate = 0;
  CategoryModel majorCategory;
  List<CategoryModel> categoriesSelect = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  _buildMajorCategoryBlock()
                ]),
              )
            ],
          )),
    );
  }

  Widget _buildCategoryBlock() {
    return ConditionBlock(
        label: '分类',
        height: 100,
        child: GestureDetector(
            onTap: () async {
              //加载条
              showDialog(
                  context: context,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ));
              await ProductRepositoryImpl()
                  .cascadedCategories()
                  .then((categorys) {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategorySelectPage(
                          minCategorySelect: categoriesSelect,
                          categorys: categorys,
                          categoryActionType: CategoryActionType.none,
                        )));
              });
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    categoriesSelect.isEmpty
                        ? '选择分类'
                        : '${categoriesSelect[0].name}',
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

  Widget _buildAddressBlock() {
    return ConditionBlock(
        label: '地区',
        height: 100,
        child: GestureDetector(
            onTap: () async {
              DistrictModel result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RegionSelectPage(RegionRepositoryImpl()),
                ),
              );

              if (result != null) {
                setState(() {
                  districtModel = result;
                });
              }
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    districtModel == null
                        ? '选择地区'
                        : '${districtModel.city.region.name}  ${districtModel.city.name} ${districtModel.name}',
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
                starRate: starsRate,
                size: 30,
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
                          majorCategory = value;
                        });
                      },
                      groupValue: majorCategory,
                      value: categoryItem,
                      title: Text('${categoryItem.name}'),
                    ),
              )
              .toList(),
        ));
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
                '${label}',
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

class FactoryCondtions {
  /// 规模范围
  ScaleRanges scaleRange;

  /// 地区
  RegionModel region;

  /// 星级
  int starLevel;

  /// 加工类型
  MachiningType machiningType;

  //生产大类
  List<CategoryModel> categories;

  FactoryCondtions(
      {this.scaleRange,
      this.region,
      this.starLevel,
      this.machiningType,
      this.categories});
}

class CondtionItem {
  String label;

  dynamic condition;

  bool checked;

  CondtionItem({this.label, this.checked = false, this.condition});
}
