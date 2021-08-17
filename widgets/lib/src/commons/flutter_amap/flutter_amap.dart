import 'package:b2b_commerce/src/home/factory/factory_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong/latlong.dart';
import 'package:latlong2/latlong.dart';
import 'package:models/models.dart';

class FlutterAMap extends StatefulWidget {
    //地图定位纬度
    double locationX;
    //地图定位经度
    double locationY;
    //地图缩放显示大小值
    double locationZoom = 12.0;
    //最大缩放值
    double locationMaxZoom = 16.0;
    //最小缩放值
    double locationMinZoom = 8.0;
    //工厂信息
    List<FactoryModel> factoryList;

    FlutterAMap({
      @required this.locationX,
      @required this.locationY,
      this.locationMinZoom,
      @required this.factoryList,
      this.locationMaxZoom,
      this.locationZoom
    });

    _FlutterAMapState createState() => _FlutterAMapState();
}


class _FlutterAMapState extends State<FlutterAMap>{
  List<Marker> allMarkers = [];
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
            padding:  EdgeInsets.all(10.0),
            child:  Column(
              children: [
                 Flexible(
                  child:  FlutterMap(
                    options:  MapOptions(
                      center:
                      LatLng(widget.locationX, widget.locationY),
                      zoom: 12,
                      maxZoom: 15,
                      minZoom: 8,
                    ),
                    layers: [
                       TileLayerOptions(
                          urlTemplate:
                              "http://webst0{s}.is.autonavi.com/appmaptile?style=7&x={x}&y={y}&z={z}",
                          subdomains: ["1", "2", "3", "4"],
                          additionalOptions: {}
                          ),
                       MarkerLayerOptions(
                           markers:
                             setMarkers()
                       )
                    ],
                  ),
                ),
              ],
        ));
  }

  List<Marker> setMarkers() {
    allMarkers.add(
      Marker(
          width: 60.0,
          height: 60.0,
          //经纬度坐标
          point: LatLng(
              widget.locationX, widget.locationY),
          builder: (ctx) =>
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.location_on,
                  ),
                  color: Colors.lightBlueAccent,
                  iconSize: 40,
                  tooltip: '我的位置',
                  onPressed: () {}, //标记添加动作
                ),
              )
      ),
    );
    if(widget.factoryList != null){
      for(int i = 0; i < widget.factoryList.length; i++){
        allMarkers.add(
          Marker(
              width: 60.0,
              height: 60.0,
              //经纬度坐标
              point: LatLng(
                  widget.factoryList[i].locationX, widget.factoryList[i].locationY),
              builder: (ctx) =>
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.location_on,
                      ),
                      color: Color.fromRGBO(255,214,12, 1),
                      iconSize: 40,
                      tooltip: widget.factoryList[i].name,
                      onPressed: () {
                        onClickMarkers(widget.factoryList[i], i+1);
                        setState(() {
                          allMarkers = allMarkers;
                        });
                      }, //标记添加动作
                    ),
                  )
          ),
        );
      }
    }
    return allMarkers;
  }

  onClickMarkers(FactoryModel model, int index) {
    _showClickedFactory(model);
    print('123');
    allMarkers.clear();
    allMarkers.add(
      Marker(
          width: 60.0,
          height: 60.0,
          //经纬度坐标
          point: LatLng(
              widget.locationX, widget.locationY),
          builder: (ctx) =>
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.location_on,
                  ),
                  color: Colors.lightBlueAccent,
                  iconSize: 40,
                  tooltip: '我的位置',
                  onPressed: () {}, //标记添加动作
                ),
              )
      ),
    );
    if (widget.factoryList != null) {
      for (int i = 0; i < widget.factoryList.length; i++) {
        if(i != index){
          allMarkers.add(
            Marker(
                width: 60.0,
                height: 60.0,
                //经纬度坐标
                point: LatLng(
                    widget.factoryList[i].locationX,
                    widget.factoryList[i].locationY),
                builder: (ctx) =>
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.location_on,
                        ),
                        color: Color.fromRGBO(255,214,12, 1),
                        iconSize: 40,
                        tooltip: widget.factoryList[i].name,
                        onPressed: () {
                          onClickMarkers(widget.factoryList[i], i);
                          setState(() {
                            allMarkers = allMarkers;
                          });
                        }, //标记添加动作
                      ),
                    )
            ),
          );
        }

      }
    }
//    allMarkers.removeAt(index);
    setState(() {
      allMarkers = allMarkers;
    });
    allMarkers.add(
      Marker(
          width: 80.0,
          height: 80.0,
          //经纬度坐标
          point: LatLng(
              model.locationX, model.locationY),
          builder: (ctx) =>
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  iconSize: 60,
                  tooltip: model.name,
                  onPressed: () {

                    onClickMarkers(model, index);
                    setState(() {
                      allMarkers = allMarkers;
                    });
                  }, //标记添加动作
                ),
              )
      ),
    );
  }

  void _showClickedFactory(FactoryModel model) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FactoryItem(
          model:model,
          showButton: false,
        );
      },
    );
  }

}
