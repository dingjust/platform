import 'package:b2b_commerce/src/helper/app_version.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/helper/local_storage_helper.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:services/services.dart';

///全局 Provider
class AppProvider {
  static List<SingleChildWidget> providers = <SingleChildWidget>[
    ChangeNotifierProvider(create: (_) => MyCapacityState()),
    ChangeNotifierProvider(create: (_) => ProductionProgressState()),
    ChangeNotifierProvider(create: (_) => AmapState()),
    ChangeNotifierProvider(create: (_) => NetState.instance),
    ChangeNotifierProvider(create: (_) => ProductHomeState()),
    ChangeNotifierProvider(create: (_) => ProductHomeCarouselsState()),
    ChangeNotifierProvider(create: (_) => RecommendProductState()),
    ChangeNotifierProvider(create: (_) => BusinessReportState()),
    ChangeNotifierProvider(create: (_) => MyFavoriteState()),
    ChangeNotifierProvider(create: (_) => NotificationState()),
    // ChangeNotifierProvider(create: (_) => HomeSectionState()),
    Provider(
      create: (_) => AddressState(),
    ),
    Provider(
      create: (_) => CategoryState(),
    ),
    Provider(
      create: (_) => MajorCategoryState(),
    ),
    Provider(
      create: (_) => CarrierState(),
    ),
    Provider(
      create: (_) => CertificationStatusHelper(),
    ),
    Provider(
      create: (_) => AppVersionHelper(),
    ),
    Provider(
      create: (_) => LabelState(),
    ),
    Provider(
      create: (_) => ColorState(),
    ),
    Provider(
      create: (_) => SizeState(),
    ),
    Provider(
      create: (_) => B2BCustomersState(),
    ),
    Provider(
      create: (_) => B2BDeptState(),
    ),
    // Provider(
    //   create: (_) => ClipboardHelper(),
    // ),
    Provider(create: (_) => LocalStorageHelper())
  ];

  ///预加载
  static preloading(BuildContext context) async {
    DateTime start = DateTime.now();
    print('[nbyjy]预加载开始${DateFormatUtil.formatYMDHMS(start)}');
    Provider.of<RecommendProductState>(context, listen: false).products;
    // Provider.of<HomeSectionState>(context, listen: false).getData();
    Provider.of<CategoryState>(context, listen: false).getCascadedCategories();
    Provider.of<AddressState>(context, listen: false).getRegions();
    Provider.of<CarrierState>(context, listen: false).getCarriers();
    //TODO:需要Token
    // Provider.of<LabelState>(context, listen: false).getLabels();
    // Provider.of<MajorCategoryState>(context, listen: false)
    // .getMajorCategories();
    Provider.of<ColorState>(context, listen: false).getAllColors();
    Provider.of<SizeState>(context, listen: false).getAllSizes();
    Provider.of<ProductHomeCarouselsState>(context, listen: false)
        .getBannerData();
    Provider.of<AppVersionHelper>(context, listen: false)
        .getAppVersionInfo('nbyjy');

    DateTime end = DateTime.now();
    print('[nbyjy]预加载结束${DateFormatUtil.formatYMDHMS(end)}');
    print(
        '[nbyjy]相差${end.difference(start).inSeconds}秒(${end.difference(start).inMilliseconds})');
  }

  ///清理用户相关数据(非系统数据)
  static clearUserData(BuildContext context) {
    Provider.of<MyCapacityState>(context, listen: false).clear();
    Provider.of<ProductionProgressState>(context, listen: false).clear();
    Provider.of<B2BCustomersState>(context, listen: false).clear();
    Provider.of<B2BDeptState>(context, listen: false).clear();
  }
}
