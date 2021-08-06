import 'package:b2b_commerce/src/_shared/users/favorite.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'image_factory.dart';

class CompanyBar extends StatelessWidget {
  final B2BUnitModel companyModel;

  ///收藏Id，默认收藏公司
  final int favoriteId;

  const CompanyBar({Key key, this.companyModel, this.favoriteId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(right: 8),
              child: ImageFactory.buildProcessedAvatar(
                  companyModel.profilePicture,
                  processurl:
                  'image_process=resize,w_320/crop,mid,w_320,h_320,circle,320')),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                            '${companyModel.name}',
                            style: TextStyle(
                                color: Color(0xff222222),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ))
                    ],
                  ),
                  Row(
                    children: [_authTag()],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: FavoriteIcon(
              id: favoriteId ?? companyModel.id,
            ),
          )
        ],
      ),
    );
  }

  ///认证标签
  Widget _authTag() {
    if (companyModel.approvalStatus == ArticleApprovalStatus.approved) {
      String type = '';
      Image icon;
      if (companyModel.approvalType == 'ENTERPRISE') {
        type = '企业认证';
        icon = B2BV2Image.authCompany(width: 16, height: 16);
      } else {
        type = '个人认证';
        icon = B2BV2Image.authPerson(width: 16, height: 16);
      }
      return Container(
        margin: EdgeInsets.only(right: 10),
        child: Row(
          children: [
            icon,
            Text(
              '$type',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xff077FFA),
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      );
    }
    return Container();
  }
}
