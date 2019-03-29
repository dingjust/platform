import 'package:b2b_commerce/src/my/my_factory.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
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
      onTap: () async {
        //获取该工厂的现款商品
        ProductsResponse productsResponse =
            await ProductRepositoryImpl().getProductsOfFactories({
          'factory': model.uid,
        }, {
          'size': 3
        });

        //TODO 工厂跳转
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyFactoryPage(
                  model,
                  isFactoryDetail: true,
                  products: productsResponse.content,
                ),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${model.name}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  _buildButton()
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: <Widget>[
                    model.profilePicture != null
                        ? Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(
                                      '${GlobalConfigs.IMAGE_BASIC_URL}${model.profilePicture.url}'),
                                  fit: BoxFit.fill,
                                )),
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromRGBO(243, 243, 243, 1)),
                            child: Icon(B2BIcons.noPicture,
                                color: Color.fromRGBO(200, 200, 200, 1),
                                size: 60),
                          ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${PopulationScaleLocalizedMap[model.populationScale]}',
                              style: TextStyle(
                                  color: Color.fromRGBO(180, 180, 180, 1)),
                            ),
                            Container(child: Row(children: _buildTags())),
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              // color: Colors.green,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: Stars(
                                      size: 14,
                                      color: Color.fromRGBO(255, 183, 0, 1),
                                      highlightOnly: false,
                                      starLevel: model.starLevel ?? 0,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text: '已接',
                                        style: TextStyle(color: Colors.grey),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text:
                                                  '${model.historyOrdersCount}',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold)),
                                          TextSpan(text: '单')
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: _buildCategoryTags(),
                  )
                ],
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey[300], width: 0.6))),
        ),
      ),
    );
  }

  Widget _buildCategoryTags() {
    //取前3条
    var tags = <Container>[];
    if (model.categories != null) {
      if (model.categories.length > 6) {
        for (int i = 0; i < model.categories.length && i < 6; i++) {
          tags.add(Container(
            margin: EdgeInsets.only(right: 10),
            child: Text(
              '${model.categories[i].name}',
              style: TextStyle(color: Color.fromRGBO(180, 180, 180, 1)),
            ),
          ));
        }
      } else {
        for (int i = 0; i < model.categories.length; i++) {
          tags.add(Container(
            margin: EdgeInsets.only(right: 10),
            child: Text(
              '${model.categories[i].name}',
              style: TextStyle(color: Color.fromRGBO(180, 180, 180, 1)),
            ),
          ));
        }
      }
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
          margin: EdgeInsets.only(left: 20),
          child: FlatButton(
            onPressed: () {},
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '邀请报价',
              style: TextStyle(color: Colors.black, fontSize: 12),
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

  List<Widget> _buildTags() {
    List<Widget> tags = [
      model.approvalStatus == ArticleApprovalStatus.approved
          ? Tag(
              label: '  已认证  ',
              backgroundColor: Color.fromRGBO(254, 252, 235, 1),
            )
          : Tag(
              label: '  未认证  ',
              color: Colors.black,
              backgroundColor: Colors.grey[300],
            )
    ];
    model.labels.forEach((label) {
      tags.add(Tag(
        label: label.name,
        color: Colors.grey,
      ));
    });

    return tags;
  }
}

class Tag extends StatelessWidget {
  const Tag(
      {Key key,
      this.width = 32,
      this.height = 20,
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
      padding: EdgeInsets.fromLTRB(0, 1, 4, 1),
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 14),
        ),
      ),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(2)),
    );
  }
}
