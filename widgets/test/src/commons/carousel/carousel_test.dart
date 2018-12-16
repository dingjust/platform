import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

void main() => runApp(MyApp());

const URL = 'https://raw.githubusercontent.com/flutter/website/master/src/_includes/code/layout/lakes/images/lake.jpg';

class MyApp extends StatelessWidget {
  final List<MediaModel> items = <MediaModel>[
    MediaModel(URL),
    MediaModel(URL),
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '轮播图',
      home: Carousel(items, 240.00),
    );
  }
}
