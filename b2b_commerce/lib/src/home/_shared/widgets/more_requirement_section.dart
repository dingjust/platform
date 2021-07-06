import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class MoreRequirementSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.grey[50],
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  Provider.of<MajorCategoryState>(context, listen: false)
                      .getMajorCategories()
                      .then((categories) {
                    if (categories != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              RequirementPoolAllPage(categories: categories),
                        ),
                      );
                    }
                  });
                },
                child: Text(
                  '查看更多需求请进入全部需求>>',
                  style: TextStyle(color: Colors.grey),
                ))
          ],
        ),
      ),
    );
  }
}
