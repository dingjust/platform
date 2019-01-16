import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'orders/quote_order_item.dart';

class QuotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<EnumModel> states = <EnumModel>[
      EnumModel('SELLER_SUBMITTED', '待处理'),
      EnumModel('BUYER_APPROVED', '通过'),
      EnumModel('BUYER_REJECTED', '拒绝'),
      EnumModel('ALL', '全部'),
    ];

    List<QuoteEntryModel> _quoteList = <QuoteEntryModel>[
      QuoteEntryModel(
        order: QuoteModel(
          code: '39492523423',
          state: QuoteState.SELLER_SUBMITTED,
          totalPrice: 54,
          totalQuantity: 554,
          unitPriceOfFabric: 15.00,
          unitPriceOfExcipients: 5.00,
          unitPriceOfProcessing: 15.00,
          costOfSamples: 200.00,
          belongTo: FactoryModel(
            name: '广州旭日',
            starLevel: 3,
            contactAddress: AddressModel(
              region: RegionModel(name: '广东省'),
              city: CityModel(name: '广州市'),
              cityDistrict: DistrictModel(name: '海珠区'),
            ),
            orderedSuccessRate: 0.3455,
            historyOrdersCount: 214,
          ),
          attachments: [
            MediaModel('https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg'),
            MediaModel('https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg'),
            MediaModel('https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg'),
            MediaModel('https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg')
          ],
          creationTime: DateTime.parse('2019-01-03'),
          expectedDeliveryDate: DateTime.parse('2019-01-24'),
          requirementOrderCode: '4513516134451',
        ),
        product: ApparelProductModel(
          name: '山本风少女长裙复古气质秋冬流行新款',
          skuID: 'NA89852631',
          thumbnail:
              'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
          majorCategory: CategoryModel(name: '针织'),
          minorCategory: CategoryModel(name: '女装-T恤'),
        ),
      ),
      QuoteEntryModel(
        order: QuoteModel(
          code: '467627245245',
          state: QuoteState.BUYER_APPROVED,
          totalPrice: 78,
          totalQuantity: 500,
          unitPriceOfFabric: 17.00,
          unitPriceOfExcipients: 7.00,
          unitPriceOfProcessing: 17.00,
          costOfSamples: 222.00,
          requirementOrderCode: '177245246252',
          expectedDeliveryDate: DateTime.parse('2019-01-29'),
          belongTo: FactoryModel(
            name: '广州东升',
            starLevel: 4,
            contactAddress: AddressModel(
              region: RegionModel(name: '广东省'),
              city: CityModel(name: '广州市'),
              cityDistrict: DistrictModel(name: '天河区'),
            ),
            orderedSuccessRate: 0.5555,
            historyOrdersCount: 278,
          ),
          attachments: [
            MediaModel('https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg'),
            MediaModel('https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg'),
            MediaModel('https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg'),
            MediaModel('https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg')
          ],
          creationTime: DateTime.parse('2019-01-06'),
        ),
        product: ApparelProductModel(
//          name: '法式复古裙egg针织毛衣',
//          skuID: 'NA32523552',
//          thumbnail:
//              'http://img.alicdn.com/bao/uploaded/O1CN017h2qoE1X6KmcjQRml_!!595412874.jpg_80x80.jpg',
          majorCategory: CategoryModel(name: '针织'),
          minorCategory: CategoryModel(name: '女装-T恤'),
        ),
      ),
      QuoteEntryModel(
        order: QuoteModel(
          code: '2764246272',
          state: QuoteState.BUYER_REJECTED,
          totalPrice: 66,
          totalQuantity: 444,
          unitPriceOfFabric: 25.00,
          unitPriceOfExcipients: 9.00,
          unitPriceOfProcessing: 22.00,
          costOfSamples: 300.00,
          requirementOrderCode: '461647351343',
          expectedDeliveryDate: DateTime.parse('2019-01-19'),
          belongTo: FactoryModel(
            name: '广州东江',
            starLevel: 5,
            contactAddress: AddressModel(
              region: RegionModel(name: '广东省'),
              city: CityModel(name: '广州市'),
              cityDistrict: DistrictModel(name: '番禺区'),
            ),
            orderedSuccessRate: 0.7716,
            historyOrdersCount: 333,
          ),
          attachments: [
            MediaModel('https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg'),
            MediaModel('https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg'),
            MediaModel('https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg',
                mediaType: 'jpg'),
          ],
          creationTime: DateTime.parse('2019-01-09'),
        ),
        product: ApparelProductModel(
          name: '法式复古裙egg矮个子针织毛衣',
          skuID: 'NA89852631',
          thumbnail:
              'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
          majorCategory: CategoryModel(name: '针织'),
          minorCategory: CategoryModel(name: '女装-T恤'),
        ),
      ),
    ];

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          '报价管理',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: null,
          ),
        ],
      ),
      body: DefaultTabController(
        length: states.length,
        child: Scaffold(
          appBar: TabBar(
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: states.map((state) {
              return Tab(text: state.name);
            }).toList(),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 16,
            ),
          ),
          body: TabBarView(
            children: states.map((state) {
              return Container(
                child: ListView(
                  children: _quoteList.map((quote) {
                    return QuoteOrderItem(item: quote);
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
