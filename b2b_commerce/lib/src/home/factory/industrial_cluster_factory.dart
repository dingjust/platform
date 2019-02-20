import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'dart:math';
import 'quick_reaction_factory.dart';

class IndustrialClusterPage extends StatefulWidget {
  IndustrialClusterPageState createState() => IndustrialClusterPageState();
}

class IndustrialClusterPageState extends State<IndustrialClusterPage> {
  List<Widget> _keyItem;
  List<IndustrialClusterFactoryModel> _valueItem = [];
  String _selectLeft;
  Color _color;

  List<String> _tips = [
    '牛仔',
    '羽绒服',
    '风衣',
    '棉服',
    '毛呢大衣',
  ];

  List<IndustrialClusterFactoryModel> _industrialClusters = [
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '牛仔',
      area: '广州新塘',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '牛仔',
      area: '中山大涌',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '牛仔',
      area: '顺德均安',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '牛仔',
      area: '开平三埠',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '牛仔',
      area: '山东淮坊',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '牛仔',
      area: '江苏常州',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '羽绒服',
      area: '广州新塘',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '羽绒服',
      area: '中山大涌',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '羽绒服',
      area: '顺德均安',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '羽绒服',
      area: '开平三埠',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '羽绒服',
      area: '江苏杭州',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '风衣',
      area: '江苏杭州',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '棉服',
      area: '江苏杭州',
    ),
    IndustrialClusterFactoryModel(
      factory: FactoryModel(),
      tip: '毛呢大衣',
      area: '江苏杭州',
    ),
  ];

  Widget createIndustrialClusterItem(IndustrialClusterFactoryModel item) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 15, 5),
        margin: EdgeInsets.all(3),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  item.area,
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,),
                ),
              ),
            ),
            Text(
              Random().nextInt(100).toString() + '家工厂',
              style: TextStyle(color: Color(0xFFFF9516)),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => QuickReactionFactoryPage(industrialClusterArea: item.area,)));
      },
    );
  }

  @override
  void initState() {
    if (_tips != null && _tips.length > 0) _selectLeft = _tips[0];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _keyItem = _tips.map((tip) {
      if (_selectLeft == tip) {
        _color = Color(0xFFFF9516);
      } else {
        _color = Colors.black;
      }
      return GestureDetector(
        onTap: () {
          if (!(_selectLeft == tip)) {
            setState(() {
              _selectLeft = tip;
            });
          }
        },
        child: Container(
//            width: 60,
          color: Colors.white10,
          padding: EdgeInsets.only(
            left: 10,
            top: 10,
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            height: 40,
            child: Text(
              tip,
              style: TextStyle(color: _color),
            ),
          ),
        ),
      );
    }).toList();

    _valueItem = _industrialClusters.where((industrailCluster) => industrailCluster.tip == _selectLeft).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('产业集群'),
      ),
      body: Row(
        children: <Widget>[
          Container(
            width: 80,
            color: Colors.white,
            child: ListView(
              children: _keyItem,
            ),
          ),
          VerticalDivider(width: 0),
          Expanded(
              child: GridView(
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250, childAspectRatio: 2 //宽高比为2
                ),
            children: List.generate(_valueItem.length, (index) {
              return createIndustrialClusterItem(_valueItem[index]);
            }),
          )),
        ],
      ),
    );
  }
}
