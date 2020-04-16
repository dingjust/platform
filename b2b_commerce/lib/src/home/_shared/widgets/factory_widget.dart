import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ApprovedTag extends StatelessWidget {
  final FactoryModel model;

  const ApprovedTag({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return model.approvalStatus == ArticleApprovalStatus.approved
        ? Tag(
            label: '  已认证  ',
            color: Colors.white,
            backgroundColor: Colors.red,
          )
        : Container();
  }
}

class FactoryTags extends StatelessWidget {
  final FactoryModel model;

  const FactoryTags({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: model.labels
            .map((label) => Tag(
                  label: label.name,
                  color: Color.fromRGBO(255, 133, 148, 1),
                  // backgroundColor: Constants.THEME_COLOR_MAIN,
                ))
            .toList(),
      ),
    );
  }
}

class Tag extends StatelessWidget {
  const Tag({
    Key key,
    this.width = 30,
    this.height = 18,
    @required this.label,
    this.color = const Color.fromRGBO(255, 133, 148, 1.0),
    this.backgroundColor = const Color.fromRGBO(255, 243, 243, 1),
  }) : super(key: key);

  final double width;
  final double height;
  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.only(right: 5),
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(6)),
    );
  }
}
