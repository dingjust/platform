import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main() => runApp(new MyMap());

class MyMap extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Map Example',
        theme: new ThemeData(
          primarySwatch: mapBoxBlue,
        ),
        home: Scaffold(
          appBar: new AppBar(title: new Text("Map")),
          body: new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new Column(
              children: [
                new Padding(
                  padding: new EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: new Text("坐标为广东省"),
                ),
                new Flexible(
                  child: new FlutterMap(
                    options: new MapOptions(
                      center: new LatLng(23.07, 113.17),
                      zoom: 1,
                    ),
                    layers: [
                      new TileLayerOptions(
                          urlTemplate:
                              "http://webst0{s}.is.autonavi.com/appmaptile?style=8&x={x}&y={y}&z={z}",
                          subdomains: ["1", "2", "3", "4"],
                          additionalOptions: {}),
                      new MarkerLayerOptions(markers: <Marker>[
                        new Marker(
                            width: 80.0,
                            height: 80.0,
                            //经纬度坐标
                            point: new LatLng(23.07, 113.17),
                            builder: (ctx) => new Container(
                                  child: new IconButton(
                                    icon: Icon(Icons.location_city),
                                    iconSize: 50,
                                    tooltip: 'Increase volume by 10%',
                                    onPressed: () {}, //标记添加动作
                                  ),
                                )),
                      ])
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// Generated using Material Design Palette/Theme Generator
// http://mcg.mbitson.com/
// https://github.com/mbitson/mcg
const int _bluePrimary = 0xFF395afa;
const MaterialColor mapBoxBlue = const MaterialColor(
  _bluePrimary,
  const <int, Color>{
    50: const Color(0xFFE7EBFE),
    100: const Color(0xFFC4CEFE),
    200: const Color(0xFF9CADFD),
    300: const Color(0xFF748CFC),
    400: const Color(0xFF5773FB),
    500: const Color(_bluePrimary),
    600: const Color(0xFF3352F9),
    700: const Color(0xFF2C48F9),
    800: const Color(0xFF243FF8),
    900: const Color(0xFF172EF6),
  },
);
