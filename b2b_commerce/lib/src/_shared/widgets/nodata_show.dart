import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class NoDataShow extends StatelessWidget {
  const NoDataShow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<NetState>(
              builder: (context, NetState state, _) => Container(
                child: state.connectivityResult == ConnectivityResult.none
                    ? Container(
                        child: Column(
                          children: <Widget>[
                            Icon(
                              B2BIcons.noNet,
                              color: Colors.grey,
                              size: 50,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Text('当前无网络，请检查网络!'),
                            )
                          ],
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          ],
        ));
  }
}
