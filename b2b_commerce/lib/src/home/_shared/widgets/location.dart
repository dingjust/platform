import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/my/address/amap_search_page.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class LocationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AmapState>(
        builder: (context, state, _) => GestureDetector(
              onTap: () async {
                Tip tip = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AmapSearchPage()));
                List<String> locationArray = tip.location.split(',');
                //设置定位信息
                state.setAMapLocation(
                    longitude: double.parse(locationArray[0]),
                    latitude: double.parse(locationArray[1]));
              },
              child: Container(
                padding: EdgeInsets.only(left: 5),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 4),
                      child: B2BV2Image.top_1(width: 18, height: 22),
                    ),
                    _buildLocatingText(context, state),
                  ],
                ),
              ),
            ));
  }

  Widget _buildLocatingText(BuildContext context, AmapState state) {
    // Widget _dialog = CustomizeDialog(
    //   dialogType: DialogType.CONFIRM_DIALOG,
    //   contentText2: '钉单正在请求定位权限,请设置',
    //   isNeedConfirmButton: true,
    //   isNeedCancelButton: true,
    //   confirmButtonText: '去设置',
    //   cancelButtonText: '选择城市',
    //   dialogHeight: 180,
    //   confirmAction: () {
    //     state.openAppSetting().then((val) {
    //       Navigator.of(context).pop(val);
    //     });
    //   },
    //   cancelAction: () async {
    //     Navigator.of(context).pop();
    //     Tip tip = await Navigator.of(context)
    //         .push(MaterialPageRoute(builder: (context) => AmapSearchPage()));
    //     List<String> locationArray = tip.location.split(',');
    //     //设置定位信息
    //     state.setAMapLocation(
    //       // aOIName: tip.district.,
    //         longitude: double.parse(locationArray[0]),
    //         latitude: double.parse(locationArray[1]));
    //   },
    // );

    AMapLocation aMapLocation = state.getAMapLocation(
      context: context,
    );
    if (aMapLocation == null) {
      return Container(
          child: Text(
        '选择城市',
        style: TextStyle(fontSize: 13, color: Colors.black54),
        overflow: TextOverflow.ellipsis,
      ));
    } else {
      return Container(
          child: Text(
        '${state.city}·${state.district}',
        style: TextStyle(
            fontSize: 13,
            color: Constants.FONT_COLOR_1,
            fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis,
      ));
    }
  }
}
