import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

List<FactoryModel> factoryList = [
  FactoryModel.fromJson({
    'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
    'uid': 'BB123456',
    'name': '草帽工厂',
    'starLevel': 5,
    'contactPerson': 'luffy',
    'contactPhone': '13123456789',
    'locationX' : 23.1078388750,
    'locationY' : 113.3064651489,
  }),
  FactoryModel.fromJson({
    'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
    'uid': 'BB123456',
    'name': '草帽工厂',
    'starLevel': 5,
    'email': 'monkey.D.luffy@163.com',
    'contactPerson': 'luffy',
    'contactPhone': '13123456789',
    'locationX' : 23.1037337084,
    'locationY' : 113.2886123657,
  }),
  FactoryModel.fromJson({
    'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
    'uid': 'BB123456',
    'name': '草帽工厂',
    'starLevel': 5,
    'contactPerson': 'luffy',
    'contactPhone': '13123456789',
    'locationX' : 23.1091019780,
    'locationY' : 113.2841491699,
  }),
  FactoryModel.fromJson({
    'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
    'uid': 'BB123456',
    'name': '草帽工厂',
    'starLevel': 5,
    'locationX' : 23.1037337094,
    'locationY' : 113.2886123677,
  }),
];

double locationX = 23.0942597682;
double locationY = 113.2995986938;


class FindFactoryByMap extends StatefulWidget {
  _FindFactoryByMapState createState() => _FindFactoryByMapState();
}

class _FindFactoryByMapState extends State<FindFactoryByMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('地图找厂'),
          actions: <Widget>[
          ],
        ),
        body:Container(
          child: FlutterAMap(locationX: locationX, locationY: locationY, factoryList: factoryList),
        )
    );
  }

}