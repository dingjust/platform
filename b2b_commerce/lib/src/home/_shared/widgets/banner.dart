import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:b2b_commerce/src/helper/uri_helper.dart';
import 'package:b2b_commerce/src/home/factory/finding_factory.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 首页Banner
class HomeBrandBannerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Carousel(<CarouselItem>[
      CarouselItem(
          model: MediaModel(
            url: '${GlobalConfigs.CDN_OSS_DOMAIN}/%E5%9B%BE%E7%89%87.png',
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.ROUTE_MY_HELP);
          }),
      CarouselItem(
          model: MediaModel(
            url:
                '${GlobalConfigs.CDN_OSS_DOMAIN}/%E5%93%81%E7%89%8C%E8%BD%AE%E6%92%AD%E5%9B%BE2.png',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FindingFactoryPage(),
              ),
            );
          }),
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
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.ROUTE_MY_HELP);
          }),
      CarouselItem(
          model: MediaModel(
            url:
                '${GlobalConfigs.CDN_OSS_DOMAIN}/%E5%B7%A5%E5%8E%82%E8%BD%AE%E6%92%AD%E5%9B%BE2.png',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FindingFactoryPage(),
              ),
            );
          }),
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

class HomeBannerSection extends StatelessWidget {
  final ValueChanged<List<Color>> onChanged;

  final double height;

  const HomeBannerSection({Key key, this.onChanged,this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductHomeCarouselsState>(
        builder: (context, ProductHomeCarouselsState state, _) {
      // //若为空采用静态图
      if (state.bannerCarousels == null || state.bannerCarousels.isEmpty) {
        return Container();
      } else {
        return CarouselV2(
            state.bannerCarousels
                .where((carousel) => carousel.media != null)
                .map((carousel) => CarouselItem(
                    model: MediaModel(url: carousel.media.actualUrl),
                    onTap: () {
                      onTap(context, carousel.url);
                    }))
                .toList(),
            60,
            onChanged: (index) => onMediaChanged(index, state.bannerCarousels));
      }
        });
  }

  void onTap(BuildContext context, String url) {
    bool result =
    UriHelper().handleUri(context: context, uri: url, isReplace: false);
    if (!result) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WebviewPage(
                    url: url,
                    needRedirectContractList: false,
                  )));
    }
  }

  void onMediaChanged(int index, List<CarouselModel> list) {
    int i = index % list.length;
    CarouselModel carousel = list[i];
    //数据有色值的情况
    if (carousel.colorValue1 != null && carousel.colorValue1 != '') {
      onChanged?.call([
        Color(int.parse(carousel.colorValue1)),
        Color(int.parse(carousel.colorValue2))
      ]);
    }
    // else {
    //   //无色值采用图片主体色
    //   getColorFromUrl(carousel.media.actualUrl).then((value) {
    //     if (value != null) {
    //       onChanged?.call([
    //         Color.fromRGBO(value[0], value[1], value[2], 1),
    //         Color.fromRGBO(value[0], value[1], value[2], 0)
    //       ]);
    //     }
    //   });
    // }
  }
}
