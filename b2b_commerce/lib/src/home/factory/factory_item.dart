import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../_shared/widgets/image_factory.dart';
import '../../my/my_factory.dart';

class FactoryItem extends StatelessWidget {
  const FactoryItem({
    Key key,
    @required this.model,
    this.requirementCode,
    this.showButton = false,
    this.hasInvited = false,
    this.isLocalFind = false,
  }) : super(key: key);

  final FactoryModel model;

  final String requirementCode;

  ///是否显示按钮
  final bool showButton;

  ///是否已经邀请
  final bool hasInvited;

  //是否就近找厂路由过来的页面
  final bool isLocalFind;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyFactoryPage(
                  model,
                  isFactoryDetail: true,
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
                  FactoryNameText(model: model,isLocalFind: isLocalFind,),
                  showButton
                      ? InviteFactoryButton(
                          factoryModel: model,
                          requirementCode: requirementCode,
                        )
                      : Container(),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: <Widget>[
                    ImageFactory.buildThumbnailImage(model.profilePicture),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            PopulationScaleText(model: model),
                            CertifiedTagsAndLabelsText(model: model),
                            StarLevelAndOrdersCountText(model: model),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     CategoriesText(
              //       model: model,
              //     )
              //   ],
              // )
              CategoriesText(
                model: model,
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey[300], width: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}

class FactoryNameText extends StatelessWidget {
  FactoryNameText({Key key, @required this.model,this.isLocalFind = false}) : super(key: key);

  final FactoryModel model;

  final bool isLocalFind;

  @override
  Widget build(BuildContext context) {
    if(isLocalFind){
      return Expanded(
        flex: 1,
        child: Row(
          children: <Widget>[
        model.distance == null ?
            Container():
        Expanded(
            child:
            Text(
                '${model.name}', style: TextStyle(fontSize: 18))
        ),
        Text(
            '${(model.distance.toInt() / 1000).toStringAsFixed(1)}' + 'km',
            style: TextStyle(
                fontSize: 18,
                color: Colors.red
            )
        ),
          ],
        ),
      );
    }else {
      return Expanded(
        flex: 1,
        child: Text(
            '${model.name}', style: TextStyle(fontSize: 18)),
      );
    }
  }
}

class PopulationScaleText extends StatelessWidget {
  PopulationScaleText({Key key, @required this.model}) : super(key: key);

  final FactoryModel model;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${PopulationScaleLocalizedMap[model.populationScale] ?? ''}',
      style: TextStyle(
        color: Color.fromRGBO(180, 180, 180, 1),
      ),
    );
  }
}

class CertifiedTagsAndLabelsText extends StatelessWidget {
  CertifiedTagsAndLabelsText({Key key, @required this.model}) : super(key: key);

  final FactoryModel model;

  bool _isApproved() {
    return model.approvalStatus == ArticleApprovalStatus.approved;
  }

  List<Widget> _buildTags() {
    List<Widget> tags = [
      _isApproved()
          ? Tag(
              label: '  已认证  ',
              color: Colors.black,
              backgroundColor: Color.fromRGBO(255, 214, 12, 1),
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
        color: Color.fromRGBO(255, 133, 148, 1),
      ));
    });

    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: _buildTags(),
      ),
    );
  }
}

class StarLevelAndOrdersCountText extends StatelessWidget {
  StarLevelAndOrdersCountText({Key key, @required this.model})
      : super(key: key);

  final FactoryModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    text: '${model.historyOrdersCount}',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '单')
                ]),
          ),
        ],
      ),
    );
  }
}

class CategoriesText extends StatelessWidget {
  CategoriesText({Key key, @required this.model}) : super(key: key);

  final FactoryModel model;

  Widget _buildTag(int i) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: Text(
        '${model.adeptAtCategories[i].name}',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14, color: Color.fromRGBO(180, 180, 180, 1)),
      ),
    );
  }

  Widget _buildTags() {
    // 取前3条
    List<Container> tags = <Container>[];
    if (model.adeptAtCategories != null) {
      // TODO: 用更好的方法实现：先截取，再生成
      if (model.adeptAtCategories.length > 4) {
        for (int i = 0; i < model.adeptAtCategories.length && i < 4; i++) {
          tags.add(_buildTag(i));
        }
      } else {
        for (int i = 0; i < model.adeptAtCategories.length; i++) {
          tags.add(_buildTag(i));
        }
      }
    }

    return
        // Expanded(
        //   flex: 1,
        //   child: ListView(
        //     scrollDirection: Axis.horizontal,
        //     children: tags,
        //   ),
        // );

        Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: tags,
    );

    //     Container(
    //   width: 300,
    //   child: ListView(
    //     scrollDirection: Axis.horizontal,
    //     children: tags,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTags();
  }
}

class InviteFactoryButton extends StatelessWidget {
  InviteFactoryButton({Key key, this.factoryModel, this.requirementCode})
      : super(key: key);
  FactoryModel factoryModel;
  String requirementCode;

  @override
  Widget build(BuildContext context) {
    if (factoryModel.invited) {
      return Container(
        height: 30,
        width: 100,
        child: Center(
          child: Text(
            '已邀请',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(5)),
      );
    } else {
      return Container(
        height: 30,
        width: 100,
        child: FlatButton(
          onPressed: () async {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return RequestDataLoading(
                    requestCallBack: RequirementOrderRepository()
                        .doRecommendation(requirementCode, factoryModel.uid),
                    outsideDismiss: false,
                    loadingText: '邀请中。。。',
                    entrance: '0',
                  );
                }
            );
            FactoryBLoC().clear();
            FactoryBLoC().refreshData();
          },
          color: Color.fromRGBO(255, 214, 12, 1),
          child: Text(
            '邀请报价',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      );
    }
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
      margin: EdgeInsets.symmetric(horizontal: 5),
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
