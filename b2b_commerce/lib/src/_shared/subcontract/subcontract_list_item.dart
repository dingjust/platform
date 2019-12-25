import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class SubContractListItem extends StatelessWidget {
  const SubContractListItem({
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
                Text('${model?.details?.title}'),
                Text('${DateUtil.formatDate(model?.creationTime,format: 'yyyy-MM-dd')}'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('数量：${model.details.subContractQuantity ?? 0}件'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: <Widget>[
                model.belongTo?.profilePicture != null ?
                Container(
                    width: 20,
                    height: 20,
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                      image: DecorationImage(
                          image: NetworkImage('${model.belongTo.profilePicture.actualUrl}'),
                          fit: BoxFit.cover),
                    )
                ) : Container(
                  width: 20,
                  height: 20,
                  decoration: ShapeDecoration(
                    color: Color.fromRGBO(243, 243, 243, 1),
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    B2BIcons.noPicture,
                    color: Color.fromRGBO(200, 200, 200, 1),
                    size: 40,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text('${model.belongTo?.name}'),
                  ),
                ),
                Text('${model.belongTo?.contactAddress?.city?.name}${model.belongTo?.contactAddress?.cityDistrict?.name}'),
              ],
            ),
          ),
        ],

      ),
    );
  }
}
