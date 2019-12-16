import 'package:flutter/material.dart';
import 'package:models/models.dart';

///首页需求Tab状态管理
class RequirementTabSectionState with ChangeNotifier {
  List<RequirementOrderModel> _newRequirements;
  List<RequirementOrderModel> _nearbyRequirements;

  ///最新需求
  List<RequirementOrderModel> get newFactories {
    // if (_newRequirements == null) {
    //   getNewRequirements();
    // }
    // return _newRequirements;
    return [
      RequirementOrderModel(
          details: RequirementInfoModel(
              productName: '急需羽绒服加工厂',
              category: CategoryModel(name: '羽绒服'),
              expectedMachiningQuantity: 1000),
          creationTime: DateTime.parse('2019-12-13 13:54:42'),
          belongTo: BrandModel(
              name: '宁波衣加衣供应链管理有限公司',
              contactAddress: AddressModel(
                  region: RegionModel(name: '广东省'),
                  cityDistrict: DistrictModel(name: '天河区'),
                  city: CityModel(name: '广州市')))),
      RequirementOrderModel(
          details: RequirementInfoModel(
              productName: '急需羽绒服加工厂',
              category: CategoryModel(name: '羽绒服'),
              expectedMachiningQuantity: 1000),
          creationTime: DateTime.parse('2019-12-16 16:40:42'),
          belongTo: BrandModel(
              name: '宁波衣加衣供应链管理有限公司',
              contactAddress: AddressModel(
                  region: RegionModel(name: '广东省'),
                  cityDistrict: DistrictModel(name: '天河区'),
                  city: CityModel(name: '广州市')))),
      RequirementOrderModel(
          details: RequirementInfoModel(
              productName: '急需羽绒服加工厂',
              category: CategoryModel(name: '羽绒服'),
              expectedMachiningQuantity: 1000),
          creationTime: DateTime.parse('2019-12-16 12:40:42'),
          belongTo: BrandModel(
              name: '宁波衣加衣供应链管理有限公司',
              contactAddress: AddressModel(
                  region: RegionModel(name: '广东省'),
                  cityDistrict: DistrictModel(name: '天河区'),
                  city: CityModel(name: '广州市')))),
      RequirementOrderModel(
          details: RequirementInfoModel(
              productName: '急需羽绒服加工厂',
              category: CategoryModel(name: '羽绒服'),
              expectedMachiningQuantity: 1000),
          creationTime: DateTime.parse('2019-10-16 12:40:42'),
          belongTo: BrandModel(
              name: '宁波衣加衣供应链管理有限公司',
              contactAddress: AddressModel(
                  region: RegionModel(name: '广东省'),
                  cityDistrict: DistrictModel(name: '天河区'),
                  city: CityModel(name: '广州市'))))
    ];
  }

  ///附近需求
  List<RequirementOrderModel> get hotFactories {
    if (_nearbyRequirements == null) {
      getNearbyRequirements();
    }
    return _nearbyRequirements;
  }

  void getNewRequirements() {
    // try {
    //   http$.post(Apis.factories, data: {}, queryParameters: {
    //     'page': 0,
    //     'size': 5,
    //     'sort': 'creationtime,desc'
    //   }).then((response) {
    //     if (response != null && response.statusCode == 200) {
    //       FactoriesResponse factoriesResponse =
    //           FactoriesResponse.fromJson(response.data);
    //       _newRequirements = factoriesResponse.content;

    //       ///通知刷新
    //       notifyListeners();
    //     }
    //   });
    // } on DioError catch (e) {
    //   print(e);
    // }
  }

  void getNearbyRequirements() {
    // try {
    //   http$.post(Apis.factories, data: {}, queryParameters: {
    //     'page': 0,
    //     'size': 5,
    //   }).then((response) {
    //     if (response != null && response.statusCode == 200) {
    //       FactoriesResponse factoriesResponse =
    //           FactoriesResponse.fromJson(response.data);
    //       _nearbyRequirements = factoriesResponse.content;

    //       ///通知刷新
    //       notifyListeners();
    //     }
    //   });
    // } on DioError catch (e) {
    //   print(e);
    // }
  }
}
