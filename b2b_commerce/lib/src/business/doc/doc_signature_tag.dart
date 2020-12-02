import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class DocSignatureTag extends StatelessWidget {
  final DocSignatureModel doc;

  const DocSignatureTag({Key key, this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel user = UserBLoC.instance.currentUser;
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
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Center(
              child: Text(
                '待我签署',
                style: TextStyle(color: Colors.blueAccent, fontSize: 14),
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffe1f5fe), width: 0.5),
              borderRadius: BorderRadius.circular(2),
              color: Color(0xffe1f5fe),
            ))
        : Expanded(
            child: Text(
              '$stateStr',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
            ),
          );
  }
}
