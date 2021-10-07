import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

///合作商辅助类
class CooperatorHelper {
  ///获取合作商名字
  static String getCooperatorName(CooperatorModel target, CompanyModel origin,
      CooperatorModel originCoopertor) {
    //自创单
    if (origin == null && originCoopertor != null) {
      String name = '';
      name = originCoopertor?.type == CooperatorType.ONLINE
          ? originCoopertor?.partner?.name
          : originCoopertor?.name;
      return name;
    }

    //判断是否当前用户公司是否来源
    if (UserBLoC.instance.currentUser.companyCode == origin?.uid) {
      String name = '';
      name = target?.type == CooperatorType.ONLINE
          ? target?.partner?.name
          : target?.name;
      return name;
    } else {
      return origin?.name ?? '';
    }
  }

  ///获取合作商头像
  static ImageProvider getCooperatorImage(
      CooperatorModel target, CompanyModel origin) {
    //判断是否当前用户公司是否来源
    if (UserBLoC.instance.currentUser.companyCode == origin?.uid) {
      if (target?.type == CooperatorType.ONLINE &&
          target?.partner?.profilePicture != null) {
        return NetworkImage(target.partner.profilePicture.thumbnailUrl());
      }
    } else {
      if (origin?.profilePicture != null) {
        return NetworkImage(origin.profilePicture.thumbnailUrl());
      }
    }
    return AssetImage(
      'temp/picture.png',
      package: "assets",
    );
  }

  ///获取合作商Model
  static CompanyModel getCooperator(CompanyModel v1, CompanyModel v2) {
    if (UserBLoC.instance.currentUser.companyCode == v1?.uid) {
      return v2;
    } else if (UserBLoC.instance.currentUser.companyCode == v2?.uid) {
      return v1;
    }
    return null;
  }
}
