import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductConditionPage extends StatefulWidget {
  final ProductCondition productCondition;

  final String factoryUid;

  ProductConditionPage({
    Key key,
    this.productCondition,
    this.factoryUid,
  }) : super(key: key);

  @override
  _ProductConditionPageState createState() => _ProductConditionPageState();
}

class _ProductConditionPageState extends State<ProductConditionPage> {
  PopulationScale populationScale;

  TextEditingController minTextController = TextEditingController();
  TextEditingController maxTextController = TextEditingController();

  List<_PriceRange> _priceRanges = [
    _PriceRange(0, 50),
    _PriceRange(51, 100),
    _PriceRange(101, 150),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.productCondition.minSteppedPrice != null) {
      minTextController.text =
          widget.productCondition.minSteppedPrice.toString();
    }
    if (widget.productCondition.maxSteppedPrice != null) {
      maxTextController.text =
          widget.productCondition.maxSteppedPrice.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, widget.productCondition);
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
                  _buildLabel('风格'),
                  _buildStyleBlock(),
                  _buildLabel('价格段'),
                  _buildPriceRangeBlock(),
                  _buildRangeInput()
                ],
              )),
          persistentFooterButtons: <Widget>[
            Container(
              height: 40,
              margin: EdgeInsets.only(right: 10),
              child: Center(
                child: FlatButton(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 45),
                    color: Colors.grey,
                    child: const Text(
                      '重置',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    onPressed: () {
                      setState(() {
                        setState(() {});
                        widget.productCondition.styles = [];
                        widget.productCondition.minSteppedPrice = null;
                        widget.productCondition.maxSteppedPrice = null;
                        minTextController.text = '';
                        maxTextController.text = '';

                        ///条件更新数据
                        if (widget.factoryUid == null) {
                          OrderByProductBLoc.instance
                              .getData(widget.productCondition);
                        } else {
                          OrderByProductBLoc.instance
                              .getCashProducts(widget.factoryUid);
                        }
                        Navigator.pop(context, widget.productCondition);
                      });
                    }),
              ),
            ),
            Container(
                height: 40,
                margin: EdgeInsets.only(right: 10),
                child: Center(
                  child: FlatButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 45),
                      color: Color(0xFFFFD600),
                      child: const Text(
                        '确定',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      onPressed: () {
                        ///条件更新数据
                        if (widget.factoryUid == null) {
                          OrderByProductBLoc.instance
                              .getData(widget.productCondition);
                        } else {
                          OrderByProductBLoc.instance
                              .getCashProducts(widget.factoryUid);
                        }
                        Navigator.pop(context, widget.productCondition);
                      }),
                )),
          ],
        ));
  }

  Widget _buildPriceRangeBlock() {
    return _Selector(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建子widget
          return Container(
              decoration: BoxDecoration(
                  color: widget.productCondition.minSteppedPrice ==
                              _priceRanges[index].minPrice &&
                          widget.productCondition.maxSteppedPrice ==
                              _priceRanges[index].maxPrice
                      ? Color.fromRGBO(255, 214, 12, 1)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                child: Center(
                  child: Text(
                    '${_priceRanges[index].minPrice.toStringAsFixed(0)}-${_priceRanges[index].maxPrice.toStringAsFixed(0)}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                onTap: () {
                  setState(() {
                    widget.productCondition.minSteppedPrice =
                        _priceRanges[index].minPrice;
                    widget.productCondition.maxSteppedPrice =
                        _priceRanges[index].maxPrice;
                  });
                },
              ));
        },
        childCount: _priceRanges?.length ?? 0,
      ),
    );
  }

  Widget _buildRangeInput() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300], width: 1),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                controller: minTextController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  DecimalInputFormat(),
                ],
                decoration:
                    InputDecoration(hintText: '最低价', border: InputBorder.none),
                textAlign: TextAlign.center,
                onChanged: (val) {
                  widget.productCondition.minSteppedPrice =
                      double.tryParse(val);
                },
              ),
            ),
            Container(
              width: 30,
              height: 1,
              color: Colors.grey[300],
            ),
            Expanded(
              flex: 1,
              child: TextField(
                controller: maxTextController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  DecimalInputFormat(),
                ],
                decoration:
                    InputDecoration(hintText: '最高价', border: InputBorder.none),
                textAlign: TextAlign.center,
                onChanged: (val) {
                  widget.productCondition.maxSteppedPrice =
                      double.tryParse(val);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleBlock() {
    return _Selector(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建子widget
          return Container(
              decoration: BoxDecoration(
                  color: widget.productCondition.styles != null &&
                          widget.productCondition.styles
                              .contains(StyleEnum[index].code)
                      ? Color.fromRGBO(255, 214, 12, 1)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20)),
              child: InkWell(
                child: Center(
                  child: Text(
                    '${StyleEnum[index].name}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (widget.productCondition.styles != null &&
                        widget.productCondition.styles
                            .contains(StyleEnum[index].code)) {
                      widget.productCondition.styles
                          .remove(StyleEnum[index].code);
                    } else {
                      if (widget.productCondition.styles == null) {
                        widget.productCondition.styles = [];
                      }
                      widget.productCondition.styles.add(StyleEnum[index].code);
                    }
                  });
                },
              ));
        },
        childCount: StyleEnum?.length ?? 0,
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

class _Selector extends StatelessWidget {
  final SliverChildDelegate delegate;

  const _Selector({Key key, this.delegate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(10),
      sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, //Grid按两列显示
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 3.0,
          ),
          delegate: delegate),
    );
  }
}

class _PriceRange {
  final double minPrice;

  final double maxPrice;

  _PriceRange(this.minPrice, this.maxPrice);
}
