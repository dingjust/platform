import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

import 'package:core/core.dart';
import 'package:models/models.dart';

/// 首页Banner
class HomeBrandBannerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Carousel(<CarouselItem>[
      CarouselItem(
        model: MediaModel(
          url: '${GlobalConfigs.CDN_OSS_DOMAIN}/%E5%9B%BE%E7%89%87.png',
        ),
      ),
      CarouselItem(
        model: MediaModel(
          url:
              '${GlobalConfigs.CDN_OSS_DOMAIN}/%E5%93%81%E7%89%8C%E8%BD%AE%E6%92%AD%E5%9B%BE2.png',
        ),
      ),
      CarouselItem(
          model: MediaModel(
            url:
                '${GlobalConfigs.CDN_OSS_DOMAIN}/activity/invite_activity_banner1.jpg',
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.ROUTE_ACTIVITY_INVITE);
          })
    ], 240);
  }
}

class HomeFactoryBannerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Carousel(<CarouselItem>[
      CarouselItem(
        model: MediaModel(
          url: '${GlobalConfigs.CDN_OSS_DOMAIN}/%E5%9B%BE%E7%89%87.png',
        ),
      ),
      CarouselItem(
          model: MediaModel(
        url:
            '${GlobalConfigs.CDN_OSS_DOMAIN}/%E5%B7%A5%E5%8E%82%E8%BD%AE%E6%92%AD%E5%9B%BE2.png',
      )),
      CarouselItem(
          model: MediaModel(
            url:
                '${GlobalConfigs.CDN_OSS_DOMAIN}/activity/invite_activity_banner1.jpg',
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.ROUTE_ACTIVITY_INVITE);
          })
    ], 240);
  }
}
