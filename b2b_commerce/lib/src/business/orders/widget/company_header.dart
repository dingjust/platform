import 'package:b2b_commerce/src/_shared/users/favorite.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/factory/factory_item_v2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';

///头部
class CompanyHeader extends StatelessWidget {
  final B2BUnitModel data;

  const CompanyHeader(this.data);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onDetail(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.white,
        child: Row(
          children: [
            _buildProfile(),
            Expanded(
                child: Container(
              height: 100,
              margin: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        '${data.name}',
                        style: TextStyle(fontSize: 20),
                      ))
                        ],
                      ),
                      Row(
                        children: [
                          AuthTag(
                            model: FactoryModel.fromJson(B2BUnitModel.toJson(
                                data)),
                          ),
                          Expanded(
                              child: Row(
                                children: [
                                  ...(data.labels ?? [])
                                      .map((e) =>
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            2, 1, 2, 2),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 3),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.green,
                                                width: 0.5),
                                            borderRadius: BorderRadius.circular(
                                                2)),
                                        child: Text(
                                          '${e.name}',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.green),
                                        ),
                                      ))
                                      .toList(),
                                ],
                              )),
                          FavoriteIcon(
                            id: data.id,
                          )
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    if (data?.profilePicture == null) {
      return Container(
        width: 80,
        height: 80,
      );
    } else {
      const processUrl = 'image_process=resize,w_80/crop,mid,w_80,h_80';
      return Container(
        width: 80,
        height: 80,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: '${data.profilePicture.imageProcessUrl(processUrl)}',
            fit: BoxFit.fill,
            placeholder: (context, url) => SpinKitRing(
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

  void onDetail(BuildContext context) {
    if (data.type == CompanyType.FACTORY) {
      Navigator.of(context).pushNamed(AppRoutes.ROUTE_FACTORY_INTRODUCTION,
          arguments: {'uid': data.uid});
    }
  }
}
