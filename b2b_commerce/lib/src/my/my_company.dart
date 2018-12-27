import 'package:b2b_commerce/src/my/company/my_company_form.dart';
import 'package:flutter/material.dart';

/// 认证信息
class MyCompanyPage extends StatefulWidget {
  _MyCompanyPageState createState() => _MyCompanyPageState();
}

class _MyCompanyPageState extends State<MyCompanyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('认证信息'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: '编辑',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCompanyFormPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 20),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'temp/login_logo.png',
                    package: 'assets',
                    width: 60.0,
                    height: 60.0,
                  ),
                  Text(
                    '宁波衣加衣供应链有限公司',
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              )),
          InfoRow('联系人：', '旷小勇', null, '拨打'),
          InfoRow(
              '联系手机：',
              '18238228032',
              IconButton(
                icon: Icon(Icons.phone),
                tooltip: 'Increase volume by 10%',
                onPressed: () {},
                color: Colors.orange,
              ),
              '拨打'),
          InfoRow('地址：', '广州市荔湾区西村原创元素创', null, '拨打'),
          InfoRow(
              '座机号码：',
              '020-999909029',
              IconButton(
                icon: Icon(Icons.phone),
                tooltip: 'Increase volume by 10%',
                onPressed: () {},
                color: Colors.orange,
              ),
              '拨打'),
          InfoRow(
              '邮箱地址：',
              'asdasdjio@qweq.com',
              IconButton(
                icon: Icon(Icons.content_copy),
                tooltip: 'Increase volume by 10%',
                onPressed: () {},
                color: Colors.orange,
              ),
              '复制'),
          Container(
            height: 300.0,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(width: 0.5, color: Colors.black45, style: BorderStyle.solid),
                            bottom: BorderSide(width: 0.5, color: Colors.black45, style: BorderStyle.solid),
                            right: BorderSide(width: 0.5, color: Colors.black45, style: BorderStyle.solid))),
                    child: Column(
                      children: <Widget>[
                        InfoBlock(
                          '品牌',
                          [
                            Text(
                              'KS',
                              style: TextStyle(fontSize: 18.0),
                            )
                          ],
                        ),
                        InfoBlock(
                          '风格',
                          [Tag('潮牌')],
                        ),
                        InfoBlock(
                          '春夏款价格段',
                          [Tag('61-120')],
                        ),
                        InfoBlock(
                          '年龄段',
                          [Tag('18-23')],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 0.5, color: Colors.black45, style: BorderStyle.solid),
                      bottom: BorderSide(width: 0.5, color: Colors.black45, style: BorderStyle.solid),
                    )),
                    child: Column(
                      children: <Widget>[
                        InfoBlock(
                          '合作品牌商',
                          [
                            Text(
                              '森马',
                              style: TextStyle(fontSize: 18.0),
                            )
                          ],
                        ),
                        InfoBlock(
                          '优势品类',
                          [Tag('针织'), Tag('梭织')],
                        ),
                        InfoBlock(
                          '秋冬款价格段',
                          [Tag('121-200'), Tag('201-300')],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
        padding: const EdgeInsets.all(10.0),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  InfoRow(this.label, this.value, this.iconButton, this.buttonText);

  final String label;
  final String value;
  IconButton iconButton;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Row(
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 15.0, color: Colors.black45),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15.0, color: Colors.black87),
          ),
        ],
      )
    ];
    if (iconButton != null) {
      children.add(Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          iconButton,
          Text(
            buttonText,
            style: TextStyle(fontSize: 15.0, color: Colors.orange),
          )
        ],
      ));
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: children,
      ),
      height: 30.0,
    );
  }
}

class Tag extends StatelessWidget {
  const Tag(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
          value,
          style: TextStyle(fontSize: 15.0, color: Colors.black45),
        ),
        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black45),
            borderRadius: BorderRadius.all(Radius.circular(5.0))));
  }
}

class InfoBlock extends StatelessWidget {
  InfoBlock(this.label, this.children);

  final String label;
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 15.0, color: Colors.black45)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          )
        ],
      ),
    );
  }
}
