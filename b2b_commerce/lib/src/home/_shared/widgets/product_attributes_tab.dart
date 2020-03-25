import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductAttributesTab extends StatefulWidget {
  final ApparelProductModel model;

  const ProductAttributesTab(
    this.model, {
    Key key,
  }) : super(key: key);

  @override
  _ProductAttributesTabState createState() => _ProductAttributesTabState();
}

class _ProductAttributesTabState extends State<ProductAttributesTab>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Set<String> colorSet = Set();
  Set<String> sizeSet = Set();

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    widget.model.variants.forEach((variant) {
      colorSet.add(variant.color.name);
      sizeSet.add(variant.size.name);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      // padding: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Constants.THEME_COLOR_MAIN,
            indicatorPadding:
                EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
            tabs: [
              Tab(
                text: '商品规格',
              ),
              Tab(
                text: '属性风格',
              )
            ],
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
            isScrollable: false,
          ),
          Expanded(
            flex: 1,
            child: TabBarView(controller: _tabController, children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildInfoRow(
                        '货号：${widget.model.skuID}', '品牌：${widget.model.brand}'),
                    _buildInfoRow('品类：${widget.model.category.name}',
                        '面料：${_strArrayResult(enumCodesToNames(widget.model.attributes.fabricCompositions ?? '', FabricCompositionEnum))}'),
                    _buildInfoRow('颜色：${_strArrayResult(colorSet.toList())}',
                        '尺码：${_strArrayResult(sizeSet.toList())}'),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    _buildInfoRow(
                        '重量：${widget.model.gramWeight != null ? widget.model
                            .gramWeight : ''}',
                        '风格：${_strArrayResult(enumCodesToNames(widget.model.attributes.styles ?? [], StyleEnum))}'),
                    _buildInfoRow(
                        '版型：${enumMap(EditionTypeEnum, widget.model.attributes.editionType)}',
                        '款式：${enumMap(PatternEnum, widget.model.attributes.pattern)}'),
                    _buildInfoRow(
                        '袖型：${enumMap(SleeveTypeEnum, widget.model.attributes.sleeveType)}',
                        '袖长/裤腿：${enumMap(SleeveLengthEnum, widget.model.attributes.sleeveLength)}'),
                    _buildInfoRow(
                        '图案：${_strArrayResult(enumCodesToNames(widget.model.attributes.decorativePatterns ?? [], DecorativePatternEnum))}',
                        '流行元素：${_strArrayResult(enumCodesToNames(widget.model.attributes.popularElements ?? [], PopularElementsEnum))}'),
                    _buildInfoRow(
                        '填充物：${enumMap(FillerEnum, widget.model.attributes.filler)}',
                        '厚薄：${enumMap(ThicknessEnum, widget.model.attributes.thickness)}'),
                    _buildInfoRow(
                        '季节：${enumMap(SeasonEnum, widget.model.attributes.season)}',
                        '门襟：${enumMap(PlacketEnum, widget.model.attributes.placket)}'),
                    _buildInfoRow(
                        '吊牌：${widget.model.attributes.taggable == null ? '' : widget.model.attributes.taggable ? '是' : '否'}',
                        ''),
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(String str1, String str2) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Text(
              '$str1',
              overflow: TextOverflow.ellipsis,
            )),
        Container(
          width: 10,
        ),
        Expanded(
            flex: 1,
            child: Text(
              '$str2',
              overflow: TextOverflow.ellipsis,
            )),
      ],
    );
  }

  String _strArrayResult(List<String> strs) {
    String result = '';
    for (int i = 0; i < strs.length; i++) {
      if (i == 0) {
        result = strs[i];
      } else {
        result = '$result/${strs[i]}';
      }
    }
    return result;
  }
}
