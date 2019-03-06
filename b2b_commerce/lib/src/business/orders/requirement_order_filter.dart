import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class RequirementOrderFilterPage extends StatefulWidget {
  Map<String, Object> params;

  RequirementOrderFilterPage(this.params);

  RequirementOrderFilterPageState createState() =>
      RequirementOrderFilterPageState();
}

class RequirementOrderFilterPageState
    extends State<RequirementOrderFilterPage> {
  List<EnumModel> _productiveOrientationsSelected;
  FocusNode _startQuantityFocusNode = FocusNode();
  TextEditingController _startQuantityController = TextEditingController();
  FocusNode _endQuantityFocusNode = FocusNode();
  TextEditingController _endQuantityController = TextEditingController();
  FocusNode _startPriceFocusNode = FocusNode();
  TextEditingController _startPriceController = TextEditingController();
  FocusNode _endPriceFocusNode = FocusNode();
  TextEditingController _endPriceController = TextEditingController();

  @override
  void initState() {
    _productiveOrientationsSelected =
        widget.params['productiveOrientations'] ?? [];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('筛选条件'),
        centerTitle: true,
        elevation: 0.5,
      ),
//      resizeToAvoidBottomPadding: false,

    persistentFooterButtons: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width-40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ActionChip(
              shape:
              StadiumBorder(side: BorderSide(color: Color(0xffFF9516))),
              labelPadding: EdgeInsets.symmetric(horizontal: 20),
              backgroundColor: Colors.white,
              label: Text('重置'),
              labelStyle: TextStyle(color: Colors.grey),
              onPressed: () {},
            ),
            ActionChip(
              labelPadding:
              EdgeInsets.symmetric(horizontal: 21, vertical: 1),
              backgroundColor: Color(0xffFF9516),
              label: Text('确定'),
              labelStyle: TextStyle(color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ],
      body: ListView(
        children: <Widget>[
          Center(
            child: Text(
              '--送货地区--',
              style: TextStyle(color: Colors.grey),
            ),
            heightFactor: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ActionChip(
                shape: StadiumBorder(
                    side: BorderSide(color: Color(0xffFF9516))),
                labelPadding: EdgeInsets.symmetric(horizontal: 20),
                backgroundColor: Colors.white,
                label: Text('选择省份'),
                labelStyle: TextStyle(color: Color(0xffFF9516)),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: MediaQuery.of(context).size.height / 2.4,
                        child: EnumSelection(
                          enumModels: ProvinceEnum,
                          multiple: true,
                          enumSelect: _productiveOrientationsSelected,
                          hasButton: true,
                        ),
                      );
                    },
                  ).then((val) {
                    setState(() {
                      widget.params['productiveOrientations'] =
                          _productiveOrientationsSelected == []
                              ? null
                              : _productiveOrientationsSelected
                                  .map((select) => select.code)
                                  .toList();
                    });
                  });
                },
              ),
              Text(formatEnumSelectsText(
                  widget.params['productiveOrientations'],
                  ProvinceEnum,
                  3)),
            ],
          ),
          Center(
            child: Text(
              ' --交货日期--',
              style: TextStyle(color: Colors.grey),
            ),
            heightFactor: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ActionChip(
                shape: StadiumBorder(
                    side: BorderSide(color: Color(0xffFF9516))),
                labelPadding: EdgeInsets.symmetric(horizontal: 40),
                backgroundColor: Colors.white,
                label: Text('日期'),
                labelStyle: TextStyle(color: Color(0xffFF9516)),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: widget.params['startDate'] == null
                        ? DateTime.now()
                        : widget.params['startDate'],
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101),
                  ).then((value) {
                    setState(() {
                      widget.params['startDate'] = value;
                    });
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text('~'),
              ),
              ActionChip(
                shape: StadiumBorder(
                    side: BorderSide(color: Color(0xffFF9516))),
                labelPadding: EdgeInsets.symmetric(horizontal: 40),
                backgroundColor: Colors.white,
                label: Text('日期'),
                labelStyle: TextStyle(color: Color(0xffFF9516)),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: widget.params['endDate'] == null
                        ? DateTime.now()
                        : widget.params['endDate'],
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101),
                  ).then((value) {
                    setState(() {
                      widget.params['endDate'] = value;
                    });
                  });
                },
              ),
            ],
          ),
          Center(
            child: Text(
              '--加工数量--',
              style: TextStyle(color: Colors.grey),
            ),
            heightFactor: 2,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextFieldComponent(
                    focusNode: _startQuantityFocusNode,
                    controller: _startQuantityController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Text('~'),
                ),
                Flexible(
                  child: TextFieldComponent(
                    focusNode: _endQuantityFocusNode,
                    controller: _endQuantityController,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              '--期望价格--',
              style: TextStyle(color: Colors.grey),
            ),
            heightFactor: 2,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextFieldComponent(
                    focusNode: _startPriceFocusNode,
                    controller: _startPriceController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Text('~'),
                ),
                Flexible(
                  child: TextFieldComponent(
                    focusNode: _endPriceFocusNode,
                    controller: _endPriceController,
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
