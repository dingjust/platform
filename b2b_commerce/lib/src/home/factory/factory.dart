import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class FactoryItem extends StatelessWidget {
  const FactoryItem(
      {Key key,
      @required this.model,
      this.showButton = false,
      this.hasInvited = false})
      : super(key: key);

  final FactoryModel model;

  ///是否显示按钮
  final bool showButton;

  ///是否已经邀请
  final bool hasInvited;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //TODO 工厂跳转
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => ));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(model.profilePicture),
                    fit: BoxFit.cover,
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        '${model.name}',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Stars(
                          size: 15,
                          color: Color.fromRGBO(255, 183, 0, 1),
                          highlightOnly: false,
                          starLevel: model.starLevel,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: _buildCategoryTags(),
                        )
                      ],
                    ),
                    Container(
                      child: Text(
                        model.describe,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                              text: '历史接单',
                              style: TextStyle(color: Colors.grey),
                              children: <TextSpan>[
                                TextSpan(
                                    text: '${model.historyOrdersCount}',
                                    style: TextStyle(color: Colors.red)),
                                TextSpan(text: '单')
                              ]),
                        ),
                        _buildButton()
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Colors.grey[300], width: 0.6))),
      ),
    );
  }

  Widget _buildCategoryTags() {
    //取前3条
    var tags = <CategoryTag>[];
    for (int i = 0; i < model.categories.length && i < 3; i++) {
      tags.add(CategoryTag(label: model.categories[i].name));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: tags,
    );
  }

  Widget _buildButton() {
    if (showButton) {
      if (hasInvited) {
        return Container(
          height: 23,
          width: 80,
          child: Center(
            child: Text(
              '已邀请',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        );
      } else {
        return Container(
          height: 23,
          width: 80,
          child: FlatButton(
            onPressed: () {},
            color: Colors.orange,
            child: Text(
              '邀请报价',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      }
    } else {
      return Container();
    }
  }
}

class CategoryTag extends StatelessWidget {
  const CategoryTag(
      {Key key,
      this.width = 32,
      this.height = 18,
      @required this.label,
      this.color = const Color.fromRGBO(244, 143, 177, 1.0),
      this.backgroundColor = const Color.fromRGBO(248, 187, 208, 0.3)})
      : super(key: key);

  final double width;
  final double height;
  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(2)),
    );
  }
}
