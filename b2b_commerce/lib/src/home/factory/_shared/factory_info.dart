import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'factory_widgets.dart';

class FactoryInfo extends StatelessWidget {
  final FactoryModel model;

  const FactoryInfo({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          _Basic(model),
          FactoryDivider(),
          _Scale(model),
          FactoryDivider(),
          _Ability(model),
          FactoryDivider(),
          _Pictures(model),
          _Certificates(model)
        ],
      ),
    );
  }
}

///基础信息
class _Basic extends StatelessWidget {
  final FactoryModel model;

  const _Basic(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          FactoryTitle('基础信息'),
          Divider(),
          FactoryInfoRow(label: '联系人', val: model.contactPerson),
          FactoryInfoRow(label: '经营地址', val: model?.contactAddress?.details),
          FactoryInfoRow(
            label: '注册时间',
            val: '${DateFormatUtil.formatYMD(model.creationTime)}',
          )
        ],
      ),
    );
  }
}

///规模
class _Scale extends StatelessWidget {
  final FactoryModel model;

  const _Scale(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          FactoryTitle('工厂规模'),
          Divider(),
          FactoryInfoRow(
              label: '人数',
              val: PopulationScaleLocalizedMap[model.populationScale]),
          FactoryInfoRow(
              label: '月均产能',
              val: MonthlyCapacityRangesLocalizedMap[
                  model?.monthlyCapacityRange]),
          FactoryInfoRow(
              label: '厂房',
              val:
                  '${model.factoryBuildingsQuantity == null ? '0' : model.factoryBuildingsQuantity.toString()}㎡'),
          FactoryInfoRow(
              label: '产值', val: ScaleRangesLocalizedMap[model.scaleRange]),
          FactoryInfoRow(
              label: '生产模式',
              val: enumMap(ProductionModesEnum, model.productionMode)),
          FactoryInfoRow(label: '设备', val: getEquipmentStr())
        ],
      ),
    );
  }

  ///设备
  String getEquipmentStr() {
    List<String> strs = [];
    strs
      ..addAll((model?.cuttingDepartment ?? [])
          .map((e) => enumMap(CuttingDepartmentsEnum, e)))
      ..addAll((model?.productionWorkshop ?? [])
          .map((e) => enumMap(ProductionWorkshopsEnum, e)))
      ..addAll((model?.lastDepartment ?? [])
          .map((e) => enumMap(LastDepartmentsEnum, e)));
    return strs.join(',');
  }
}

///工厂能力
class _Ability extends StatelessWidget {
  final FactoryModel model;

  const _Ability(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          FactoryTitle('工厂能力'),
          Divider(),
          FactoryInfoRow(
              label: '设计', val: enumMap(FactoryDesignsEnum, model.design)),
          FactoryInfoRow(
              label: '打版', val: enumMap(FactoryPatternsEnum, model.pattern)),
          FactoryInfoRow(label: '覆盖范围', val: model.coverageArea),
          FactoryInfoRow(label: '合作品牌', val: model.cooperativeBrand),
          FactoryInfoRow(
              label: '质量等级',
              val: (model.qualityLevels ?? [])
                  .map((e) => enumMap(FactoryQualityLevelsEnum, e))
                  .join(',')),
          FactoryInfoRow(
              label: '生产大类',
              val: (model?.categories ?? []).map((e) => e.name).join(',')),
          FactoryInfoRow(label: '擅长品类', val: getAdeptCategoriesStr()),
        ],
      ),
    );
  }

  ///擅长品类
  String getAdeptCategoriesStr() {
    if (model.adeptAtCategories == null) return '';
    // if (model.adeptAtCategories.length > 5) {
    //   return model.adeptAtCategories
    //       .getRange(0, 5)
    //       .map((e) => e.name)
    //       .join(',');
    // } else {
    return model.adeptAtCategories.map((e) => e.name).join(',');
    // }
  }
}

///工厂照片
class _Pictures extends StatelessWidget {
  final FactoryModel model;

  const _Pictures(this.model);

  @override
  Widget build(BuildContext context) {
    List<MediaModel> medias = [
      model.gatePhoto,
      model.cuttingTablePhoto,
      model.sewingWorkshopPhoto,
      model.backEndPhoto
    ];
    medias = medias.where((element) => element != null).toList();
    return Container(
      // margin: EdgeInsets.only(bottom: 65),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          FactoryTitle('工厂照片'),
          Divider(),
          medias.isNotEmpty
              ? Attachments(
                  list: medias,
                )
              : Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('暂无照片'),
          )
        ],
      ),
    );
  }
}

///工厂资质荣誉
class _Certificates extends StatelessWidget {
  final FactoryModel model;

  const _Certificates(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 65),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          FactoryTitle('工厂资质荣誉'),
          Divider(),
          getPictures().isNotEmpty
              ? Attachments(
            list: model.certificates,
            watermark: true,
          )
              : Container(
            margin: EdgeInsets.only(top: 10),
            child: Text('暂无照片'),
          )
        ],
      ),
    );
  }

  List<MediaModel> getPictures() {
    if (model.certificates == null) {
      return [];
    } else {
      return model.certificates;
    }
  }
}
