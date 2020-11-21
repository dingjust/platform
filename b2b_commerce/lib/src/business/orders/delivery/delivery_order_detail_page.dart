import 'package:b2b_commerce/src/business/cooperator/cooperator_item.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/out_order/form/form_components.dart';
import 'package:flutter/material.dart';

import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class DeliveryOrderDetailPage extends StatefulWidget {
  final int id;

  const DeliveryOrderDetailPage({Key key, this.id}) : super(key: key);

  @override
  _DeliveryOrderDetailPageState createState() =>
      _DeliveryOrderDetailPageState();
}

class _DeliveryOrderDetailPageState extends State<DeliveryOrderDetailPage> {
  FastShippingSheetModel order;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FastShippingSheetModel>(
      builder: (BuildContext context,
          AsyncSnapshot<FastShippingSheetModel> snapshot) {
        if (snapshot.data != null && order != null) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('出货单详情'),
              backgroundColor: Constants.THEME_COLOR_MAIN,
              elevation: 0.5,
            ),
            body: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: ListView(
                children: <Widget>[
                  CooperatorItem(
                    model: order.cooperator,
                  ),
                  _medias()
                ],
              ),
            ),
            resizeToAvoidBottomPadding: true,
          );
        } else {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      initialData: null,
      future: _getData(),
    );
  }

  Widget _medias() {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [FormLabel('单据：')],
              ),
            ),
            Row(
              children: [Expanded(child: Attachments(list: order.medias))],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [FormLabel('备注：')],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    '${order.remarks ?? ''}',
                  ))
                ],
              ),
            ),
          ],
        ));
  }

  /// 查询明细
  Future<FastShippingSheetModel> _getData() async {
    if (order == null) {
      // FastShippingSheetModel detailModel =
      //     await ExternalSaleOrderRespository().getOrderDetail(widget.id);
      order = FastShippingSheetModel.fromJson(val);
    }
    return order;
  }
}

const val = {
  "id": 8811314577438,
  "code": "DWWQ1000001",
  "medias": [
    {
      "id": 8811314577438,
      "name": "微信图片_20200604184853.jpg",
      "url": "/resource/h5b/h98/8811314610206.jpg",
      "mediaType": "image/jpeg",
      "mime": "image/jpeg",
      "mediaFormat": "DefaultImageFormat",
      "convertedMedias": []
    },
    {
      "id": 8814664908830,
      "name": "8800385957918.jpg",
      "url": "/resource/hbb/h09/8814664941598.jpg",
      "mediaType": "image/jpeg",
      "mime": "image/jpeg",
      "mediaFormat": "DefaultImageFormat",
      "convertedMedias": []
    },
    {
      "id": 8814664974366,
      "name": "8796473786398.png",
      "url": "/resource/h32/h73/8814665007134.png",
      "mediaType": "image/png",
      "mime": "image/png",
      "mediaFormat": "DefaultImageFormat",
      "convertedMedias": []
    }
  ],
  "cooperator": {
    "id": 8796650175806,
    "creationtime": 1598636864000,
    "modifiedtime": 1598636864000,
    "name": "宁波衣加衣供应链管理有限公司",
    "contactPerson": "王五",
    "contactPhone": "12345678910",
    "partner": {
      "uid": "GC00000001",
      "name": "宁波衣加衣供应链管能有限公司",
      "id": 8796158656517,
      "creationTime": 1554951975124,
      "modifiedTime": 1605858927000,
      "approvalStatus": "approved",
      "taxNumber": "",
      "bankOfDeposit": "",
      "phone": "",
      "email": "admin@dingjust.com",
      "contactPhone": "18659588963",
      "contactPerson": "刘先生",
      "contactAddress": {
        "id": 8798059134999,
        "creationtime": 1596279210000,
        "modifiedtime": 1596279210000,
        "region": {
          "isocode": "CN-44",
          "isocodeShort": "44",
          "countryIso": "CN",
          "name": "广东省",
          "cities": null,
          "index": null
        },
        "city": {
          "code": "CN-44-5",
          "name": "广州市",
          "districts": null,
          "index": null,
          "region": null
        },
        "cityDistrict": {
          "code": "CN-44-5-5",
          "name": "海珠区",
          "index": null,
          "city": null
        },
        "line1": "广州大道南252号云顶同创汇C03",
        "details": "广东省广州市海珠区广州大道南252号云顶同创汇C03"
      },
      "cooperativeBrand": "森马，爱居兔，如涵，NoMe，",
      "certificates": [
        {
          "id": 8810624319518,
          "name": "temp62618648577936352609568faabf58443538544354cb9208bad.png",
          "url": "/resource/h63/h12/8810624352286.png",
          "mediaType": "image/png",
          "mime": "image/png",
          "mediaFormat": "DefaultImageFormat",
          "convertedMedias": []
        },
        {
          "id": 8810624319518,
          "name": "temp62618648577936352609568faabf58443538544354cb9208bad.png",
          "url": "/resource/h63/h12/8810624352286.png",
          "mediaType": "image/png",
          "mime": "image/png",
          "mediaFormat": "DefaultImageFormat",
          "convertedMedias": []
        },
        {
          "id": 8810624319518,
          "name": "temp62618648577936352609568faabf58443538544354cb9208bad.png",
          "url": "/resource/h63/h12/8810624352286.png",
          "mediaType": "image/png",
          "mime": "image/png",
          "mediaFormat": "DefaultImageFormat",
          "convertedMedias": []
        },
        {
          "id": 8814561493022,
          "name": "temp404197893648152074699be41af7ca44cd08496ef1180780218.png",
          "url": "/resource/h46/hba/8814561525790.png",
          "mediaType": "image/png",
          "mime": "image/png",
          "mediaFormat": "DefaultImageFormat",
          "convertedMedias": []
        }
      ],
      "starLevel": 0,
      "profilePicture": {
        "id": 8812136333342,
        "name": "8437ec34f4e9a629.jpg",
        "url": "/resource/h23/h6c/8812136366110.jpg",
        "mediaType": "image/jpeg",
        "mime": "image/jpeg",
        "mediaFormat": "DefaultImageFormat",
        "convertedMedias": []
      },
      "businessRegistrationNo": "91330201MA2CJBWF1P",
      "legalRepresentative": "",
      "certificateOfLegal": "",
      "profiles": [
        {
          "id": 8796420766016,
          "creationtime": 1564972451462,
          "modifiedtime": 1564972451546,
          "statistics": null,
          "medias": [],
          "description": ""
        },
        {
          "id": 8796420798784,
          "creationtime": 1564972451472,
          "modifiedtime": 1564972451548,
          "statistics": null,
          "medias": [],
          "description": ""
        },
        {
          "id": 8796420831552,
          "creationtime": 1564972451481,
          "modifiedtime": 1564972451549,
          "statistics": null,
          "medias": [],
          "description": ""
        }
      ],
      "labels": [
        {
          "id": 8796125918552,
          "name": "优选工厂",
          "group": "PLATFORM",
          "clusters": null
        }
      ],
      "longitude": 113.317388,
      "latitude": 23.083801,
      "locationAddress": "广东省广州市海珠区",
      "duties": "经理",
      "contactUid": "15888888888",
      "active": true,
      "categories": [
        {
          "id": 8796095185038,
          "code": "DL0003",
          "name": "皮草",
          "description": "皮草",
          "thumbnail": {
            "id": 8810397990942,
            "name": "8800387923998.jpg",
            "url": "/resource/h46/hfe/8810398023710.jpg",
            "mediaType": "image/jpeg",
            "mime": "image/jpeg",
            "mediaFormat": "DefaultImageFormat",
            "convertedMedias": []
          },
          "parent": {
            "id": 8796093055118,
            "code": "majorCategories",
            "name": "大类"
          }
        },
        {
          "id": 8796158591118,
          "code": "DL0006",
          "name": "毛织",
          "description": "毛织",
          "thumbnail": {
            "id": 8810398122014,
            "name": "8800385957918.jpg",
            "url": "/resource/had/hb7/8810398154782.jpg",
            "mediaType": "image/jpeg",
            "mime": "image/jpeg",
            "mediaFormat": "DefaultImageFormat",
            "convertedMedias": []
          },
          "parent": {
            "id": 8796093055118,
            "code": "majorCategories",
            "name": "大类"
          }
        },
        {
          "id": 8796095152270,
          "code": "DL0002",
          "name": "梭织",
          "description": "梭织",
          "thumbnail": {
            "id": 8810397925406,
            "name": "8800385957918.jpg",
            "url": "/resource/h2d/h24/8810397958174.jpg",
            "mediaType": "image/jpeg",
            "mime": "image/jpeg",
            "mediaFormat": "DefaultImageFormat",
            "convertedMedias": []
          },
          "parent": {
            "id": 8796093055118,
            "code": "majorCategories",
            "name": "大类"
          }
        },
        {
          "id": 8796095250574,
          "code": "DL0005",
          "name": "其他",
          "description": "其他",
          "thumbnail": {
            "id": 8810398056478,
            "name": "8800387923998.jpg",
            "url": "/resource/hf1/hc9/8810398089246.jpg",
            "mediaType": "image/jpeg",
            "mime": "image/jpeg",
            "mediaFormat": "DefaultImageFormat",
            "convertedMedias": []
          },
          "parent": {
            "id": 8796093055118,
            "code": "majorCategories",
            "name": "大类"
          }
        },
        {
          "id": 8796095217806,
          "code": "DL0004",
          "name": "牛仔",
          "description": "牛仔",
          "thumbnail": {
            "id": 8810399432734,
            "name": "8800387923998.jpg",
            "url": "/resource/hc6/hca/8810399465502.jpg",
            "mediaType": "image/jpeg",
            "mime": "image/jpeg",
            "mediaFormat": "DefaultImageFormat",
            "convertedMedias": []
          },
          "parent": {
            "id": 8796093055118,
            "code": "majorCategories",
            "name": "大类"
          }
        },
        {
          "id": 8796095119502,
          "code": "DL0001",
          "name": "针织",
          "description": "针织",
          "thumbnail": {
            "id": 8810397728798,
            "name": "8800387923998.jpg",
            "url": "/resource/hbe/h8e/8810397761566.jpg",
            "mediaType": "image/jpeg",
            "mime": "image/jpeg",
            "mediaFormat": "DefaultImageFormat",
            "convertedMedias": []
          },
          "parent": {
            "id": 8796093055118,
            "code": "majorCategories",
            "name": "大类"
          }
        }
      ],
      "adeptAtCategories": [
        {
          "id": 8796093579406,
          "code": "M0113",
          "name": "棉衣",
          "description": "棉衣",
          "thumbnail": {
            "id": 8796472311838,
            "name": null,
            "url": "/resource/hfa/h29/8796472442910.png",
            "mediaType": "image/png",
            "mime": "image/png",
            "mediaFormat": null,
            "convertedMedias": []
          },
          "parent": {"id": 8796093153422, "code": "M01", "name": "男装"}
        }
      ],
      "scaleRange": "SR005",
      "monthlyCapacityRange": "MCR004",
      "developmentCapacity": false,
      "cooperationModes": ["LIGHT_PROCESSING", "LABOR_AND_MATERIAL"],
      "historyOrdersCount": 1,
      "populationScale": "N04",
      "infoScore": 85,
      "keyword": "",
      "qualityLevels": ["STALL_WHOLESALE", "REGIONAL_CHAIN"],
      "productionMode": "SINGLE_PIECE_PRODUCTION_LINE",
      "cuttingDepartment": [
        "MANUAL_BED_CUTTING",
        "FULLY_AUTOMATIC_BROACHING_MACHINE"
      ],
      "proprietaryProducts": 9,
      "capacities": [
        {
          "id": 8796093086029,
          "creationtime": 1578275581213,
          "modifiedtime": 1579071489340,
          "statistics": null,
          "code": "c8845c82-1e6f-48a2-8fa3-75de5806b24f",
          "title": "针织厂空闲时间",
          "lastRefreshTime": 1579071489338,
          "dateStartPoint": null,
          "dateEndPoint": null,
          "enabled": true,
          "clickTimes": 0,
          "showTimes": 0,
          "todayRefreshedTimes": 0,
          "remainRefreshTimes": 2,
          "belongTo": {
            "uid": "GC00000001",
            "name": "宁波衣加衣供应链管能有限公司",
            "id": 8796158656517,
            "creationTime": 1554951975124,
            "modifiedTime": 1605858927000,
            "approvalStatus": "approved",
            "cooperativeBrand": "森马，爱居兔，如涵，NoMe，",
            "starLevel": 0,
            "profilePicture": {
              "id": 8812136333342,
              "name": "8437ec34f4e9a629.jpg",
              "url": "/resource/h23/h6c/8812136366110.jpg",
              "mediaType": "image/jpeg",
              "mime": "image/jpeg",
              "mediaFormat": "DefaultImageFormat",
              "convertedMedias": []
            },
            "labels": [
              {
                "id": 8796125918552,
                "name": "优选工厂",
                "group": "PLATFORM",
                "clusters": null
              }
            ],
            "longitude": 113.317388,
            "latitude": 23.083801,
            "locationAddress": "广东省广州市海珠区"
          },
          "longTerm": true,
          "totalRefreshTimes": 0,
          "categoryCapacities": [
            {
              "id": 8796093086030,
              "creationtime": 1578275581231,
              "modifiedtime": 1578275581257,
              "statistics": null,
              "category": {
                "id": 8796094365838,
                "code": "W0108",
                "name": "线衫",
                "description": "线衫",
                "thumbnail": {
                  "id": 8796473688094,
                  "name": null,
                  "url": "/resource/he6/ha9/8796473851934.png",
                  "mediaType": "image/png",
                  "mime": "image/png",
                  "mediaFormat": null,
                  "convertedMedias": []
                },
                "parent": {"id": 8796094103694, "code": "W01", "name": "女装"}
              },
              "capacityRange": 500,
              "sort": 1,
              "categoryName": "线衫"
            },
            {
              "id": 8796093118798,
              "creationtime": 1578275581237,
              "modifiedtime": 1578276104900,
              "statistics": null,
              "category": {
                "id": 8796094398606,
                "code": "W0109",
                "name": "毛衣",
                "description": "毛衣",
                "thumbnail": {
                  "id": 8810398187550,
                  "name": "8796473786398.png",
                  "url": "/resource/hd5/hb9/8810398220318.png",
                  "mediaType": "image/png",
                  "mime": "image/png",
                  "mediaFormat": "DefaultImageFormat",
                  "convertedMedias": []
                },
                "parent": {"id": 8796094103694, "code": "W01", "name": "女装"}
              },
              "capacityRange": 500,
              "sort": 2,
              "categoryName": "毛衣"
            }
          ]
        },
        {
          "id": 8796125854029,
          "creationtime": 1578390677611,
          "modifiedtime": 1579071463333,
          "statistics": null,
          "code": "7cffc3f5-a184-4e2f-b3cd-117b415aae67",
          "title": "针织工厂有空挡",
          "lastRefreshTime": 1579071463331,
          "dateStartPoint": null,
          "dateEndPoint": null,
          "enabled": true,
          "clickTimes": 0,
          "showTimes": 0,
          "todayRefreshedTimes": 0,
          "remainRefreshTimes": 2,
          "belongTo": {
            "uid": "GC00000001",
            "name": "宁波衣加衣供应链管能有限公司",
            "id": 8796158656517,
            "creationTime": 1554951975124,
            "modifiedTime": 1605858927000,
            "approvalStatus": "approved",
            "cooperativeBrand": "森马，爱居兔，如涵，NoMe，",
            "starLevel": 0,
            "profilePicture": {
              "id": 8812136333342,
              "name": "8437ec34f4e9a629.jpg",
              "url": "/resource/h23/h6c/8812136366110.jpg",
              "mediaType": "image/jpeg",
              "mime": "image/jpeg",
              "mediaFormat": "DefaultImageFormat",
              "convertedMedias": []
            },
            "labels": [
              {
                "id": 8796125918552,
                "name": "优选工厂",
                "group": "PLATFORM",
                "clusters": null
              }
            ],
            "longitude": 113.317388,
            "latitude": 23.083801,
            "locationAddress": "广东省广州市海珠区"
          },
          "longTerm": true,
          "totalRefreshTimes": 0,
          "categoryCapacities": [
            {
              "id": 8796125854030,
              "creationtime": 1578390677672,
              "modifiedtime": 1578390677687,
              "statistics": null,
              "category": {
                "id": 8796094398606,
                "code": "W0109",
                "name": "毛衣",
                "description": "毛衣",
                "thumbnail": {
                  "id": 8810398187550,
                  "name": "8796473786398.png",
                  "url": "/resource/hd5/hb9/8810398220318.png",
                  "mediaType": "image/png",
                  "mime": "image/png",
                  "mediaFormat": "DefaultImageFormat",
                  "convertedMedias": []
                },
                "parent": {"id": 8796094103694, "code": "W01", "name": "女装"}
              },
              "capacityRange": 100,
              "sort": 1,
              "categoryName": "毛衣"
            }
          ]
        },
        {
          "id": 8796125919565,
          "creationtime": 1578451372606,
          "modifiedtime": 1579068815220,
          "statistics": null,
          "code": "c4d81e68-98b2-4940-8f04-eea1104180be",
          "title": "专业女装工厂",
          "lastRefreshTime": 1579068815218,
          "dateStartPoint": 1585670400000,
          "dateEndPoint": 1588176000000,
          "enabled": true,
          "clickTimes": 0,
          "showTimes": 0,
          "todayRefreshedTimes": 0,
          "remainRefreshTimes": 2,
          "belongTo": {
            "uid": "GC00000001",
            "name": "宁波衣加衣供应链管能有限公司",
            "id": 8796158656517,
            "creationTime": 1554951975124,
            "modifiedTime": 1605858927000,
            "approvalStatus": "approved",
            "cooperativeBrand": "森马，爱居兔，如涵，NoMe，",
            "starLevel": 0,
            "profilePicture": {
              "id": 8812136333342,
              "name": "8437ec34f4e9a629.jpg",
              "url": "/resource/h23/h6c/8812136366110.jpg",
              "mediaType": "image/jpeg",
              "mime": "image/jpeg",
              "mediaFormat": "DefaultImageFormat",
              "convertedMedias": []
            },
            "labels": [
              {
                "id": 8796125918552,
                "name": "优选工厂",
                "group": "PLATFORM",
                "clusters": null
              }
            ],
            "longitude": 113.317388,
            "latitude": 23.083801,
            "locationAddress": "广东省广州市海珠区"
          },
          "longTerm": false,
          "totalRefreshTimes": 0,
          "categoryCapacities": [
            {
              "id": 8796125985102,
              "creationtime": 1578451372612,
              "modifiedtime": 1578451372626,
              "statistics": null,
              "category": {
                "id": 8796094759054,
                "code": "W0120",
                "name": "连衣裙",
                "description": "连衣裙",
                "thumbnail": {
                  "id": 8796474441758,
                  "name": null,
                  "url": "/resource/h4c/he0/8796474540062.png",
                  "mediaType": "image/png",
                  "mime": "image/png",
                  "mediaFormat": null,
                  "convertedMedias": []
                },
                "parent": {"id": 8796094103694, "code": "W01", "name": "女装"}
              },
              "capacityRange": 1000,
              "sort": 1,
              "categoryName": "连衣裙"
            },
            {
              "id": 8796126017870,
              "creationtime": 1578451372614,
              "modifiedtime": 1578451372628,
              "statistics": null,
              "category": {
                "id": 8796094791822,
                "code": "W0121",
                "name": "半截裙",
                "description": "半截裙",
                "thumbnail": {
                  "id": 8796474605598,
                  "name": null,
                  "url": "/resource/h94/h4e/8796474671134.png",
                  "mediaType": "image/png",
                  "mime": "image/png",
                  "mediaFormat": null,
                  "convertedMedias": []
                },
                "parent": {"id": 8796094103694, "code": "W01", "name": "女装"}
              },
              "capacityRange": 1000,
              "sort": 2,
              "categoryName": "半截裙"
            },
            {
              "id": 8796126050638,
              "creationtime": 1578451372616,
              "modifiedtime": 1578451372631,
              "statistics": null,
              "category": {
                "id": 8796094136462,
                "code": "W0101",
                "name": "打底衫",
                "description": "打底衫",
                "thumbnail": {
                  "id": 8796473327646,
                  "name": null,
                  "url": "/resource/h57/hcf/8796473393182.png",
                  "mediaType": "image/png",
                  "mime": "image/png",
                  "mediaFormat": null,
                  "convertedMedias": []
                },
                "parent": {"id": 8796094103694, "code": "W01", "name": "女装"}
              },
              "capacityRange": 1000,
              "sort": 3,
              "categoryName": "打底衫"
            }
          ]
        }
      ]
    },
    "type": "ONLINE",
    "category": "SUPPLIER",
    "detailedIdentity": "",
    "bankOfDeposit": "",
    "bankAccount": "",
    "taxNumber": "",
    "accountName": "",
    "address": {
      "id": 8798288642071,
      "creationtime": 1598636864000,
      "modifiedtime": 1598636864000,
      "region": {
        "isocode": "CN-31",
        "isocodeShort": "31",
        "countryIso": "CN",
        "name": "上海市",
        "cities": null,
        "index": null
      },
      "city": {
        "code": "CN-31-1",
        "name": "上海市",
        "districts": null,
        "index": null,
        "region": null
      },
      "cityDistrict": {
        "code": "CN-31-1-1",
        "name": "南汇区",
        "index": null,
        "city": null
      },
      "line1": "前进大路1号",
      "details": "上海市上海市南汇区前进大路1号"
    },
    "remarks": ""
  },
};
