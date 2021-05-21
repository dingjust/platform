import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/home/_shared/widgets/distance_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';

class FactoryItem extends StatelessWidget {
  final FactoryModel model;

  ///显示距离
  final bool showDistance;

  const FactoryItem({Key key, this.model, this.showDistance = false})
      : super(key: key);

  static const logoSize = 80.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<CertificationStatusHelper>(context).oncheckProfile(
            context: context, onJump: () => jumpToDetailPage(context));
      },
      child: Container(
          height: 150,
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    height: logoSize,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              '${model.name}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                            ))
                          ],
                        ),
                        Row(
                          children: [Expanded(child: _buildTagsRow())],
                        ),
                        Row(
                          children: [Expanded(child: _buildAttributeRow())],
                        ),
                      ],
                    ),
                  )),
                  _buildImage(context)
                ],
              ),
              Divider(),
              _buildBottomRow()
            ],
          )),
    );
  }

  ///Logo
  Widget _buildImage(BuildContext context) {
    if (model?.profilePicture == null) {
      return Container(
        width: logoSize,
        height: logoSize,
      );
    } else {
      const processUrl = 'image_process=resize,w_80/crop,mid,w_80,h_80';

      return Container(
        width: 80,
        height: 80,
        child: ClipRRect(
          //剪裁为圆角矩形
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: '${model.profilePicture.imageProcessUrl(processUrl)}',
            fit: BoxFit.fill,
            placeholder: (context, url) => SpinKitRing(
              color: Colors.grey[300],
              lineWidth: 2,
              size: 30,
            ),
            errorWidget: (context, url, error) => SpinKitRing(
              color: Colors.grey[300],
              lineWidth: 2,
              size: 30,
            ),
          ),
        ),
      );
    }
  }

  ///标签行
  Widget _buildTagsRow() {
    return Row(
      children: [
        AuthTag(
          model: model,
        ),
        ...model.labels
            .map((e) => Container(
                  padding: EdgeInsets.fromLTRB(2, 1, 2, 2),
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 0.5),
                      borderRadius: BorderRadius.circular(2)),
                  child: Text(
                    '${e.name}',
                    style: TextStyle(fontSize: 10, color: Colors.green),
                  ),
                ))
            .toList()
      ],
    );
  }

  ///属性行
  Widget _buildAttributeRow() {
    List<String> attribute = [];
    //加工方式
    model.cooperationModes?.forEach((mode) {
      attribute.add(CooperationModesLocalizedMap[mode]);
    });
    model.qualityLevels?.forEach((level) {
      attribute.add(FactoryQualityLevelsEnum.firstWhere(
          (element) => element.code == level).name);
    });
    String attributeStr = attribute.join('/');
    return Row(
      children: [
        Expanded(
            child: Text(
          '$attributeStr',
          style: TextStyle(color: Colors.grey, fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ))
      ],
    );
  }

  ///底部行
  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            child: Row(
              children: [
                Icon(
                  Icons.people,
                  size: 15,
                  color: Colors.grey,
                ),
                Text(
                  '${PopulationScaleLocalizedMap[model.populationScale] ?? ''}',
                  style: TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  size: 15,
                  color: Colors.grey,
                ),
                Expanded(
                    child: Text(
                  '${getCategoriesStr()}',
                  style: TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
          ),
        ),
        Icon(
          Icons.location_on_outlined,
          size: 15,
          color: Colors.grey,
        ),
        showDistance
            ? DistanceText(
                val: model.distance,
              )
            : Text(
                getAddressStr(),
                style: TextStyle(color: Colors.grey),
              )
      ],
    );
  }

  void jumpToDetailPage(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.ROUTE_FACTORY_INTRODUCTION,
        arguments: {'uid': model.uid});
  }

  String getCategoriesStr() {
    List<String> strs = [];
    model.adeptAtCategories.forEach((e) {
      if (!strs.contains(e.name)) {
        strs.add(e.name);
      }
    });
    return strs.join(' ');
  }

  String getAddressStr() {
    if (model?.contactAddress?.city != null) {
      return model.contactAddress.city.name;
    } else if (model?.contactAddress?.region != null) {
      return model.contactAddress.region.name;
    }
    return '';
  }
}

class AuthTag extends StatelessWidget {
  final FactoryModel model;

  const AuthTag({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (model.approvalStatus == ArticleApprovalStatus.approved) {
      String type = '';
      if (model.approvalType == 'ENTERPRISE') {
        type = '企业认证';
      } else if (model.approvalType == 'PERSONAL') {
        type = '个人认证';
      }

      return Container(
        margin: EdgeInsets.only(right: 10),
        child: Row(
          children: [
            B2BImage.auth(width: 15, height: 15),
            Text(
              '$type',
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      );
    }
    return Container();
  }
}
