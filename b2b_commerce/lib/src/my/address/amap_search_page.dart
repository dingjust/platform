import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:city_pickers/city_pickers.dart' as city_pickers;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 产品搜索页
class AmapSearchDelegatePage extends SearchDelegate<Tip> {
  String city;

  AmapSearchDelegatePage({this.city});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query != ''
          ? IconButton(
              icon: Icon(
                B2BIcons.del_blank_card,
                size: 15,
              ),
              onPressed: () {
                query = '';
              },
            )
          : Container(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  // @override
  void showResults(BuildContext context) {
    super.showResults(context);
    //记录搜索关键字
    // if (query != '' && query.isNotEmpty) {
    //   if (history_keywords.contains(query)) {
    //     history_keywords.remove(query);
    //   }
    //   history_keywords.add(query);
    //   LocalStorage.save(GlobalConfigs.PRODUCT_HISTORY_KEYWORD_KEY,
    //       json.encode(history_keywords));
    // }
    // Navigator.pop(context,ApparelProductModel(name: query));
  }

  @override
  void showSuggestions(BuildContext context) {
    super.showSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(child: _buildSuggestionsListView(context));
  }

  /// 提示
  Widget _buildSuggestionsListView(BuildContext context) {
    return FutureBuilder<AmapResponse>(
      builder: (BuildContext context, AsyncSnapshot<AmapResponse> snapshot) {
        if (snapshot.data != null) {
          return ListView(
              children: snapshot.data.tips
                  .map(
                    (tip) =>
                    SuggestionsRow(
                      value: tip.name,
                      address: tip.address,
                      location: tip.location,
                      onIconPressed: () {
                        query = tip.name;
                      },
                      onTap: () {
                        Navigator.of(context).pop(tip);
                      },
                    ),
              )
                  .toList());
        } else {
          return Container();
        }
      },
      initialData: null,
      future: AmapService.instance.inputtips(query, city: city),
    );
  }
}

class AmapSearchPage extends StatefulWidget {
  AmapSearchPage({Key key}) : super(key: key);

  @override
  _AmapSearchPageState createState() => _AmapSearchPageState();
}

class _AmapSearchPageState extends State<AmapSearchPage> {
  TextEditingController textEditingController = TextEditingController();
  AMapLocation gpsLocation;
  bool gpsLock = false;
  String oldCity;
  Geocode changeGeo;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    if (oldCity == null) {
      oldCity = Provider.of<AmapState>(context, listen: false).city;
    }
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              '选择定位地址',
              style: TextStyle(
                  color: Color(0xff000000),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Consumer<AmapState>(
            builder: (context, state, _) =>
                Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      _buildSearchRow(state),
                      _buildLocationRow(),
                      Divider(),
                      _buildAroundLabelRow(),
                      textEditingController.text != ''
                          ? Expanded(
                        flex: 1,
                        child: _buildSuggestionsListView(context),
                      )
                          : Expanded(
                        flex: 1,
                        child: _buildAroundListView(context, state),
                      )
                    ],
                  ),
                ),
          )),
      onWillPop: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.CONFIRM_DIALOG,
                contentText2: '请选择具体定位地址',
                isNeedConfirmButton: true,
                isNeedCancelButton: true,
                confirmButtonText: '确定',
                cancelButtonText: '忽略',
                dialogHeight: 180,
                cancelAction: () {
                  if (changeGeo == null) {
                    Provider.of<AmapState>(context, listen: false)
                        .setCity(oldCity);
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            });
        return Future.value(false);
      },
    );
  }

  Widget _buildAroundLabelRow() {
    return textEditingController.text == ''
        ? Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 4),
              child: B2BV2Image.location_1(width: 18, height: 22)),
          Text(
            '附近地址',
            style: TextStyle(
                color: Color(0xff999999),
                fontSize: 13,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    )
        : Container();
  }

  Widget _buildSearchRow(AmapState state) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () => onTap(state),
            child: B2BV2Image.top_1(width: 18, height: 22),
          ),
          GestureDetector(
              onTap: () => onTap(state),
              child: Container(
                margin: EdgeInsets.only(left: 4, right: 20),
                child: Text(
                  '${state.city}',
                  style: TextStyle(
                      fontSize: 13,
                      color: Color(0xff222222),
                      fontWeight: FontWeight.w500),
                ),
              )),
          Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) =>
                    Container(
                      width: constraints.maxWidth,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            height: 32,
                            margin: EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: Color(0xffF0F0F0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              width: constraints.maxWidth,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 4),
                                    child: B2BV2Image.top_2(
                                        width: 16, height: 16),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TextField(
                                      controller: textEditingController,
                                      autofocus: true,
                                      style: TextStyle(
                                          color: Color(0xff222222),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500),
                                      decoration: InputDecoration(
                                        hintText: '请输入您的定位地址',
                                        hintStyle:
                                        TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                        contentPadding: EdgeInsets.all(0),
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          AmapService.instance.inputtips(
                                              textEditingController.text,
                                              city: state.city);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
              )),
        ],
      ),
    );
  }

  Widget _buildSuggestionsListView(BuildContext context) {
    AmapState amapState = Provider.of<AmapState>(context, listen: false);

    return FutureBuilder<AmapResponse>(
      builder: (BuildContext context, AsyncSnapshot<AmapResponse> snapshot) {
        if (snapshot.data != null) {
          return ListView(
              children: snapshot.data.tips
                  .map(
                    (tip) => SuggestionsRow(
                      value: tip.name,
                      address: tip.address,
                      location: tip.location,
                      onIconPressed: () {
                        textEditingController.text = tip.name;
                      },
                      onTap: () {
                        //修改state
                        List<String> locationArray = tip.location.split(',');
                        //设置定位信息
                        amapState.setAMapLocation(
                            aOIName: tip.name,
                            longitude: double.parse(locationArray[0]),
                            latitude: double.parse(locationArray[1]));
                        Navigator.of(context).pop(tip);
                      },
                    ),
              )
                  .toList());
        } else {
          return Container();
        }
      },
      initialData: null,
      future: AmapService.instance
          .inputtips(textEditingController.text, city: amapState.city),
    );
  }

  Widget _buildAroundListView(BuildContext context, AmapState amapState) {
    return FutureBuilder<AmapAroundResponse>(
      builder:
          (BuildContext context, AsyncSnapshot<AmapAroundResponse> snapshot) {
        if (snapshot.data != null && snapshot.data.pois != null) {
          return ListView(
              children: snapshot.data.pois
                  .map(
                    (pois) =>
                    SuggestionsRow(
                      value: pois.name,
                      address: pois.address,
                      location: pois.location,
                      onIconPressed: () {
                        textEditingController.text = pois.name;
                      },
                      onTap: () {
                        List<String> locationArray = pois.location.split(',');
                        //设置定位信息
                        amapState.setAMapLocation(
                            aOIName: pois.name,
                            longitude: double.parse(locationArray[0]),
                            latitude: double.parse(locationArray[1]));
                        Navigator.of(context).pop(pois);
                      },
                    ),
              )
                  .toList());
        } else {
          return Container();
        }
      },
      future: getAroundResponse(amapState),
    );

    // if (amapAroundResponse != null &&
    //     amapAroundResponse.pois != null &&
    //     textEditingController.text == '') {
    //   return ListView(
    //       children: amapAroundResponse.pois
    //           .map(
    //             (pois) => SuggestionsRow(
    //               value: pois.name,
    //               address: pois.address,
    //               location: pois.location,
    //               onIconPressed: () {
    //                 textEditingController.text = pois.name;
    //               },
    //               onTap: () {
    //                 Navigator.of(context).pop(pois);
    //               },
    //             ),
    //           )
    //           .toList());
    // } else {
    //   return Container();
    // }
  }

  Widget _buildLocationRow({TextStyle style = const TextStyle(
      fontSize: 14,
      color: Color(0xff222222),
      fontWeight: FontWeight.w500)}) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Consumer<AmapState>(
          builder: (context, state, _) =>
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  state.getAMapLocation() != null
                      ? Text('${state
                      .getAMapLocation()
                      .AOIName ?? state.city}',
                      style: style)
                      : Text(
                    '定位中',
                    style: style,
                  ),
                  GestureDetector(
                    onTap: () {
                      getGpsLocation(state);
                      changeGeo = Geocode.fromJson({});
                    },
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          B2BV2Image.location_2(width: 16, height: 16),
                          Text(
                            '重新定位',
                            style: style,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
        ));
  }

  // ///获取定位
  // Future<AMapLocation> getGpsLocation() async {
  //   if (gpsLocation == null && !gpsLock) {
  //     gpsLock = true;
  //     AMapLocation location = await AmapService.instance.location();
  //     if (location == null) {
  //       showDialog(
  //           context: context,
  //           builder: (_) {
  //             return CustomizeDialog(
  //               dialogType: DialogType.CONFIRM_DIALOG,
  //               contentText1: '获取位置授权失败，请设置应用位置服务',
  //               callbackResult: false,
  //               confirmAction: () {
  //                 Navigator.of(context).pop();
  //               },
  //             );
  //           });
  //     } else {
  //       amapAroundResponse = await AmapService.instance
  //           .aroundTips('${location.longitude},${location.latitude}');
  //       setState(() {
  //         gpsLocation = location;
  //       });
  //     }
  //   }
  //   gpsLock = false;
  //   return gpsLocation;
  // }

  Future<AmapAroundResponse> getAroundResponse(AmapState amapState) async {
    AmapAroundResponse result = await AmapService.instance
        .aroundTips('${amapState.longitude},${amapState.latitude}');
    return result;
  }

  void onTap(AmapState state) async {
    city_pickers.CityPickers.showCitiesSelector(
        context: context,
        sideBarStyle: city_pickers.BaseStyle(activeColor: Colors.orange))
        .then((result) {
      state.setCity(result.cityName);
      try {
        AmapService.instance.AmapGeoCode(result.cityName).then((response) {
          if (response.geocodes.isNotEmpty) {
            List<String> locationArray =
            response.geocodes.first.location.split(',');
            state.setAMapLocation(
                city: response.geocodes.first.city,
                aOIName: response.geocodes.first.city,
                longitude: double.parse(locationArray[0]),
                latitude: double.parse(locationArray[1]));
            changeGeo = response.geocodes.first;
          }
        });
      } catch (e) {
        print(e);
      }
    });
  }

  ///重新定位
  void getGpsLocation(AmapState state) async {
    Widget _dialog = CustomizeDialog(
      dialogType: DialogType.CONFIRM_DIALOG,
      contentText2: '钉单正在请求定位权限,请设置',
      isNeedConfirmButton: true,
      isNeedCancelButton: true,
      confirmButtonText: '去设置',
      cancelButtonText: '选择城市',
      dialogHeight: 180,
      confirmAction: () {
        state.openAppSetting().then((val) {
          Navigator.of(context).pop(val);
        });
      },
      cancelAction: () async {
        Tip tip = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AmapSearchPage()));
        List<String> locationArray = tip.location.split(',');
        //设置定位信息
        state.setAMapLocation(
          // aOIName: tip.district,
            longitude: double.parse(locationArray[0]),
            latitude: double.parse(locationArray[1]));
      },
    );
    state.getLocation(context, _dialog);
  }
}

class AroundListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
