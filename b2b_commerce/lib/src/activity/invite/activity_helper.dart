import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:widgets/widgets.dart';

///活动弹窗
class ActivityHelper {
  bool notShow;

  // 工厂模式
  factory ActivityHelper() => _getInstance();

  static ActivityHelper get instance => _getInstance();
  static ActivityHelper _instance;

  ActivityHelper._internal() {
    notShow = true;
  }

  static ActivityHelper _getInstance() {
    if (_instance == null) {
      _instance = ActivityHelper._internal();
    }
    return _instance;
  }

  void showActivity(BuildContext context,
      {double height = 350, double width = 300, double btnSize = 30}) {
    if (notShow) {
      notShow = false;
      BotToast.showCustomText(
          onlyOne: false,
          duration: null,
          clickClose: true,
          crossPage: true,
          backgroundColor: Colors.black38,
          align: Alignment.center,
          toastBuilder: (cancelFunc) => GestureDetector(
                onTap: () {
                  cancelFunc.call();
                  Navigator.of(context)
                      .pushNamed(AppRoutes.ROUTE_ACTIVITY_INVITE);
                },
                child: Container(
                    height: height + btnSize,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: height,
                          width: width,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://cdn-oss.nbyjy.net/activity/invite_activity.jpg',
                            fit: BoxFit.scaleDown,
                            placeholder: (context, url) => SpinKitRing(
                              color: Color(0xFFfa981b),
                              lineWidth: 2,
                              size: 1,
                            ),
                            errorWidget: (context, url, error) => SpinKitRing(
                              color: Color(0xFFfa981b),
                              lineWidth: 2,
                              size: 1,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            cancelFunc.call();
                          },
                          child: Icon(
                            B2BIcons.close,
                            color: Colors.white,
                            size: btnSize,
                          ),
                        ),
                      ],
                    )),
              ));
    }
  }
}
