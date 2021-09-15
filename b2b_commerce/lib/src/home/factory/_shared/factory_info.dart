import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_group_sliver/flutter_group_sliver.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'package:b2b_commerce/src/_shared/widgets/info_widgets.dart';

class FactoryInfo extends StatelessWidget {
  final FactoryModel model;

  const FactoryInfo({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        // padding: EdgeInsets.zero,
        slivers: [
          _Basic(model),
          _Scale(model),
          _Ability(model),
          PicturesTitle(val: '工厂照片'),
          _Pictures(model),
          PicturesTitle(val: '工厂资质荣誉'),
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
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        margin: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            InfoTitle('基础信息'),
            InfoRow(label: '联系人', val: model.contactPerson),
            InfoDivider(),
            InfoRow(label: '经营地址', val: model?.contactAddress?.details),
            InfoDivider(),
            InfoRow(
              label: '注册时间',
              val: '${DateFormatUtil.formatYMD(model.creationTime)}',
            )
          ],
        ),
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
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            InfoTitle('工厂规模'),
            InfoRow(
                label: '人数',
                val: PopulationScaleLocalizedMap[model.populationScale]),
            InfoDivider(),
            InfoRow(
                label: '月均产能',
                val: MonthlyCapacityRangesLocalizedMap[
                    model?.monthlyCapacityRange]),
            InfoDivider(),
            InfoRow(
                label: '厂房',
                val:
                    '${model.factoryBuildingsQuantity == null ? '0' : model.factoryBuildingsQuantity.toString()}㎡'),
            InfoDivider(),
            InfoRow(
                label: '产值', val: ScaleRangesLocalizedMap[model.scaleRange]),
            InfoDivider(),
            InfoRow(
                label: '生产模式',
                val: enumMap(ProductionModesEnum, model.productionMode)),
            InfoDivider(),
            InfoRow(label: '设备', val: getEquipmentStr())
          ],
        ),
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
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            InfoTitle('工厂能力'),
            InfoRow(
                label: '设计', val: enumMap(FactoryDesignsEnum, model.design)),
            InfoDivider(),
            InfoRow(
                label: '打版', val: enumMap(FactoryPatternsEnum, model.pattern)),
            InfoDivider(),
            InfoRow(label: '覆盖范围', val: model.coverageArea),
            InfoDivider(),
            InfoRow(label: '合作品牌', val: model.cooperativeBrand),
            InfoDivider(),
            InfoRow(
                label: '质量等级',
                val: (model.qualityLevels ?? [])
                    .map((e) => enumMap(FactoryQualityLevelsEnum, e))
                    .join(',')),
            InfoDivider(),
            InfoRow(
                label: '生产大类',
                val: (model?.categories ?? []).map((e) => e.name).join(',')),
            InfoDivider(),
            InfoRow(label: '擅长品类', val: getAdeptCategoriesStr()),
          ],
        ),
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

class PicturesTitle extends StatelessWidget {
  final String val;

  const PicturesTitle({Key key, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGroupBuilder(
        padding: EdgeInsets.fromLTRB(12, 14, 12, 0),
        margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        child: SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: InfoTitle('$val'),
          ),
        ));
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

    return SliverGroupBuilder(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        margin: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12))),
        child: SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            sliver: medias.length > 0
                ? ImageSliverGrid(medias: medias)
                : SliverToBoxAdapter(
              child: Center(child: Text('暂无照片')),
            )));
  }
}

///工厂资质荣誉
class _Certificates extends StatelessWidget {
  final FactoryModel model;

  const _Certificates(this.model);

  @override
  Widget build(BuildContext context) {
    return SliverGroupBuilder(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        margin: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12))),
        child: SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            sliver: model.certificates.length > 0
                ? ImageSliverGrid(medias: model.certificates)
                : SliverToBoxAdapter(
              child: Center(child: Text('暂无照片')),
            )));
  }

  List<MediaModel> getPictures() {
    if (model.certificates == null) {
      return [];
    } else {
      return model.certificates;
    }
  }
}
