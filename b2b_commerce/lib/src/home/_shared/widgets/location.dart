import 'package:amap_location/amap_location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class LocationIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AmapState>(
      builder: (context, state, _) => Container(
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
    );
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

    AMapLocation aMapLocation = state.getAMapLocation(context, _dialog);
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
            '${aMapLocation.AOIName != null ? aMapLocation.AOIName : ''}',
            style: TextStyle(fontSize: 12, color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          )));
    }
  }
}
