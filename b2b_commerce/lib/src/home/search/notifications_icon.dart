import 'package:flutter/material.dart';
import 'package:services/services.dart';

class NotificationsIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 30,
            ),
            color: Colors.white,
            tooltip: '通知',
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => MyClientServicesPage(),
              //   ),
              // );
            },
          ),
          Positioned(
            right: 3,
            top: 3,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(255, 38, 38, 1),
              ),
              child: Center(
                child: StreamBuilder<int>(
                  stream: notificationsPool$.notificationsNumStream,
                  initialData: notificationsPool$.notificationsNum,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    return Text(
                      snapshot.data > 99 ? '...' : '${snapshot.data}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
