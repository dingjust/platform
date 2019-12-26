import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class SubContractMineListItem extends StatelessWidget {
  const SubContractMineListItem({
    Key key,
    @required this.model,
  }) : super(key: key);

  final SubContractModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '转包号：',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    TextSpan(
                      text: '${model?.code}',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    )
                  ]),
                ),
                model.canneled ? Text('已关闭',style: TextStyle(color: Colors.grey,)):
                Text('已发布',style: TextStyle(color: Color(0xffffd60c)),),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: <Widget>[
                Text('发布时间：${DateUtil.formatDate(model?.creationTime,format: 'yyyy-MM-dd HH:mm')}'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                model.details?.pictures != null && model.details.pictures.isNotEmpty ?
                Container(
                    width: 80,
                    height: 80,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      image: DecorationImage(
                          image: NetworkImage('${model.details.pictures[0].actualUrl}'),
                          fit: BoxFit.cover),
                    )
                ) : Container(
                  width: 80,
                  height: 80,
                  decoration: ShapeDecoration(
                    color: Color.fromRGBO(243, 243, 243, 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Icon(
                    B2BIcons.noPicture,
                    color: Color.fromRGBO(200, 200, 200, 1),
                    size: 50,
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${model.details.title}'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text('类型：${enumMap(SubContractTypeEnum, model.details.type)}'),
                            ),
                            Expanded(
                                child: Text('品类：${model.details.category?.name}'),
                            ),
                          ],
                        ),
                      ),
                      Text('数量：${model.details.subContractQuantity ?? 0}件'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
