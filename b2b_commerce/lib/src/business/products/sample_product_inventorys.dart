/*
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SampleProductInventorysPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    List<SampleProductInventoryModel> _sampleInventoryList = <SampleProductInventoryModel>[
      SampleProductInventoryModel(
        name: '样衣1',
        skuID: 'NA893151351',
        inventoryQuantity: 11,
        totalLendQuantity: 9,
        thumbnail: 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
      ),
      SampleProductInventoryModel(
        name: '样衣2',
        skuID: 'NA893151352',
        inventoryQuantity: 0,
        totalLendQuantity: 10,
        thumbnail: 'http://g.search2.alicdn.com/img/i2/107651422/O1CN0171M0es1MNJhJfITfG_!!0-saturn_solar.jpg_220x220.jpg_.webp',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('样衣库存'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            color: Colors.white,
            child: ListTile(
              onTap: (){

              },
              title: Text('新建样衣'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          Column(
            children: _sampleInventoryList.map((inventory){
              return  Card(
                margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 10),
                elevation: 0,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: inventory.thumbnail != null
                                    ? NetworkImage(inventory.thumbnail)
                                    : AssetImage(
                                  'temp/picture.png',
                                  package: "assets",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          inventory.name,
                                          style: TextStyle(fontSize: 15),
                                          //overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                          inventory.inventoryQuantity > 0 ? '可借出':'不可借出',
                                          style: TextStyle(
                                            color: inventory.inventoryQuantity > 0 ? Colors.orange : Colors.red,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                          )),
                                    ],
                                  ),
                                  Container(
                                    padding:
                                    EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      '货号：' + inventory.skuID,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          '库存数量：' + inventory.inventoryQuantity.toString(),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      Text(
                                        '借出数量：',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        inventory.totalLendQuantity.toString(),
                                        style: TextStyle(color: Colors.orange),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}*/
