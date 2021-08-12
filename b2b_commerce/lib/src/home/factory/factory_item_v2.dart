import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/home/_shared/widgets/distance_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:widgets/widgets.dart';

class FactoryItem extends StatelessWidget {
  final FactoryModel model;

  ///显示距离
  final bool showDistance;

  const FactoryItem({Key key, this.model, this.showDistance = false})
      : super(key: key);

  static const logoSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<CertificationStatusHelper>(context, listen: false)
            .oncheckProfile(
                context: context, onJump: () => jumpToDetailPage(context));
      },
      child: Container(
          // height: 150,
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRow1(context),
              _buildRow2(context),
              _buildRow3(context),
              _buildLocationRow(context)
            ],
          )),
    );
  }

  Widget _buildRow1(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildImage(context),
        Expanded(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    '${model.name}',
                    style: TextStyle(
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              ),
              Container(height: 4),
              Row(
                children: [Expanded(child: _buildTagsRow())],
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildRow2(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 2),
      child: Row(
        children: [
          Expanded(
              child: Text(
            '工厂规模：${PopulationScaleLocalizedMap[model.populationScale] ?? ''}',
            style: TextStyle(
                color: Color(0xff666666),
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ))
        ],
      ),
    );
  }

  Widget _buildRow3(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
              child: Text(
            '主打款式：${getCategoriesStr()}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Color(0xff666666),
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ))
        ],
      ),
    );
  }

  Widget _buildLocationRow(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 4),
            child: Icon(
              B2BIconsV2.location,
              color: Color(0xff999999),
              size: 12,
            ),
          ),
          Expanded(
              child: Text(
            getAddressStr(),
            style: TextStyle(
                color: Color(0xff999999),
                fontSize: 10,
                fontWeight: FontWeight.w500),
          )),
          showDistance
              ? DistanceText(
                  val: model.distance,
                )
              : Container()
        ],
      ),
    );
  }

  ///Logo
  Widget _buildImage(BuildContext context) {
    if (model?.profilePicture == null) {
      return Container(
        width: logoSize,
        height: logoSize,
        margin: EdgeInsets.only(right: 3),
      );
    } else {
      const processUrl = 'image_process=resize,w_80/crop,mid,w_80,h_80';

      return Container(
        width: logoSize,
        height: logoSize,
        margin: EdgeInsets.only(right: 3),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: '${model.profilePicture.imageProcessUrl(processUrl)}',
            fit: BoxFit.fill,
            placeholder: (context, url) =>
                SpinKitRing(
                  color: Colors.grey[300],
                  lineWidth: 2,
                  size: 30,
                ),
            errorWidget: (context, url, error) =>
                SpinKitRing(
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
    List<String> tags = [];
    if (model.approvalStatus == ArticleApprovalStatus.approved) {
      tags.add('认证工厂');
    }
    tags.addAll((model.labels ?? []).map((e) => e.name));

    return Row(
        children: tags
            .map((e) =>
            Container(
              padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                  color: _tagColorMap[e] ?? Color(0xffe8f5e9),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                '$e',
                style: TextStyle(
                    fontSize: 10,
                    color: _tagTextColorMap[e] ?? Color(0xff4caf50),
                    fontWeight: FontWeight.w500),
              ),
            ))
            .toList());
  }

  void jumpToDetailPage(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.ROUTE_FACTORY_INTRODUCTION,
        arguments: {'uid': model.uid});
  }

  String getCategoriesStr() {
    List<String> strs = [];
    (model.adeptAtCategories ?? []).forEach((e) {
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

const _tagColorMap = {
  '快反工厂': Color(0xffFFF5D7),
  '认证工厂': Color(0xFFE8F8FA),
  '免费打样': Color(0xffFFEDED),
};

const _tagTextColorMap = {
  '快反工厂': Color(0xffAA6E15),
  '认证工厂': Color(0xFF00BBD3),
  '免费打样': Color(0xffFF4D4F)
};
