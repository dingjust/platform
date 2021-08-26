import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import 'package:b2b_commerce/src/business/doc/doc_signature_tag.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/doc_signature_helper.dart';
import 'package:b2b_commerce/src/common/app_image.dart';

///对账单
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
        margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: <Widget>[
            _Row1(model: model),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 16),
              child: Divider(
                color: Color(0xFFE7E7E7),
                height: 1,
              ),
            ),
            _Title(model.title),
            _Amount(100.0),
            Container(
              margin: EdgeInsets.only(top: 16, bottom: 14),
              child: Divider(
                color: Color(0xFFE7E7E7),
                height: 1,
              ),
            ),
            _Row2(model: model),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onTap: () async {
        Navigator.of(context)
            .pushNamed(AppRoutes.ROUTE_RECONCILIATION_ORDER_DETAIL, arguments: {
          'id': model.id,
        }).then((needRefresh) {
          if (needRefresh != null && needRefresh) {
            Provider.of<ReconciliationOrdersState>(context, listen: false)
                .clear();
          }
        });
      },
    );
  }
}

class _Title extends StatelessWidget {
  final String val;

  const _Title(this.val, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Text('$val',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Color(0xFFAA6E15),
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

class _Row1 extends StatelessWidget {
  final FastReconciliationSheetModel model;

  const _Row1({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          margin: EdgeInsets.only(right: 8),
          child: CircleAvatar(
            backgroundImage: getImage(),
            radius: 24,
          ),
        ),
        Expanded(
            child: Text(
              '${getCoopertorName()}',
              style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF222222),
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            )),
        Text(
          '${FastReconciliationSheetStateLocalizedMap[model.state]}',
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF222222),
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  String getCoopertorName() {
    String name = '';

    if (getPartner() != null) {
      name = getPartner().name;
    }

    return name;
  }

  ImageProvider getImage() {
    CompanyModel partner = getPartner();

    if (partner != null && partner.profilePicture != null) {
      String processUrl = 'image_process=resize,w_60/crop,mid,w_60,h_60';

      return NetworkImage(partner?.profilePicture?.imageProcessUrl(processUrl));
    } else {
      return AssetImage(
        'temp/picture.png',
        package: "assets",
      );
    }
  }

  //获取合作商
  CompanyModel getPartner() {
    String code = UserBLoC.instance.currentUser.companyCode;
    if (model.shipParty != null) {
      if (model.shipParty.uid == code) {
        return model.receiveParty;
      } else {
        return model.shipParty;
      }
    }

    if (model.receiveParty != null) {
      if (model.receiveParty.uid == code) {
        return model.shipParty;
      } else {
        return model.receiveParty;
      }
    }
    return null;
  }
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
            child: Row(
              children: [
                Text(
                  '${model.code}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                _Status(
                  model: model,
                )
              ],
            )),
        Text(
          '${DateFormatUtil.formatYMD(model.creationtime)}',
          style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
        )
      ],
    );
  }
}

class _Status extends StatelessWidget {
  final FastReconciliationSheetModel model;

  const _Status({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DocSignatureModel doc = getLast();
    UserModel user = UserBLoC.instance.currentUser;
    if (doc != null) {
      //待我签署
      bool needToSign = false;
      String stateStr = '${DocSignatureStateLocalizedMap[doc.state]}';
      if (doc.state == DocSignatureState.WAIT_PARTYA_SIGN) {
        if (user.companyCode == doc.partyA.uid) {
          needToSign = true;
        } else {
          stateStr = '待对方签署';
        }
      } else if (doc.state == DocSignatureState.WAIT_PARTYB_SIGN) {
        if (user.companyCode == doc.partyB.uid) {
          needToSign = true;
        } else {
          stateStr = '待对方签署';
        }
      }

      return needToSign
          ? Container(
        margin: EdgeInsets.only(left: 14),
        padding: EdgeInsets.fromLTRB(6, 2, 6, 4),
        decoration: BoxDecoration(
            color: Color(0xFFFF4D4F),
            borderRadius: BorderRadius.circular(12)),
        child: Text(
          '待我签署',
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
      )
          : Container(
        margin: EdgeInsets.only(left: 14),
        padding: EdgeInsets.fromLTRB(6, 2, 6, 4),
        decoration: BoxDecoration(
            color: Color(0xFFFFEDED),
            borderRadius: BorderRadius.circular(12)),
        child: Text(
          '$stateStr',
          style: TextStyle(color: Color(0xFFFF4D4F), fontSize: 10),
        ),
      );
    }

    return Container();
  }

  Widget _buildBtn(
    DocSignatureModel doc,
  ) {
    return Expanded(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                DocSignatureHelper.getDocTypeIcon(signMethod: doc.signMethod),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [DocSignatureTag(doc: doc)],
                        ),
                      ],
                    ))
              ],
            )));
  }

  ///获取最新状态
  DocSignatureModel getLast() {
    List<DocSignatureModel> datas = model.docSignatures ?? [];
    return datas.lastWhere(
            (element) => element.state != DocSignatureState.CANCELED,
        orElse: () => null);
  }
}

class _Amount extends StatelessWidget {
  final double val;

  const _Amount(this.val, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Row(
        children: [
          B2BV2Image.money(width: 18, height: 18),
          Container(
            margin: EdgeInsets.only(left: 4, right: 8),
            child: Text('结算金额'),
          ),
          RichText(
              text: TextSpan(
                  text: '￥',
                  style: TextStyle(
                      fontSize: 10,
                      color: Color(0xffFF4D4F),
                      fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: '${val.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14))
                  ]))
        ],
      ),
    );
  }
}
