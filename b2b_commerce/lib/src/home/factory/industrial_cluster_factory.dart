import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'dart:math';

class IndustrialClusterPage extends StatefulWidget {
  List<LabelModel> labels;
  IndustrialClusterPage(this.labels);

  IndustrialClusterPageState createState() => IndustrialClusterPageState();
}

class IndustrialClusterPageState extends State<IndustrialClusterPage> {
  List<Widget> _keyItem;
  List<IndustrialClusterModel> _valueItem = [];
  String _selectLeft;
  Color _color;

//  List<LabelModel> widget.labels = [
//    LabelModel(
//      name:  '牛仔',
//      group: 'FACTORY',
//      clusters: [
//        IndustrialClusterModel(
//          code: 'IC001',
//          name: '广州新塘',
//        ),
//        IndustrialClusterModel(
//          code: 'IC002',
//          name: '中山大涌',
//        ),
//        IndustrialClusterModel(
//          code: 'IC003',
//          name: '顺德均安',
//        ),
//        IndustrialClusterModel(
//          code: 'IC004',
//          name: '开平三埠',
//        ),
//        IndustrialClusterModel(
//          code: 'IC005',
//          name: '山东淮坊',
//        ),
//        IndustrialClusterModel(
//          code: 'IC006',
//          name: '江苏常州',
//        ),
//        IndustrialClusterModel(
//          code: 'IC007',
//          name: '江苏杭州',
//        ),
//      ],
//    ),
//    LabelModel(
//      name:  '羽绒服',
//      group: 'FACTORY',
//      clusters: [
//        IndustrialClusterModel(
//          code: 'IC001',
//          name: '广州新塘',
//        ),
//        IndustrialClusterModel(
//          code: 'IC002',
//          name: '中山大涌',
//        ),
//        IndustrialClusterModel(
//          code: 'IC003',
//          name: '顺德均安',
//        ),
//        IndustrialClusterModel(
//          code: 'IC004',
//          name: '开平三埠',
//        ),
//        IndustrialClusterModel(
//          code: 'IC005',
//          name: '山东淮坊',
//        ),
//      ],
//    ),
//    LabelModel(
//      name:  '风衣',
//      group: 'FACTORY',
//      clusters: [
//        IndustrialClusterModel(
//          code: 'IC001',
//          name: '广州新塘',
//        ),
//        IndustrialClusterModel(
//          code: 'IC002',
//          name: '中山大涌',
//        ),
//        IndustrialClusterModel(
//          code: 'IC005',
//          name: '山东淮坊',
//        ),
//        IndustrialClusterModel(
//          code: 'IC006',
//          name: '江苏常州',
//        ),
//        IndustrialClusterModel(
//          code: 'IC007',
//          name: '江苏杭州',
//        ),
//      ],
//    ),
//    LabelModel(
//      name:  '棉服',
//      group: 'FACTORY',
//      clusters: [
//        IndustrialClusterModel(
//          code: 'IC002',
//          name: '中山大涌',
//        ),
//        IndustrialClusterModel(
//          code: 'IC003',
//          name: '顺德均安',
//        ),
//        IndustrialClusterModel(
//          code: 'IC004',
//          name: '开平三埠',
//        ),
//        IndustrialClusterModel(
//          code: 'IC005',
//          name: '山东淮坊',
//        ),
//        IndustrialClusterModel(
//          code: 'IC006',
//          name: '江苏常州',
//        ),
//        IndustrialClusterModel(
//          code: 'IC007',
//          name: '江苏杭州',
//        ),
//      ],
//    ),
//    LabelModel(
//      name:  '毛呢大衣',
//      group: 'FACTORY',
//      clusters: [
//        IndustrialClusterModel(
//          code: 'IC001',
//          name: '广州新塘',
//        ),
//        IndustrialClusterModel(
//          code: 'IC002',
//          name: '中山大涌',
//        ),
//        IndustrialClusterModel(
//          code: 'IC003',
//          name: '顺德均安',
//        ),
//        IndustrialClusterModel(
//          code: 'IC004',
//          name: '开平三埠',
//        ),
//        IndustrialClusterModel(
//          code: 'IC007',
//          name: '江苏杭州',
//        ),
//      ],
//    ),
//  ];

  @override
  void initState() {
    if (widget.labels.isNotEmpty) {
      _selectLeft = widget.labels[0].name;
      _valueItem = widget.labels[0].clusters;
    }

    // TODO: implement initState
    super.initState();
  }

  Widget createIndustrialClusterItem(IndustrialClusterModel item) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 15, 5),
        margin: EdgeInsets.all(3),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: Text(
                  item.name,
                  style: TextStyle(fontSize: 18,),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => FactoryPage(route: item.name,)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _keyItem = widget.labels.map((label) {
      if (_selectLeft == label.name) {
        _color = Color(0xFFFF9516);
      } else {
        _color = Colors.black;
      }
      return GestureDetector(
        onTap: () {
          if (_selectLeft != label.name) {
            setState(() {
              _selectLeft = label.name;
            });
          }

          _valueItem = label.clusters;
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
              label.name,
              style: TextStyle(color: _color),
            ),
          ),
        ),
      );
    }).toList();

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
