import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ColorSizeSelectPage(),
    );
  }
}

class ColorSizeSelectPage extends StatefulWidget {
  ColorSizeSelectPageState createState() => ColorSizeSelectPageState();
}

class ColorSizeSelectPageState extends State<ColorSizeSelectPage> {
  List<Map<String, dynamic>> _regions = [
    {
      "isocode": "CN-31",
      "isocodeShort": "31",
      "countryIso": "CN",
      "name": "上海市",
      "cities": [
        {
          "code": "CN-31-1",
          "name": "上海市",
          "districts": [
            {"code": "CN-31-1-1", "name": "南汇区", "index": null, "city": null},
            {"code": "CN-31-1-2", "name": "卢湾区", "index": null, "city": null},
            {"code": "CN-31-1-3", "name": "嘉定区", "index": null, "city": null},
            {"code": "CN-31-1-4", "name": "奉贤区", "index": null, "city": null},
            {"code": "CN-31-1-5", "name": "宝山区", "index": null, "city": null},
            {"code": "CN-31-1-7", "name": "徐汇区", "index": null, "city": null},
            {"code": "CN-31-1-8", "name": "普陀区", "index": null, "city": null},
            {"code": "CN-31-1-10", "name": "松江区", "index": null, "city": null},
            {"code": "CN-31-1-11", "name": "浦东新区", "index": null, "city": null},
            {"code": "CN-31-1-6", "name": "崇明县", "index": null, "city": null},
            {"code": "CN-31-1-9", "name": "杨浦区", "index": null, "city": null},
            {"code": "CN-31-1-12", "name": "虹口区", "index": null, "city": null},
            {"code": "CN-31-1-16", "name": "闸北区", "index": null, "city": null},
            {"code": "CN-31-1-14", "name": "长宁区", "index": null, "city": null},
            {"code": "CN-31-1-15", "name": "闵行区", "index": null, "city": null},
            {"code": "CN-31-1-13", "name": "金山区", "index": null, "city": null},
            {"code": "CN-31-1-17", "name": "青浦区", "index": null, "city": null},
            {"code": "CN-31-1-18", "name": "静安区", "index": null, "city": null},
            {"code": "CN-31-1-19", "name": "黄浦区", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        }
      ],
      "index": null
    },
    {
      "isocode": "CN-53",
      "isocodeShort": "53",
      "countryIso": "CN",
      "name": "云南省",
      "cities": [
        {
          "code": "CN-53-1",
          "name": "临沧市",
          "districts": [
            {"code": "CN-53-1-1", "name": "临翔区", "index": null, "city": null},
            {"code": "CN-53-1-2", "name": "云县", "index": null, "city": null},
            {"code": "CN-53-1-3", "name": "凤庆县", "index": null, "city": null},
            {"code": "CN-53-1-5", "name": "永德县", "index": null, "city": null},
            {"code": "CN-53-1-6", "name": "沧源县", "index": null, "city": null},
            {"code": "CN-53-1-4", "name": "双江县", "index": null, "city": null},
            {"code": "CN-53-1-7", "name": "耿马县", "index": null, "city": null},
            {"code": "CN-53-1-8", "name": "镇康县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-3",
          "name": "保山市",
          "districts": [
            {"code": "CN-53-3-1", "name": "施甸县", "index": null, "city": null},
            {"code": "CN-53-3-2", "name": "昌宁县", "index": null, "city": null},
            {"code": "CN-53-3-4", "name": "隆阳区", "index": null, "city": null},
            {"code": "CN-53-3-3", "name": "腾冲县", "index": null, "city": null},
            {"code": "CN-53-3-5", "name": "龙陵县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-4",
          "name": "大理州",
          "districts": [
            {"code": "CN-53-4-1", "name": "云龙县", "index": null, "city": null},
            {"code": "CN-53-4-2", "name": "剑川县", "index": null, "city": null},
            {"code": "CN-53-4-3", "name": "南涧县", "index": null, "city": null},
            {"code": "CN-53-4-4", "name": "大理市", "index": null, "city": null},
            {"code": "CN-53-4-5", "name": "宾川县", "index": null, "city": null},
            {"code": "CN-53-4-7", "name": "弥渡县", "index": null, "city": null},
            {"code": "CN-53-4-6", "name": "巍山县", "index": null, "city": null},
            {"code": "CN-53-4-8", "name": "永平县", "index": null, "city": null},
            {"code": "CN-53-4-9", "name": "洱源县", "index": null, "city": null},
            {"code": "CN-53-4-12", "name": "鹤庆县", "index": null, "city": null},
            {"code": "CN-53-4-10", "name": "漾濞县", "index": null, "city": null},
            {"code": "CN-53-4-11", "name": "祥云县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-5",
          "name": "德宏州",
          "districts": [
            {"code": "CN-53-5-2", "name": "潞西市", "index": null, "city": null},
            {"code": "CN-53-5-3", "name": "瑞丽市", "index": null, "city": null},
            {"code": "CN-53-5-4", "name": "盈江县", "index": null, "city": null},
            {"code": "CN-53-5-5", "name": "陇川县", "index": null, "city": null},
            {"code": "CN-53-5-1", "name": "梁河县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-6",
          "name": "怒江州",
          "districts": [
            {"code": "CN-53-6-1", "name": "兰坪县", "index": null, "city": null},
            {"code": "CN-53-6-2", "name": "泸水县", "index": null, "city": null},
            {"code": "CN-53-6-4", "name": "贡山县", "index": null, "city": null},
            {"code": "CN-53-6-3", "name": "福贡县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-2",
          "name": "丽江市",
          "districts": [
            {"code": "CN-53-2-1", "name": "华坪县", "index": null, "city": null},
            {"code": "CN-53-2-2", "name": "古城区", "index": null, "city": null},
            {"code": "CN-53-2-3", "name": "宁蒗县", "index": null, "city": null},
            {"code": "CN-53-2-4", "name": "永胜县", "index": null, "city": null},
            {"code": "CN-53-2-5", "name": "玉龙县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-10",
          "name": "普洱市",
          "districts": [
            {"code": "CN-53-10-3", "name": "宁洱县", "index": null, "city": null},
            {"code": "CN-53-10-2", "name": "孟连县", "index": null, "city": null},
            {"code": "CN-53-10-1", "name": "墨江县", "index": null, "city": null},
            {"code": "CN-53-10-4", "name": "思茅区", "index": null, "city": null},
            {"code": "CN-53-10-5", "name": "景东县", "index": null, "city": null},
            {"code": "CN-53-10-8", "name": "澜沧县", "index": null, "city": null},
            {"code": "CN-53-10-7", "name": "江城县", "index": null, "city": null},
            {"code": "CN-53-10-6", "name": "景谷县", "index": null, "city": null},
            {"code": "CN-53-10-9", "name": "西盟县", "index": null, "city": null},
            {"code": "CN-53-10-10", "name": "镇沅县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-9",
          "name": "昭通市",
          "districts": [
            {"code": "CN-53-9-1", "name": "大关县", "index": null, "city": null},
            {"code": "CN-53-9-2", "name": "威信县", "index": null, "city": null},
            {"code": "CN-53-9-6", "name": "水富县", "index": null, "city": null},
            {"code": "CN-53-9-3", "name": "巧家县", "index": null, "city": null},
            {"code": "CN-53-9-4", "name": "彝良县", "index": null, "city": null},
            {"code": "CN-53-9-5", "name": "昭阳区", "index": null, "city": null},
            {"code": "CN-53-9-7", "name": "永善县", "index": null, "city": null},
            {"code": "CN-53-9-9", "name": "绥江县", "index": null, "city": null},
            {"code": "CN-53-9-8", "name": "盐津县", "index": null, "city": null},
            {"code": "CN-53-9-10", "name": "镇雄县", "index": null, "city": null},
            {"code": "CN-53-9-11", "name": "鲁甸县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-8",
          "name": "昆明市",
          "districts": [
            {"code": "CN-53-8-1", "name": "东川区", "index": null, "city": null},
            {"code": "CN-53-8-2", "name": "五华区", "index": null, "city": null},
            {"code": "CN-53-8-3", "name": "呈贡县", "index": null, "city": null},
            {"code": "CN-53-8-4", "name": "安宁市", "index": null, "city": null},
            {"code": "CN-53-8-5", "name": "官渡区", "index": null, "city": null},
            {"code": "CN-53-8-7", "name": "富民县", "index": null, "city": null},
            {"code": "CN-53-8-6", "name": "宜良县", "index": null, "city": null},
            {"code": "CN-53-8-8", "name": "寻甸县", "index": null, "city": null},
            {"code": "CN-53-8-10", "name": "晋宁县", "index": null, "city": null},
            {"code": "CN-53-8-11", "name": "盘龙区", "index": null, "city": null},
            {"code": "CN-53-8-12", "name": "石林县", "index": null, "city": null},
            {"code": "CN-53-8-9", "name": "嵩明县", "index": null, "city": null},
            {"code": "CN-53-8-14", "name": "西山区", "index": null, "city": null},
            {"code": "CN-53-8-13", "name": "禄劝县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-7",
          "name": "文山州",
          "districts": [
            {"code": "CN-53-7-1", "name": "丘北县", "index": null, "city": null},
            {"code": "CN-53-7-2", "name": "富宁县", "index": null, "city": null},
            {"code": "CN-53-7-3", "name": "广南县", "index": null, "city": null},
            {"code": "CN-53-7-5", "name": "砚山县", "index": null, "city": null},
            {"code": "CN-53-7-4", "name": "文山县", "index": null, "city": null},
            {"code": "CN-53-7-6", "name": "西畴县", "index": null, "city": null},
            {"code": "CN-53-7-7", "name": "马关县", "index": null, "city": null},
            {"code": "CN-53-7-8", "name": "麻栗坡", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-12",
          "name": "楚雄州",
          "districts": [
            {"code": "CN-53-12-1", "name": "元谋县", "index": null, "city": null},
            {"code": "CN-53-12-3", "name": "双柏县", "index": null, "city": null},
            {"code": "CN-53-12-4", "name": "大姚县", "index": null, "city": null},
            {"code": "CN-53-12-2", "name": "南华县", "index": null, "city": null},
            {"code": "CN-53-12-5", "name": "姚安县", "index": null, "city": null},
            {"code": "CN-53-12-6", "name": "楚雄市", "index": null, "city": null},
            {"code": "CN-53-12-7", "name": "武定县", "index": null, "city": null},
            {"code": "CN-53-12-8", "name": "永仁县", "index": null, "city": null},
            {"code": "CN-53-12-9", "name": "牟定县", "index": null, "city": null},
            {"code": "CN-53-12-10", "name": "禄丰县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-11",
          "name": "曲靖市",
          "districts": [
            {"code": "CN-53-11-2", "name": "宣威市", "index": null, "city": null},
            {"code": "CN-53-11-4", "name": "师宗县", "index": null, "city": null},
            {"code": "CN-53-11-5", "name": "沾益县", "index": null, "city": null},
            {"code": "CN-53-11-6", "name": "罗平县", "index": null, "city": null},
            {"code": "CN-53-11-3", "name": "富源县", "index": null, "city": null},
            {"code": "CN-53-11-1", "name": "会泽县", "index": null, "city": null},
            {"code": "CN-53-11-7", "name": "陆良县", "index": null, "city": null},
            {"code": "CN-53-11-8", "name": "马龙县", "index": null, "city": null},
            {"code": "CN-53-11-9", "name": "麒麟区", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-13",
          "name": "玉溪市",
          "districts": [
            {"code": "CN-53-13-1", "name": "元江县", "index": null, "city": null},
            {"code": "CN-53-13-2", "name": "华宁县", "index": null, "city": null},
            {"code": "CN-53-13-4", "name": "新平县", "index": null, "city": null},
            {"code": "CN-53-13-3", "name": "峨山县", "index": null, "city": null},
            {"code": "CN-53-13-5", "name": "易门县", "index": null, "city": null},
            {"code": "CN-53-13-6", "name": "江川县", "index": null, "city": null},
            {"code": "CN-53-13-7", "name": "澄江县", "index": null, "city": null},
            {"code": "CN-53-13-8", "name": "红塔区", "index": null, "city": null},
            {"code": "CN-53-13-9", "name": "通海县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-14",
          "name": "红河州",
          "districts": [
            {"code": "CN-53-14-2", "name": "元阳县", "index": null, "city": null},
            {"code": "CN-53-14-1", "name": "个旧市", "index": null, "city": null},
            {"code": "CN-53-14-3", "name": "屏边县", "index": null, "city": null},
            {"code": "CN-53-14-4", "name": "建水县", "index": null, "city": null},
            {"code": "CN-53-14-5", "name": "开远市", "index": null, "city": null},
            {"code": "CN-53-14-6", "name": "弥勒县", "index": null, "city": null},
            {"code": "CN-53-14-7", "name": "河口县", "index": null, "city": null},
            {"code": "CN-53-14-8", "name": "泸西县", "index": null, "city": null},
            {"code": "CN-53-14-9", "name": "石屏县", "index": null, "city": null},
            {"code": "CN-53-14-10", "name": "红河县", "index": null, "city": null},
            {"code": "CN-53-14-11", "name": "绿春县", "index": null, "city": null},
            {"code": "CN-53-14-13", "name": "金平县", "index": null, "city": null},
            {"code": "CN-53-14-12", "name": "蒙自县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-15",
          "name": "西双版纳州",
          "districts": [
            {"code": "CN-53-15-1", "name": "勐海县", "index": null, "city": null},
            {"code": "CN-53-15-2", "name": "勐腊县", "index": null, "city": null},
            {"code": "CN-53-15-3", "name": "景洪市", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-53-16",
          "name": "迪庆州",
          "districts": [
            {"code": "CN-53-16-1", "name": "德钦县", "index": null, "city": null},
            {"code": "CN-53-16-2", "name": "维西县", "index": null, "city": null},
            {"code": "CN-53-16-3", "name": "香格里拉县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        }
      ],
      "index": null
    },
    {
      "isocode": "CN-15",
      "isocodeShort": "15",
      "countryIso": "CN",
      "name": "内蒙古自治区",
      "cities": [
        {
          "code": "CN-15-2",
          "name": "乌海市",
          "districts": [
            {"code": "CN-15-2-1", "name": "乌达区", "index": null, "city": null},
            {"code": "CN-15-2-2", "name": "海勃湾区", "index": null, "city": null},
            {"code": "CN-15-2-3", "name": "海南区", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-15-3",
          "name": "兴安盟",
          "districts": [
            {"code": "CN-15-3-1", "name": "乌兰浩特市", "index": null, "city": null},
            {
              "code": "CN-15-3-4",
              "name": "科尔沁右翼前旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-3-5", "name": "突泉县", "index": null, "city": null},
            {
              "code": "CN-15-3-3",
              "name": "科尔沁右翼中旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-3-2", "name": "扎赉特旗", "index": null, "city": null},
            {"code": "CN-15-3-6", "name": "阿尔山市", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-15-1",
          "name": "乌兰察布市",
          "districts": [
            {"code": "CN-15-1-1", "name": "丰镇市", "index": null, "city": null},
            {"code": "CN-15-1-2", "name": "兴和县", "index": null, "city": null},
            {"code": "CN-15-1-3", "name": "凉城县", "index": null, "city": null},
            {"code": "CN-15-1-7", "name": "四子王旗", "index": null, "city": null},
            {"code": "CN-15-1-6", "name": "商都县", "index": null, "city": null},
            {"code": "CN-15-1-5", "name": "卓资县", "index": null, "city": null},
            {"code": "CN-15-1-4", "name": "化德县", "index": null, "city": null},
            {
              "code": "CN-15-1-8",
              "name": "察哈尔右翼中旗",
              "index": null,
              "city": null
            },
            {
              "code": "CN-15-1-9",
              "name": "察哈尔右翼前旗",
              "index": null,
              "city": null
            },
            {
              "code": "CN-15-1-10",
              "name": "察哈尔右翼后旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-1-11", "name": "集宁区", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-15-4",
          "name": "包头市",
          "districts": [
            {"code": "CN-15-4-1", "name": "东河区", "index": null, "city": null},
            {"code": "CN-15-4-3", "name": "固阳县", "index": null, "city": null},
            {"code": "CN-15-4-2", "name": "九原区", "index": null, "city": null},
            {"code": "CN-15-4-4", "name": "土默特右旗", "index": null, "city": null},
            {"code": "CN-15-4-5", "name": "昆都仑区", "index": null, "city": null},
            {"code": "CN-15-4-6", "name": "白云矿区", "index": null, "city": null},
            {"code": "CN-15-4-7", "name": "石拐区", "index": null, "city": null},
            {
              "code": "CN-15-4-8",
              "name": "达尔罕茂明安联合旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-4-9", "name": "青山区", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-15-5",
          "name": "呼伦贝尔市",
          "districts": [
            {"code": "CN-15-5-1", "name": "扎兰屯", "index": null, "city": null},
            {"code": "CN-15-5-4", "name": "根河", "index": null, "city": null},
            {
              "code": "CN-15-5-2",
              "name": "新巴尔虎右旗",
              "index": null,
              "city": null
            },
            {
              "code": "CN-15-5-3",
              "name": "新巴尔虎左旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-5-5", "name": "海拉尔", "index": null, "city": null},
            {"code": "CN-15-5-6", "name": "满洲里", "index": null, "city": null},
            {
              "code": "CN-15-5-8",
              "name": "鄂伦春自治旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-5-7", "name": "牙克石", "index": null, "city": null},
            {
              "code": "CN-15-5-9",
              "name": "鄂温克族自治旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-5-10", "name": "阿荣旗", "index": null, "city": null},
            {
              "code": "CN-15-5-11",
              "name": "陈巴尔虎旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-5-12", "name": "额尔古纳", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-15-6",
          "name": "呼和浩特市",
          "districts": [
            {"code": "CN-15-6-4", "name": "托克托县", "index": null, "city": null},
            {"code": "CN-15-6-2", "name": "回民区", "index": null, "city": null},
            {"code": "CN-15-6-1", "name": "和林格尔县", "index": null, "city": null},
            {"code": "CN-15-6-3", "name": "土默特左旗", "index": null, "city": null},
            {"code": "CN-15-6-5", "name": "新城区", "index": null, "city": null},
            {"code": "CN-15-6-7", "name": "清水河县", "index": null, "city": null},
            {"code": "CN-15-6-8", "name": "玉泉区", "index": null, "city": null},
            {"code": "CN-15-6-6", "name": "武川县", "index": null, "city": null},
            {"code": "CN-15-6-9", "name": "赛罕区", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-15-8",
          "name": "赤峰市",
          "districts": [
            {"code": "CN-15-8-1", "name": "元宝山区", "index": null, "city": null},
            {"code": "CN-15-8-4", "name": "宁城县", "index": null, "city": null},
            {"code": "CN-15-8-2", "name": "克什克腾旗", "index": null, "city": null},
            {"code": "CN-15-8-3", "name": "喀喇沁旗", "index": null, "city": null},
            {"code": "CN-15-8-5", "name": "巴林右旗", "index": null, "city": null},
            {"code": "CN-15-8-8", "name": "松山区", "index": null, "city": null},
            {"code": "CN-15-8-7", "name": "敖汉旗", "index": null, "city": null},
            {"code": "CN-15-8-6", "name": "巴林左旗", "index": null, "city": null},
            {"code": "CN-15-8-9", "name": "林西县", "index": null, "city": null},
            {"code": "CN-15-8-11", "name": "翁牛特旗", "index": null, "city": null},
            {"code": "CN-15-8-10", "name": "红山区", "index": null, "city": null},
            {
              "code": "CN-15-8-12",
              "name": "阿鲁科尔沁旗",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-15-9",
          "name": "通辽市",
          "districts": [
            {"code": "CN-15-9-2", "name": "库伦旗", "index": null, "city": null},
            {"code": "CN-15-9-1", "name": "奈曼旗", "index": null, "city": null},
            {
              "code": "CN-15-9-6",
              "name": "科尔沁左翼中旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-9-5", "name": "科尔沁区", "index": null, "city": null},
            {"code": "CN-15-9-3", "name": "开鲁县", "index": null, "city": null},
            {"code": "CN-15-9-4", "name": "扎鲁特旗", "index": null, "city": null},
            {"code": "CN-15-9-8", "name": "霍林郭勒市", "index": null, "city": null},
            {
              "code": "CN-15-9-7",
              "name": "科尔沁左翼后旗",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-15-7",
          "name": "巴彦淖尔市",
          "districts": [
            {"code": "CN-15-7-1", "name": "临河区", "index": null, "city": null},
            {"code": "CN-15-7-4", "name": "乌拉特后旗", "index": null, "city": null},
            {"code": "CN-15-7-2", "name": "乌拉特中旗", "index": null, "city": null},
            {"code": "CN-15-7-3", "name": "乌拉特前旗", "index": null, "city": null},
            {"code": "CN-15-7-7", "name": "磴口县", "index": null, "city": null},
            {"code": "CN-15-7-5", "name": "五原县", "index": null, "city": null},
            {"code": "CN-15-7-6", "name": "杭锦后旗", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-15-12",
          "name": "阿拉善盟",
          "districts": [
            {
              "code": "CN-15-12-1",
              "name": "阿拉善右旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-12-3", "name": "额济纳旗", "index": null, "city": null},
            {"code": "CN-15-12-2", "name": "阿拉善左旗", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-15-11",
          "name": "锡林郭勒盟",
          "districts": [
            {
              "code": "CN-15-11-1",
              "name": "东乌珠穆沁旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-11-2", "name": "二连浩特", "index": null, "city": null},
            {"code": "CN-15-11-3", "name": "多伦", "index": null, "city": null},
            {"code": "CN-15-11-4", "name": "太仆寺旗", "index": null, "city": null},
            {
              "code": "CN-15-11-8",
              "name": "苏尼特左旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-11-6", "name": "正镶白旗", "index": null, "city": null},
            {
              "code": "CN-15-11-7",
              "name": "苏尼特右旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-11-5", "name": "正蓝旗", "index": null, "city": null},
            {
              "code": "CN-15-11-9",
              "name": "西乌珠穆沁旗",
              "index": null,
              "city": null
            },
            {
              "code": "CN-15-11-10",
              "name": "锡林浩特",
              "index": null,
              "city": null
            },
            {"code": "CN-15-11-11", "name": "镶黄旗", "index": null, "city": null},
            {"code": "CN-15-11-12", "name": "阿巴嘎旗", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-15-10",
          "name": "鄂尔多斯市",
          "districts": [
            {"code": "CN-15-10-2", "name": "乌审旗", "index": null, "city": null},
            {"code": "CN-15-10-1", "name": "东胜区", "index": null, "city": null},
            {
              "code": "CN-15-10-3",
              "name": "伊金霍洛旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-10-4", "name": "准格尔旗", "index": null, "city": null},
            {"code": "CN-15-10-5", "name": "杭锦旗", "index": null, "city": null},
            {"code": "CN-15-10-6", "name": "达拉特旗", "index": null, "city": null},
            {
              "code": "CN-15-10-7",
              "name": "鄂托克前旗",
              "index": null,
              "city": null
            },
            {"code": "CN-15-10-8", "name": "鄂托克旗", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        }
      ],
      "index": null
    },
    {
      "isocode": "CN-11",
      "isocodeShort": "11",
      "countryIso": "CN",
      "name": "北京市",
      "cities": [
        {
          "code": "CN-11-1",
          "name": "北京市",
          "districts": [
            {"code": "CN-11-1-1", "name": "东城区", "index": null, "city": null},
            {"code": "CN-11-1-4", "name": "宣武区", "index": null, "city": null},
            {"code": "CN-11-1-2", "name": "丰台区", "index": null, "city": null},
            {"code": "CN-11-1-3", "name": "大兴区", "index": null, "city": null},
            {"code": "CN-11-1-5", "name": "密云县", "index": null, "city": null},
            {"code": "CN-11-1-6", "name": "崇文区", "index": null, "city": null},
            {"code": "CN-11-1-8", "name": "延庆县", "index": null, "city": null},
            {"code": "CN-11-1-9", "name": "怀柔区", "index": null, "city": null},
            {"code": "CN-11-1-10", "name": "房山区", "index": null, "city": null},
            {"code": "CN-11-1-7", "name": "平谷区", "index": null, "city": null},
            {"code": "CN-11-1-12", "name": "朝阳区", "index": null, "city": null},
            {"code": "CN-11-1-13", "name": "海淀区", "index": null, "city": null},
            {"code": "CN-11-1-11", "name": "昌平区", "index": null, "city": null},
            {"code": "CN-11-1-17", "name": "门头沟区", "index": null, "city": null},
            {"code": "CN-11-1-14", "name": "石景山区", "index": null, "city": null},
            {"code": "CN-11-1-15", "name": "西城区", "index": null, "city": null},
            {"code": "CN-11-1-16", "name": "通州区", "index": null, "city": null},
            {"code": "CN-11-1-18", "name": "顺义区", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        }
      ],
      "index": null
    },
    {
      "isocode": "CN-22",
      "isocodeShort": "22",
      "countryIso": "CN",
      "name": "吉林省",
      "cities": [
        {
          "code": "CN-22-1",
          "name": "吉林市",
          "districts": [
            {"code": "CN-22-1-1", "name": "丰满区", "index": null, "city": null},
            {"code": "CN-22-1-2", "name": "昌邑区", "index": null, "city": null},
            {"code": "CN-22-1-3", "name": "桦甸市", "index": null, "city": null},
            {"code": "CN-22-1-4", "name": "永吉县", "index": null, "city": null},
            {"code": "CN-22-1-5", "name": "磐石市", "index": null, "city": null},
            {"code": "CN-22-1-6", "name": "舒兰市", "index": null, "city": null},
            {"code": "CN-22-1-7", "name": "船营区", "index": null, "city": null},
            {"code": "CN-22-1-8", "name": "蛟河市", "index": null, "city": null},
            {"code": "CN-22-1-9", "name": "龙潭区", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-22-2",
          "name": "四平市",
          "districts": [
            {"code": "CN-22-2-2", "name": "公主岭市", "index": null, "city": null},
            {
              "code": "CN-22-2-1",
              "name": "伊通满族自治县",
              "index": null,
              "city": null
            },
            {"code": "CN-22-2-3", "name": "双辽市", "index": null, "city": null},
            {"code": "CN-22-2-4", "name": "梨树县", "index": null, "city": null},
            {"code": "CN-22-2-5", "name": "铁东区", "index": null, "city": null},
            {"code": "CN-22-2-6", "name": "铁西区", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-22-3",
          "name": "延边朝鲜族自治州",
          "districts": [
            {"code": "CN-22-3-2", "name": "图们市", "index": null, "city": null},
            {"code": "CN-22-3-1", "name": "和龙市", "index": null, "city": null},
            {"code": "CN-22-3-3", "name": "安图县", "index": null, "city": null},
            {"code": "CN-22-3-4", "name": "延吉市", "index": null, "city": null},
            {"code": "CN-22-3-6", "name": "汪清县", "index": null, "city": null},
            {"code": "CN-22-3-7", "name": "珲春市", "index": null, "city": null},
            {"code": "CN-22-3-5", "name": "敦化市", "index": null, "city": null},
            {"code": "CN-22-3-8", "name": "龙井市", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-22-5",
          "name": "白城市",
          "districts": [
            {"code": "CN-22-5-1", "name": "大安市", "index": null, "city": null},
            {"code": "CN-22-5-2", "name": "洮北区", "index": null, "city": null},
            {"code": "CN-22-5-3", "name": "洮南市", "index": null, "city": null},
            {"code": "CN-22-5-4", "name": "通榆县", "index": null, "city": null},
            {"code": "CN-22-5-5", "name": "镇赉县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-22-4",
          "name": "松原市",
          "districts": [
            {"code": "CN-22-4-1", "name": "乾安县", "index": null, "city": null},
            {
              "code": "CN-22-4-2",
              "name": "前郭尔罗斯蒙古族自治县",
              "index": null,
              "city": null
            },
            {"code": "CN-22-4-3", "name": "宁江区", "index": null, "city": null},
            {"code": "CN-22-4-5", "name": "长岭县", "index": null, "city": null},
            {"code": "CN-22-4-4", "name": "扶余县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-22-6",
          "name": "白山市",
          "districts": [
            {"code": "CN-22-6-1", "name": "临江市", "index": null, "city": null},
            {"code": "CN-22-6-2", "name": "八道江区", "index": null, "city": null},
            {"code": "CN-22-6-3", "name": "抚松县", "index": null, "city": null},
            {"code": "CN-22-6-4", "name": "江源区", "index": null, "city": null},
            {
              "code": "CN-22-6-5",
              "name": "长白朝鲜族自治县",
              "index": null,
              "city": null
            },
            {"code": "CN-22-6-6", "name": "靖宇县", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-22-7",
          "name": "辽源市",
          "districts": [
            {"code": "CN-22-7-1", "name": "东丰县", "index": null, "city": null},
            {"code": "CN-22-7-2", "name": "东辽县", "index": null, "city": null},
            {"code": "CN-22-7-3", "name": "西安区", "index": null, "city": null},
            {"code": "CN-22-7-4", "name": "龙山区", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-22-8",
          "name": "通化市",
          "districts": [
            {"code": "CN-22-8-1", "name": "东昌区", "index": null, "city": null},
            {"code": "CN-22-8-3", "name": "柳河县", "index": null, "city": null},
            {"code": "CN-22-8-2", "name": "二道江区", "index": null, "city": null},
            {"code": "CN-22-8-4", "name": "梅河口市", "index": null, "city": null},
            {"code": "CN-22-8-5", "name": "辉南县", "index": null, "city": null},
            {"code": "CN-22-8-6", "name": "通化县", "index": null, "city": null},
            {"code": "CN-22-8-7", "name": "集安市", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-22-9",
          "name": "长春市",
          "districts": [
            {"code": "CN-22-9-1", "name": "九台市", "index": null, "city": null},
            {"code": "CN-22-9-2", "name": "二道区", "index": null, "city": null},
            {"code": "CN-22-9-4", "name": "南关区", "index": null, "city": null},
            {"code": "CN-22-9-5", "name": "双阳区", "index": null, "city": null},
            {"code": "CN-22-9-3", "name": "农安县", "index": null, "city": null},
            {"code": "CN-22-9-9", "name": "榆树市", "index": null, "city": null},
            {"code": "CN-22-9-10", "name": "绿园区", "index": null, "city": null},
            {"code": "CN-22-9-8", "name": "朝阳区", "index": null, "city": null},
            {"code": "CN-22-9-7", "name": "德惠市", "index": null, "city": null},
            {"code": "CN-22-9-6", "name": "宽城区", "index": null, "city": null}
          ],
          "index": null,
          "region": null
        }
      ],
      "index": null
    },
    {
      "isocode": "CN-21",
      "isocodeShort": "21",
      "countryIso": "CN",
      "name": "辽宁省",
      "cities": [
        {
          "code": "CN-21-4",
          "name": "朝阳市",
          "districts": [
            {
              "code": "CN-21-4-2",
              "name": "北票市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-4-1",
              "name": "凌源市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-4-3",
              "name": "双塔区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-4-4",
              "name": "喀喇沁左翼蒙古族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-4-5",
              "name": "建平县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-4-6",
              "name": "朝阳县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-4-7",
              "name": "龙城区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-2",
          "name": "大连市",
          "districts": [
            {
              "code": "CN-21-2-1",
              "name": "中山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-2-3",
              "name": "旅顺口区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-2-4",
              "name": "普兰店市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-2-2",
              "name": "庄河市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-2-8",
              "name": "西岗区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-2-7",
              "name": "甘井子区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-2-6",
              "name": "瓦房店市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-2-5",
              "name": "沙河口区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-2-10",
              "name": "长海县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-2-9",
              "name": "金州区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-3",
          "name": "抚顺市",
          "districts": [
            {
              "code": "CN-21-3-1",
              "name": "东洲区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-3-2",
              "name": "抚顺县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-3-3",
              "name": "新宾满族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-3-5",
              "name": "望花区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-3-4",
              "name": "新抚区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-3-6",
              "name": "清原满族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-3-7",
              "name": "顺城区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-1",
          "name": "丹东市",
          "districts": [
            {
              "code": "CN-21-1-1",
              "name": "东港市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-1-2",
              "name": "元宝区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-1-3",
              "name": "凤城市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-1-4",
              "name": "宽甸满族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-1-6",
              "name": "振安区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-1-5",
              "name": "振兴区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-6",
          "name": "沈阳市",
          "districts": [
            {
              "code": "CN-21-6-2",
              "name": "于洪区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-6-1",
              "name": "东陵区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-6-3",
              "name": "和平区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-6-5",
              "name": "康平县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-6-6",
              "name": "新民市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-6-7",
              "name": "沈北新区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-6-8",
              "name": "沈河区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-6-4",
              "name": "大东区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-6-10",
              "name": "皇姑区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-6-12",
              "name": "辽中县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-6-9",
              "name": "法库县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-6-11",
              "name": "苏家屯区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-6-13",
              "name": "铁西区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-7",
          "name": "盘锦市",
          "districts": [
            {
              "code": "CN-21-7-1",
              "name": "兴隆台区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-7-2",
              "name": "双台子区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-7-3",
              "name": "大洼县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-7-4",
              "name": "盘山县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-5",
          "name": "本溪市",
          "districts": [
            {
              "code": "CN-21-5-2",
              "name": "平山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-5-1",
              "name": "南芬区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-5-3",
              "name": "明山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-5-4",
              "name": "本溪满族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-5-5",
              "name": "桓仁满族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-5-6",
              "name": "溪湖区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-9",
          "name": "葫芦岛市",
          "districts": [
            {
              "code": "CN-21-9-1",
              "name": "兴城市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-9-2",
              "name": "南票区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-9-4",
              "name": "绥中县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-9-5",
              "name": "连山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-9-3",
              "name": "建昌县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-9-6",
              "name": "龙港区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-10",
          "name": "辽阳市",
          "districts": [
            {
              "code": "CN-21-10-3",
              "name": "弓长岭区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-10-2",
              "name": "宏伟区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-10-1",
              "name": "太子河区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-10-4",
              "name": "文圣区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-10-6",
              "name": "白塔区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-10-7",
              "name": "辽阳县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-10-5",
              "name": "灯塔市",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-8",
          "name": "营口市",
          "districts": [
            {
              "code": "CN-21-8-2",
              "name": "盖州市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-8-1",
              "name": "大石桥市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-8-3",
              "name": "站前区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-8-4",
              "name": "老边区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-8-5",
              "name": "西市区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-8-6",
              "name": "鲅鱼圈区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-11",
          "name": "铁岭市",
          "districts": [
            {
              "code": "CN-21-11-1",
              "name": "开原市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-11-2",
              "name": "昌图县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-11-4",
              "name": "西丰县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-11-3",
              "name": "清河区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-11-5",
              "name": "调兵山市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-11-7",
              "name": "银州区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-11-6",
              "name": "铁岭县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-13",
          "name": "阜新市",
          "districts": [
            {
              "code": "CN-21-13-3",
              "name": "新邱区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-13-1",
              "name": "太平区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-13-2",
              "name": "彰武县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-13-5",
              "name": "清河门区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-13-4",
              "name": "海州区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-13-7",
              "name": "阜新蒙古族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-13-6",
              "name": "细河区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-12",
          "name": "锦州市",
          "districts": [
            {
              "code": "CN-21-12-1",
              "name": "义县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-12-2",
              "name": "凌河区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-12-4",
              "name": "北镇市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-12-5",
              "name": "古塔区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-12-3",
              "name": "凌海市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-12-6",
              "name": "太和区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-12-7",
              "name": "黑山县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-21-14",
          "name": "鞍山市",
          "districts": [
            {
              "code": "CN-21-14-1",
              "name": "千山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-14-2",
              "name": "台安县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-14-3",
              "name": "岫岩满族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-14-4",
              "name": "海城市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-14-5",
              "name": "立山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-14-6",
              "name": "铁东区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-21-14-7",
              "name": "铁西区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        }
      ],
      "index": null
    },
    {
      "isocode": "CN-50",
      "isocodeShort": "50",
      "countryIso": "CN",
      "name": "重庆市",
      "cities": [
        {
          "code": "CN-50-1",
          "name": "重庆市",
          "districts": [
            {
              "code": "CN-50-1-2",
              "name": "九龙坡",
              "index": null,
              "city": null
            },
            {
              "code": "CN-50-1-1",
              "name": "万州区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-50-1-3",
              "name": "合川区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-50-1-4",
              "name": "垫江县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-50-1-7",
              "name": "江津区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-50-1-5",
              "name": "彭水苗族土家族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-50-1-6",
              "name": "永川区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-50-1-10",
              "name": "渝北区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-50-1-9",
              "name": "渝中区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-50-1-8",
              "name": "涪陵区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-50-1-11",
              "name": "潼南县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-50-1-12",
              "name": "黔江区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        }
      ],
      "index": null
    },
    {
      "isocode": "CN-61",
      "isocodeShort": "61",
      "countryIso": "CN",
      "name": "陕西省",
      "cities": [
        {
          "code": "CN-61-1",
          "name": "咸阳市",
          "districts": [
            {
              "code": "CN-61-1-4",
              "name": "彬县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-3",
              "name": "兴平市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-2",
              "name": "乾县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-1",
              "name": "三原县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-5",
              "name": "旬邑县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-6",
              "name": "杨陵区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-7",
              "name": "武功县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-8",
              "name": "永寿县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-10",
              "name": "淳化县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-12",
              "name": "礼泉县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-9",
              "name": "泾阳县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-11",
              "name": "渭城区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-14",
              "name": "长武县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-1-13",
              "name": "秦都区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-61-3",
          "name": "安康市",
          "districts": [
            {
              "code": "CN-61-3-1",
              "name": "宁陕县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-3-2",
              "name": "岚皋县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-3-4",
              "name": "旬阳县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-3-5",
              "name": "汉滨区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-3-6",
              "name": "汉阴县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-3-3",
              "name": "平利县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-3-7",
              "name": "白河县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-3-9",
              "name": "紫阳县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-3-10",
              "name": "镇坪县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-3-8",
              "name": "石泉县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-61-4",
          "name": "宝鸡市",
          "districts": [
            {
              "code": "CN-61-4-1",
              "name": "凤县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-4-2",
              "name": "凤翔县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-4-3",
              "name": "千阳县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-4-4",
              "name": "太白县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-4-6",
              "name": "扶风县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-4-7",
              "name": "渭滨区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-4-5",
              "name": "岐山县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-4-8",
              "name": "眉县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-4-10",
              "name": "陇县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-4-9",
              "name": "金台区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-4-11",
              "name": "陈仓区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-4-12",
              "name": "麟游县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-61-5",
          "name": "延安市",
          "districts": [
            {
              "code": "CN-61-5-1",
              "name": "吴起县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-5-3",
              "name": "安塞县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-5-6",
              "name": "富县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-5-2",
              "name": "子长县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-5-4",
              "name": "宜川县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-5-5",
              "name": "宝塔区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-5-7",
              "name": "延川县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-5-8",
              "name": "延长县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-5-10",
              "name": "洛川县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-5-9",
              "name": "志丹县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-5-12",
              "name": "黄陵县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-5-13",
              "name": "黄龙县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-5-11",
              "name": "甘泉县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-61-6",
          "name": "榆林市",
          "districts": [
            {
              "code": "CN-61-6-1",
              "name": "佳县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-6-2",
              "name": "吴堡县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-6-4",
              "name": "定边县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-6-3",
              "name": "子洲县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-6-7",
              "name": "横山县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-6-6",
              "name": "榆阳区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-6-5",
              "name": "府谷县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-6-8",
              "name": "清涧县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-6-10",
              "name": "米脂县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-6-9",
              "name": "神木县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-6-12",
              "name": "靖边县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-6-11",
              "name": "绥德县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-61-2",
          "name": "商洛市",
          "districts": [
            {
              "code": "CN-61-2-2",
              "name": "商南县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-2-1",
              "name": "丹凤县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-2-6",
              "name": "洛南县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-2-5",
              "name": "柞水县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-2-4",
              "name": "山阳县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-2-3",
              "name": "商州区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-2-7",
              "name": "镇安县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-61-7",
          "name": "汉中市",
          "districts": [
            {
              "code": "CN-61-7-1",
              "name": "佛坪县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-7-2",
              "name": "勉县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-7-4",
              "name": "城固县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-7-3",
              "name": "南郑县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-7-6",
              "name": "汉台区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-7-8",
              "name": "留坝县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-7-7",
              "name": "洋县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-7-5",
              "name": "宁强县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-7-9",
              "name": "略阳县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-7-10",
              "name": "西乡县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-7-11",
              "name": "镇巴县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-61-8",
          "name": "渭南市",
          "districts": [
            {
              "code": "CN-61-8-1",
              "name": "临渭区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-8-3",
              "name": "华阴市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-8-2",
              "name": "华县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-8-4",
              "name": "合阳县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-8-8",
              "name": "澄城县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-8-7",
              "name": "潼关县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-8-6",
              "name": "富平县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-8-5",
              "name": "大荔县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-8-11",
              "name": "韩城市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-8-9",
              "name": "白水县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-8-10",
              "name": "蒲城县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-61-9",
          "name": "西安市",
          "districts": [
            {
              "code": "CN-61-9-1",
              "name": "临潼区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-9-2",
              "name": "周至县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-9-3",
              "name": "户县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-9-4",
              "name": "新城区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-9-5",
              "name": "未央区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-9-9",
              "name": "蓝田县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-9-8",
              "name": "莲湖区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-9-6",
              "name": "灞桥区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-9-7",
              "name": "碑林区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-9-11",
              "name": "阎良区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-9-10",
              "name": "长安区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-9-12",
              "name": "雁塔区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-9-13",
              "name": "高陵县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-61-10",
          "name": "铜川市",
          "districts": [
            {
              "code": "CN-61-10-1",
              "name": "印台区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-10-2",
              "name": "宜君县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-10-3",
              "name": "王益区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-61-10-4",
              "name": "耀州区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        }
      ],
      "index": null
    },
    {
      "isocode": "CN-63",
      "isocodeShort": "63",
      "countryIso": "CN",
      "name": "青海省",
      "cities": [
        {
          "code": "CN-63-2",
          "name": "海东地区",
          "districts": [
            {
              "code": "CN-63-2-1",
              "name": "乐都县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-2-2",
              "name": "互助土族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-2-3",
              "name": "化隆回族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-2-5",
              "name": "循化撒拉族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-2-4",
              "name": "平安县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-2-6",
              "name": "民和回族土族自治县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-63-1",
          "name": "果洛藏族自治州",
          "districts": [
            {
              "code": "CN-63-1-1",
              "name": "久治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-1-2",
              "name": "玛多县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-1-3",
              "name": "玛沁县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-1-4",
              "name": "班玛县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-1-5",
              "name": "甘德县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-1-6",
              "name": "达日县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-63-3",
          "name": "海北藏族自治州",
          "districts": [
            {
              "code": "CN-63-3-1",
              "name": "刚察县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-3-2",
              "name": "海晏县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-3-3",
              "name": "祁连县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-3-4",
              "name": "门源回族自治县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-63-4",
          "name": "海南藏族自治州",
          "districts": [
            {
              "code": "CN-63-4-2",
              "name": "兴海县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-4-4",
              "name": "贵南县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-4-3",
              "name": "同德县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-4-1",
              "name": "共和县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-4-5",
              "name": "贵德县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-63-6",
          "name": "玉树藏族自治州",
          "districts": [
            {
              "code": "CN-63-6-2",
              "name": "曲麻莱县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-6-1",
              "name": "囊谦县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-6-3",
              "name": "杂多县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-6-4",
              "name": "治多县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-6-5",
              "name": "玉树县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-6-6",
              "name": "称多县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-63-5",
          "name": "海西蒙古族藏族自治州",
          "districts": [
            {
              "code": "CN-63-5-2",
              "name": "冷湖行委",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-5-1",
              "name": "乌兰县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-5-3",
              "name": "大柴旦行委",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-5-4",
              "name": "天峻县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-5-6",
              "name": "格尔木市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-5-5",
              "name": "德令哈市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-5-7",
              "name": "茫崖行委",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-5-8",
              "name": "都兰县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-63-7",
          "name": "西宁市",
          "districts": [
            {
              "code": "CN-63-7-1",
              "name": "城东区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-7-2",
              "name": "城中区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-7-3",
              "name": "城北区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-7-4",
              "name": "城西区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-7-6",
              "name": "湟中县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-7-5",
              "name": "大通回族土族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-7-7",
              "name": "湟源县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-63-8",
          "name": "黄南藏族自治州",
          "districts": [
            {
              "code": "CN-63-8-1",
              "name": "同仁县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-8-2",
              "name": "尖扎县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-8-3",
              "name": "河南蒙古族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-63-8-4",
              "name": "泽库县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        }
      ],
      "index": null
    },
    {
      "isocode": "CN-91",
      "isocodeShort": "91",
      "countryIso": "CN",
      "name": "香港特别行政区",
      "cities": [],
      "index": null
    },
    {
      "isocode": "CN-23",
      "isocodeShort": "23",
      "countryIso": "CN",
      "name": "黑龙江省",
      "cities": [
        {
          "code": "CN-23-1",
          "name": "七台河市",
          "districts": [
            {
              "code": "CN-23-1-1",
              "name": "勃利县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-1-2",
              "name": "新兴区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-1-3",
              "name": "桃山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-1-4",
              "name": "茄子河区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-23-4",
          "name": "双鸭山市",
          "districts": [
            {
              "code": "CN-23-4-1",
              "name": "友谊县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-4-2",
              "name": "四方台区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-4-3",
              "name": "宝山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-4-5",
              "name": "尖山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-4-4",
              "name": "宝清县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-4-6",
              "name": "岭东区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-4-7",
              "name": "集贤县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-4-8",
              "name": "饶河县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-23-2",
          "name": "伊春市",
          "districts": [
            {
              "code": "CN-23-2-2",
              "name": "乌伊岭",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-1",
              "name": "上甘岭",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-4",
              "name": "五营",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-3",
              "name": "乌马河",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-6",
              "name": "南岔",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-5",
              "name": "伊春区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-8",
              "name": "嘉荫县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-7",
              "name": "友好",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-11",
              "name": "汤旺河",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-9",
              "name": "带岭区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-12",
              "name": "红星区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-10",
              "name": "新青区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-16",
              "name": "金山屯",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-15",
              "name": "西林区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-14",
              "name": "翠峦区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-13",
              "name": "美溪区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-2-17",
              "name": "铁力市",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-23-3",
          "name": "佳木斯市",
          "districts": [
            {
              "code": "CN-23-3-3",
              "name": "同江市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-3-2",
              "name": "前进区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-3-1",
              "name": "东风区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-3-5",
              "name": "富锦市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-3-4",
              "name": "向阳区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-3-6",
              "name": "抚远县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-3-9",
              "name": "汤原县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-3-10",
              "name": "郊区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-3-7",
              "name": "桦南县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-3-8",
              "name": "桦川县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-23-7",
          "name": "大庆市",
          "districts": [
            {
              "code": "CN-23-7-1",
              "name": "大同区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-7-4",
              "name": "红岗区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-7-3",
              "name": "林甸县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-7-2",
              "name": "杜尔伯特蒙古族自治县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-7-7",
              "name": "萨尔图区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-7-5",
              "name": "肇州县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-7-6",
              "name": "肇源县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-7-9",
              "name": "龙凤区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-7-8",
              "name": "让胡路区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-23-6",
          "name": "大兴安岭地区",
          "districts": [
            {
              "code": "CN-23-6-2",
              "name": "呼中区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-6-1",
              "name": "加格达奇区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-6-3",
              "name": "呼玛县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-6-6",
              "name": "松岭区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-6-7",
              "name": "漠河县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-6-4",
              "name": "塔河县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-6-5",
              "name": "新林区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-23-8",
          "name": "牡丹江市",
          "districts": [
            {
              "code": "CN-23-8-1",
              "name": "东宁县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-8-3",
              "name": "宁安市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-8-2",
              "name": "东安区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-8-5",
              "name": "海林市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-8-6",
              "name": "爱民区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-8-4",
              "name": "林口县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-8-7",
              "name": "穆棱市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-8-8",
              "name": "绥芬河市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-8-9",
              "name": "西安区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-8-10",
              "name": "阳明区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-23-5",
          "name": "哈尔滨市",
          "districts": [
            {
              "code": "CN-23-5-1",
              "name": "五常",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-2",
              "name": "依兰",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-3",
              "name": "南岗",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-4",
              "name": "双城",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-5",
              "name": "呼兰",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-6",
              "name": "宾县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-10",
              "name": "延寿",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-9",
              "name": "平房",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-7",
              "name": "尚志",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-8",
              "name": "巴彦",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-11",
              "name": "方正",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-13",
              "name": "松北",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-12",
              "name": "木兰",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-14",
              "name": "通河",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-15",
              "name": "道外",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-17",
              "name": "阿城",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-16",
              "name": "道里",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-5-18",
              "name": "香坊",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-23-9",
          "name": "绥化市",
          "districts": [
            {
              "code": "CN-23-9-1",
              "name": "兰西县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-9-2",
              "name": "北林区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-9-3",
              "name": "安达市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-9-4",
              "name": "庆安县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-9-5",
              "name": "明水县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-9-9",
              "name": "肇东市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-9-7",
              "name": "海伦市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-9-8",
              "name": "绥棱县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-9-6",
              "name": "望奎县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-9-10",
              "name": "青冈县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-23-10",
          "name": "鸡西市",
          "districts": [
            {
              "code": "CN-23-10-2",
              "name": "密山市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-10-1",
              "name": "城子河区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-10-3",
              "name": "恒山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-10-6",
              "name": "虎林市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-10-4",
              "name": "梨树区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-10-5",
              "name": "滴道区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-10-8",
              "name": "鸡冠区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-10-7",
              "name": "鸡东县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-10-9",
              "name": "麻山区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-23-11",
          "name": "鹤岗市",
          "districts": [
            {
              "code": "CN-23-11-1",
              "name": "东山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-11-2",
              "name": "兴安区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-11-3",
              "name": "兴山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-11-4",
              "name": "南山区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-11-5",
              "name": "向阳区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-11-6",
              "name": "工农区",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-11-7",
              "name": "绥滨县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-11-8",
              "name": "萝北县",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-23-12",
          "name": "黑河市",
          "districts": [
            {
              "code": "CN-23-12-1",
              "name": "五大连池市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-12-2",
              "name": "北安市",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-12-3",
              "name": "嫩江县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-12-4",
              "name": "孙吴县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-12-6",
              "name": "逊克县",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-12-5",
              "name": "爱辉区",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        },
        {
          "code": "CN-23-13",
          "name": "齐齐哈尔市",
          "districts": [
            {
              "code": "CN-23-13-1",
              "name": "依安",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-2",
              "name": "克东",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-3",
              "name": "克山",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-4",
              "name": "富拉尔基",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-6",
              "name": "建华",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-7",
              "name": "拜泉",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-8",
              "name": "昂昂溪",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-5",
              "name": "富裕",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-10",
              "name": "泰来",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-11",
              "name": "甘南",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-12",
              "name": "碾子山",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-9",
              "name": "梅里斯",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-14",
              "name": "铁锋",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-15",
              "name": "龙江",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-13",
              "name": "讷河",
              "index": null,
              "city": null
            },
            {
              "code": "CN-23-13-16",
              "name": "龙沙",
              "index": null,
              "city": null
            }
          ],
          "index": null,
          "region": null
        }
      ],
      "index": null
    }
  ];

  RegionModel regionSelect;
  List<CityModel> citySelects = [];
  List<String> cityCodeSelects = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<RegionModel> models = _regions.map((region) {
      return RegionModel.fromJson(region);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('双列选择'),
      ),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ActionChip(
                  label: Text('选择地区'),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, mSetState) {
                          return Container(
                            height: 351,
                            child: Column(
                              children: <Widget>[
                                Card(
                                  elevation: 2,
                                  margin: EdgeInsets.only(bottom: 3),
//                        color: Colors.grey[300],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          mSetState(() {
                                            regionSelect = null;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text('重置'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 15),
                                        child: ActionChip(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(),
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(5)),
                                          ),
                                          label: Text('确定'),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          backgroundColor: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      height: 300,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: ListView(
                                        children: models.map((region) {
                                          return GestureDetector(
                                            onTap: (){
                                              mSetState((){
                                                regionSelect = region;
                                                cityCodeSelects.clear();
                                                citySelects.clear();
                                              });
                                            },
                                            child: Container(
                                              color:  regionSelect != null && regionSelect.isocode == region.isocode ? Colors.white : Colors.grey[350],
                                              height: 30,
                                              width: MediaQuery.of(context).size.width / 2,
                                              child: Center(child: Text(region.name)),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Container(
                                      height: 300,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: ListView(
                                        children: regionSelect == null ? [] : regionSelect.cities.map((city) {
                                          return GestureDetector(
                                            onTap: (){
                                              mSetState((){
                                                if(cityCodeSelects.contains(city.code)){
                                                  cityCodeSelects.remove(city.code);
                                                  citySelects.removeWhere((city1) => city.code == city1.code);
                                                }else{
                                                  citySelects.add(city);
                                                  cityCodeSelects.add(city.code);
                                                }
                                              });
                                            },
                                            child: Container(
                                              color: cityCodeSelects.contains(city.code) ? Colors.white : Colors.grey[300],
                                              height: 30,
                                              width: MediaQuery.of(context).size.width / 2,
                                              child: Center(child: Text(city.name)),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                      },
                    ).then((val) {
                      setState(() {
//                        if (_regionSelects.length > 0) {
//                          widget.item.details.productiveOrientations =
//                              _regionSelects;
//                        } else {
//                          widget.item.details.productiveOrientations = null;
//                        }
                      });
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
