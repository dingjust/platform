import 'package:b2b_commerce/src/home/pool/search/requirement_pool_search.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class RequirementPoolAll extends StatefulWidget {
  _RequirementPoolAllState createState() => _RequirementPoolAllState();
}

class _RequirementPoolAllState extends State<RequirementPoolAll> {
  bool _isShowCategoryItem = true;
  bool _isShowProcessItem = true;
  bool _isSelectedCategory1 = false;
  bool _isSelectedCategory2 = false;
  bool _isSelectedCategory3 = false;
  bool _isSelectedProcess1 = false;
  bool _isSelectedProcess2 = false;
  bool _isSort = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          '全部需求',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(B2BIcons.search,size: 20,),
            onPressed: () =>
                showSearch(
                    context: context, delegate: RequirementPoolSearch()),
          ),
        ],
        bottom: _buildFilterBar(context),
      ),
      body:ListView(
        children: <Widget>[
          _buildFilterCategoryItem(context),
          _buildFilterProcessItem(context),
          _buildRequirementOrderItem(context),
          _buildRequirementOrderItem(context),
          _buildRequirementOrderItem(context),
          _buildRequirementOrderItem(context),
        ],
      ),
    );
  }


  Widget _buildRequirementOrderItem(BuildContext context){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
        // margin: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: NetworkImage('https://gd3.alicdn.com/imgextra/i2/0/TB194socYrpK1RjSZTEXXcWAVXa_!!0-item_pic.jpg'),
                    fit: BoxFit.cover,
                  )),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 5),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      '男装-羽绒服',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                        '500件',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xffFF9516),
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 5),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    '￥',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    '500',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ],
                              )
                            )
                          ],
                        )
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '交货日期： 2019-01-01',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 80,
                            child: FlatButton(
                              onPressed: () {},
                              color: Colors.orange,
                              child: Text(
                                '去报价',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              shape:
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 25,
                          height: 25,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                'http://www.pptbz.com/pptpic/UploadFiles_6909/201203/2012031220134655.jpg'
                            ),
                            radius: 50.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            '森马服装',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              '已认证',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.deepOrange
                              ),
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Colors.grey[300], width: 0.6))),
      ),
    );
  }


  Widget _buildFilterCategoryItem(BuildContext context){
    return Offstage(
        offstage: _isShowCategoryItem,
        child:Container(
          margin: EdgeInsets.only(bottom: 20),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: ListTile(
                  title: Text(
                    '针织',
                    style: TextStyle(
                      color: _isSelectedCategory1 == true ? Color.fromRGBO(255, 149, 22, 1):Colors.black
                    ),
                  ),
                  trailing: _isSelectedCategory1 == true ? Icon(Icons.check,color: Color.fromRGBO(255, 149, 22, 1),) : null,
                ),
                onTap: () {
                  setState(() {
                    _isSelectedCategory1 = !_isSelectedCategory1;
//                    _isShowCategoryItem = !_isShowCategoryItem;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
              GestureDetector(
                child: ListTile(
                  title: Text(
                    '梭织',
                    style: TextStyle(
                        color: _isSelectedCategory2 == true ? Color.fromRGBO(255, 149, 22, 1):Colors.black
                    ),
                  ),
                  trailing: _isSelectedCategory2 == true ? Icon(Icons.check,color: Color.fromRGBO(255, 149, 22, 1)) : null,
                ),
                onTap: () {
                  setState(() {
                    _isSelectedCategory2 = !_isSelectedCategory2;
//                    _isShowCategoryItem = !_isShowCategoryItem;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
              GestureDetector(
                child: ListTile(
                  title: Text(
                    '尼龙',
                    style: TextStyle(
                        color: _isSelectedCategory3 == true ? Color.fromRGBO(255, 149, 22, 1):Colors.black
                    ),
                  ),
                  trailing: _isSelectedCategory3 == true ? Icon(Icons.check,color: Color.fromRGBO(255, 149, 22, 1)) : null,
                ),
                onTap: () {
                  setState(() {
                    _isSelectedCategory3 = !_isSelectedCategory3;
//                    _isShowCategoryItem = !_isShowCategoryItem;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
            ],
          ),
        )
    );
  }


  Widget _buildFilterProcessItem(BuildContext context){
    return Offstage(
        offstage: _isShowProcessItem,
        child:Container(
          margin: EdgeInsets.only(bottom: 20),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: ListTile(
                  title: Text(
                    '轻加工',
                    style: TextStyle(
                        color: _isSelectedProcess1 == true ? Color.fromRGBO(255, 149, 22, 1):Colors.black
                    ),
                  ),
                  trailing: _isSelectedProcess1 == true ? Icon(Icons.check,color: Color.fromRGBO(255, 149, 22, 1)) : null,
                ),
                onTap: () {
                  setState(() {
                    _isSelectedProcess1 = !_isSelectedProcess1;
//                    _isShowProcessItem = !_isShowProcessItem;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
              GestureDetector(
                child: ListTile(
                  title: Text(
                    '包工包料',
                    style: TextStyle(
                        color: _isSelectedProcess2 == true ? Color.fromRGBO(255, 149, 22, 1):Colors.black
                    ),
                  ),
                  trailing: _isSelectedProcess2 == true ? Icon(Icons.check,color: Color.fromRGBO(255, 149, 22, 1)) : null,
                ),
                onTap: () {
                  setState(() {
                    _isSelectedProcess2 = !_isSelectedProcess2;
//                    _isShowProcessItem = !_isShowProcessItem;
                  });
                },
              ),
              Divider(
                height: 1,
              ),
            ],
          ),
        )
    );
  }



  Widget _buildFilterBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(35, 40),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
                  height: 30,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 118,
                        child: FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '最新发布',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                                Icon(_isSort==true?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down)
                              ],
                            ),
                          onPressed: (){
                            setState(() {
                              _isSort = !_isSort;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 118,
                        child: FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '加工方式',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                          onPressed: (){
                            setState(() {
                              _isShowProcessItem = !_isShowProcessItem;
                              _isShowCategoryItem = true;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 118,
                        child: FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '商品大类',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              ],
                            ),
                          onPressed: (){
                            setState(() {
                              _isShowProcessItem = true;
                              _isShowCategoryItem = !_isShowCategoryItem;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )),
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),
    );
  }

}