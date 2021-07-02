import 'package:b2b_commerce/src/helper/app_version.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/helper/clipboard_helper.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

///全局 Provider
class AppProvider {
  static List<SingleChildCloneableWidget> providers =
      <SingleChildCloneableWidget>[
    ChangeNotifierProvider(create: (_) => MyCapacityState()),
    ChangeNotifierProvider(create: (_) => ProductionProgressState()),
    ChangeNotifierProvider(create: (_) => AmapState()),
    ChangeNotifierProvider(create: (_) => NetState.instance),
    ChangeNotifierProvider(create: (_) => ProductHomeState()),
    ChangeNotifierProvider(create: (_) => ProductHomeCarouselsState()),
    ChangeNotifierProvider(create: (_) => RecommendProductState()),
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
    Provider(
      create: (_) => ClipboardHelper(),
    )
  ];

  ///预加载
  static preloading(BuildContext context) async {
    DateTime start = DateTime.now();
    print('[nbyjy]预加载开始${DateFormatUtil.formatYMDHMS(start)}');
    Provider.of<RecommendProductState>(context).products;
    // Provider.of<HomeSectionState>(context).getData();
    await Provider.of<CategoryState>(context).getCascadedCategories();
    await Provider.of<AddressState>(context).getRegions();
    await Provider.of<MajorCategoryState>(context).getMajorCategories();
    await Provider.of<CarrierState>(context).getCarriers();
    await Provider.of<LabelState>(context).getLabels();
    await Provider.of<ColorState>(context).getAllColors();
    await Provider.of<SizeState>(context).getAllSizes();
    Provider.of<ProductHomeCarouselsState>(context).getBannerData();

    AppVersionHelper appVersionHelper = Provider.of<AppVersionHelper>(context);
    await appVersionHelper.getAppVersionInfo('nbyjy');
    DateTime end = DateTime.now();
    print('[nbyjy]预加载结束${DateFormatUtil.formatYMDHMS(end)}');
    print(
        '[nbyjy]相差${end.difference(start).inSeconds}秒(${end.difference(start).inMilliseconds})');
  }

  ///清理用户相关数据(非系统数据)
  static clearUserData(BuildContext context) {
    Provider.of<MyCapacityState>(context).clear();
    Provider.of<ProductionProgressState>(context).clear();
    Provider.of<B2BCustomersState>(context).clear();
    Provider.of<B2BDeptState>(context).clear();
  }
}
