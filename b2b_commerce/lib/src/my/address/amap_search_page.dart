import 'package:amap_location/amap_location.dart';
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
  AmapAroundResponse amapAroundResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // var _controller = StreamController<AmapAroundResponse>();

  // // Stream<UserModel> get stream => _controller.stream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('选择定位地址'),
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
                    Divider(),
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
                      child: _buildAroundListView(context),
                    )
                  ],
                ),
          ),
        ));
  }

  Widget _buildAroundLabelRow() {
    return textEditingController.text == ''
        ? Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              B2BIcons.location,
              color: Colors.grey,
              size: 16,
            ),
          ),
          Text(
            '附近地址',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          )
        ],
      ),
    )
        : Container();
  }

  Widget _buildSearchRow(AmapState state) {
    AmapState amapState = Provider.of<AmapState>(context);

    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              // city_pickers.Result result2 =
              //     await
              city_pickers.CityPickers.showCitiesSelector(
                  context: context,
                  sideBarStyle:
                  city_pickers.BaseStyle(activeColor: Colors.orange))
                  .then((result) {
                state.setCity(result.cityName);
                try {
                  AmapService.instance
                      .AmapGeoCode(result.cityName)
                      .then((response) {
                    if (response.geocodes.isNotEmpty) {
                      List<String> locationArray =
                      response.geocodes.first.location.split(',');
                      state.setAMapLocation(
                          aOIName: response.geocodes.first.city,
                          longitude: double.parse(locationArray[0]),
                          latitude: double.parse(locationArray[1]));
                      state.setCity(response.geocodes.first.city);
                    }
                  });
                } catch (e) {
                  print(e);
                }
              });
            },
            child: Row(
              children: <Widget>[
                Icon(
                  B2BIcons.location,
                  size: 15,
                ),
                Text(
                  '${state
                      .getAMapLocation()
                      .AOIName ?? state.city}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(left: 5),
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 0.5),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.search),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          AmapService.instance.inputtips(
                              textEditingController.text,
                              city: state.city);
                        });
                      },
                      scrollPadding: const EdgeInsets.all(1.0),
                      controller: textEditingController,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          hintText: '请输入您的定位地址',
                          hintStyle: TextStyle(fontSize: 15),
                          border: InputBorder.none),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSuggestionsListView(BuildContext context) {
    AmapState amapState = Provider.of<AmapState>(context);

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
                        textEditingController.text = tip.name;
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
      future: AmapService.instance
          .inputtips(textEditingController.text, city: amapState.city),
    );
  }

  Widget _buildAroundListView(BuildContext context) {
    if (amapAroundResponse != null &&
        amapAroundResponse.pois != null &&
        textEditingController.text == '') {
      return ListView(
          children: amapAroundResponse.pois
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
                    Navigator.of(context).pop(pois);
                  },
                ),
          )
              .toList());
    } else {
      return Container();
    }
  }

  Widget _buildLocationRow() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Consumer<AmapState>(
          builder: (context, state, _) =>
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  state.getAMapLocation() != null
                      ? Text(
                    '${state
                        .getAMapLocation()
                        .AOIName ?? state.city}',
                    style: TextStyle(fontSize: 16),
                  )
                      : Text(
                    '定位中',
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      getGpsLocation(state);
                    },
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            B2BIcons.aim,
                            color: Color.fromRGBO(255, 214, 12, 1),
                          ),
                          Text(
                            '重新定位',
                            style:
                            TextStyle(color: Color.fromRGBO(255, 214, 12, 1)),
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
            aOIName: tip.district,
            longitude: double.parse(locationArray[0]),
            latitude: double.parse(locationArray[1]));
      },
    );
    state.getLocation(context, _dialog);
  }
}
