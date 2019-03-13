import 'package:b2b_commerce/src/business/supplier/suppliers_detail.dart';
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuppliersDetail(
                  supplierModel: SupplierModel(
                    factory: model,
                  ),
                  isSupplier: false,
                ),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          // margin: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
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
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
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
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 5),
                        // color: Colors.green,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Stars(
                              size: 14,
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
                      ),
                      Container(
                        child: Text(
                          model.describe,
                          overflow: TextOverflow.ellipsis,
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
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
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
      ),
    );
  }

  Widget _buildCategoryTags() {
    //取前3条
    var tags = <CategoryTag>[];
    if(model.categories.length > 3){
      for (int i = 0; i < model.categories.length && i < 3; i++) {
        tags.add(CategoryTag(label: model.categories[i].name));
      }
    }else{
      for (int i = 0; i < model.categories.length; i++) {
        tags.add(CategoryTag(label: model.categories[i].name));
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
          child: FlatButton(
            onPressed: () {},
            color: Color.fromRGBO(255,214,12, 1),
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
      padding: EdgeInsets.fromLTRB(2, 1, 2, 1),
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
