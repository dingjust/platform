import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import './factory_list.dart';

class IndustrialClusterPage extends StatefulWidget {
  IndustrialClusterPage({Key key, this.labels}) : super(key: key);

  final List<LabelModel> labels;

  _IndustrialClusterPageState createState() => _IndustrialClusterPageState();
}

class _IndustrialClusterPageState extends State<IndustrialClusterPage> {
  List<Widget> _keyItem;
  List<IndustrialClusterModel> _valueItem = [];
  String _selectedLabel;
  Color _highlightColorWhenSelected;

  @override
  void initState() {
    if (widget.labels.isNotEmpty) {
      _selectedLabel = widget.labels[0].name;
      _valueItem = widget.labels[0].clusters;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _keyItem = widget.labels.map((label) {
      _highlightColorWhenSelected = Colors.black;
      if (_selectedLabel == label.name) {
        _highlightColorWhenSelected = Color(0xFFFF9516);
      }

      return GestureDetector(
        onTap: () {
          if (_selectedLabel != label.name) {
            setState(() {
              _selectedLabel = label.name;
            });
          }

          _valueItem = label.clusters;
        },
        child: Container(
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
              style: TextStyle(color: _highlightColorWhenSelected),
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
                maxCrossAxisExtent: 250,
                childAspectRatio: 2,
              ),
              children: List.generate(_valueItem.length, (index) {
                return IndustrialClusterItem(item: _valueItem[index]);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class IndustrialClusterItem extends StatelessWidget {
  const IndustrialClusterItem({Key key, this.item}) : super(key: key);

  final IndustrialClusterModel item;

  void _onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FactoryPage(
              FactoryCondition(
                starLevel: 0,
                adeptAtCategory: [],
                industrialCuster: item,
              ),
              route: item.name,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Text(
              '${item.companiesCount ?? 0} 家工厂',
              style: TextStyle(color: Color(0xFFFF9516)),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () => _onTap(context),
    );
  }
}
