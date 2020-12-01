import 'package:b2b_commerce/src/_shared/widgets/order_status_color.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///发货单块
class ReconciliationOrderItem extends StatelessWidget {
  final FastReconciliationSheetModel model;

  const ReconciliationOrderItem(
    this.model, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: <Widget>[
            _Header(
              model: model,
            ),
            _Row1(model: model),
            _MediasRow(
              model: model,
            ),
            _Row2(model: model),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onTap: () async {
        Navigator.of(context)
            .pushNamed(AppRoutes.ROUTE_RECONCILIATION_ORDER_DETAIL, arguments: {
          'id': model.id,
        }).then((needRefresh) {
          if (needRefresh != null && needRefresh) {
            Provider.of<ReconciliationOrdersState>(context).clear();
          }
        });
      },
    );
  }
}

class _Header extends StatelessWidget {
  final FastReconciliationSheetModel model;

  const _Header({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(
            '标题：${model.title}',
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // _buildTag(),
        Container(
          child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${FastReconciliationSheetStateLocalizedMap[model.state]}',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 18,
                  color: getReconciliationOrderStateColor(model.state),
                  fontWeight: FontWeight.w500,
                ),
              )),
        ),
      ],
    );
  }

// Widget _buildTag() {
//   //自创外接订单无originCompany
//   return model.originCompany == null
//       ? Container(
//           padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(2),
//               border: Border.all(color: Constants.THEME_COLOR_MAIN)),
//           child: Center(
//             child: Text(
//               '自创',
//               style:
//                   TextStyle(color: Constants.THEME_COLOR_MAIN, fontSize: 10),
//             ),
//           ),
//         )
//       : Container(
//           padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(2),
//               border: Border.all(color: Color.fromRGBO(68, 138, 255, 1))),
//           child: Center(
//             child: Text(
//               '线上',
//               style: TextStyle(
//                   color: Color.fromRGBO(68, 138, 255, 1), fontSize: 10),
//             ),
//           ),
//         );
// }
}

class _Row1 extends StatelessWidget {
  final FastReconciliationSheetModel model;

  const _Row1({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.only(right: 5),
          child: CircleAvatar(
            backgroundImage: getImage(),
            radius: 20,
          ),
        ),
        Expanded(
            child: Text(
          '${getCoopertorName()}',
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        )),
        // _buildTag()
      ],
    );
  }

  String getCoopertorName() {
    String name = '';

    name = model?.cooperator?.type == CooperatorType.ONLINE
        ? model?.cooperator?.partner?.name
        : model?.cooperator?.name;

    return name;
  }

  ImageProvider getImage() {
    if (model.cooperator?.partner != null &&
        model.cooperator.partner.profilePicture != null) {
      return NetworkImage(
          model.cooperator?.partner?.profilePicture?.thumbnailUrl());
    } else {
      return AssetImage(
        'temp/picture.png',
        package: "assets",
      );
    }
  }

// Widget _buildTag() {
//   bool isDone = model.agreements != null
//       ? model.agreements
//           .any((element) => element.state == ContractStatus.COMPLETE)
//       : false;

//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 5),
//     child: Center(
//       child: Text(
//         isDone ? '已签合同' : '未签合同',
//         style: TextStyle(
//             color: isDone ? Color.fromRGBO(103, 194, 58, 1) : Colors.black54,
//             fontSize: 10),
//       ),
//     ),
//     decoration: BoxDecoration(
//         border: Border.all(
//             color:
//                 isDone ? Color.fromRGBO(225, 243, 216, 1) : Colors.grey[200],
//             width: 0.5),
//         color: isDone ? Color.fromRGBO(240, 249, 235, 1) : Colors.grey[200]),
//   );
// }
}

class _Row2 extends StatelessWidget {
  final FastReconciliationSheetModel model;

  const _Row2({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '单号：${model.code}',
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '${DateFormatUtil.formatYMD(model.creationtime)}',
          style: TextStyle(fontSize: 14),
        )
      ],
    );
  }
}

class _MediasRow extends StatelessWidget {
  final FastReconciliationSheetModel model;

  const _MediasRow({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('单据：'),
        for (DocSignatureModel doc in model.docSignatures ?? [])
          _buildBtn(context, doc)
      ],
    );
  }

  Widget _buildBtn(BuildContext context, DocSignatureModel model,
      {double height = 60, double width = 100}) {
    return Expanded(
        child: Container(
            // height: height,
            // width: width,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.ce,
              children: [
                Icon(
                  B2BIcons.agreement,
                  color: Color(0xffffca3a),
                  size: 40,
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${model.title ?? '空标题'}',
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${DocSignatureStateLocalizedMap[model.state]}',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ],
                ))
              ],
            )));
  }
}
