import 'package:b2b_commerce/src/home/factory/finding_factory.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';

class MoreFactorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.grey[50],
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FindingFactoryPage(
                        FactoryCondition(
                            starLevel: 0,
                            adeptAtCategories: [],
                            labels: [],
                            cooperationModes: []),
                        route: '全部工厂',
                      ),
                    ),
                  );
                },
                child: Text(
                  '查看更多工厂请进入生产找厂>>',
                  style: TextStyle(color: Colors.grey),
                ))
          ],
        ),
      ),
    );
  }
}
