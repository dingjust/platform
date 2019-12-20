import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/my/address/amap_search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class LocationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AmapState>(
        builder: (context, state, _) =>
            GestureDetector(
              onTap: () async {
                Tip tip = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AmapSearchPage()));
                List<String> locationArray = tip.location.split(',');
                //设置定位信息
                state.setAMapLocation(
                    aOIName: tip.district,
                    longitude: double.parse(locationArray[0]),
                    latitude: double.parse(locationArray[1]));
              },
              child: Container(
                padding: EdgeInsets.only(left: 5),
                child: Row(
                  children: <Widget>[
                    _buildLocatingText(context, state),
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.location_on,
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  Widget _buildLocatingText(BuildContext context, AmapState state) {
    Widget _dialog = CustomizeDialog(
      dialogType: DialogType.CONFIRM_DIALOG,
      contentText2: '钉单正在请求定位权限,请设置',
      isNeedConfirmButton: true,
      isNeedCancelButton: true,
      confirmButtonText: '去设置',
      cancelButtonText: '忽略',
      dialogHeight: 180,
      confirmAction: () {
        state.openAppSetting().then((val) {
          Navigator.of(context).pop(val);
        });
      },
    );

    AMapLocation aMapLocation =
    state.getAMapLocation(context: context, openDialog: _dialog);
    if (aMapLocation == null) {
      return Container(
          width: 60,
          child: Center(
              child: Text(
            '无法定位',
            style: TextStyle(fontSize: 12, color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          )));
    } else {
      return Container(
          width: 60,
          child: Center(
              child: Text(
                '${state.city}',
            style: TextStyle(fontSize: 12, color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          )));
    }
  }
}
