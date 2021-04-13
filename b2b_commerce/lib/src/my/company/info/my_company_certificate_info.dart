import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';
import 'package:models/models.dart';

class MyCompanyCertificateInfo extends StatefulWidget {
  CompanyModel company;
  bool onlyRead;

  MyCompanyCertificateInfo(
    this.company, {
    this.onlyRead = false,
    Key key,
  }) : super(key: key);

  MyCompanyCertificateInfoState createState() =>
      MyCompanyCertificateInfoState();
}

class MyCompanyCertificateInfoState extends State<MyCompanyCertificateInfo> {
  final double TITLE_WIDTH = 90;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: _buildCertificateInfo(),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          color: Colors.white,
          child: _buildMedias(),
        )
      ],
    );
  }

  Column _buildCertificateInfo() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: <Widget>[
              Text('企业信息',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: TITLE_WIDTH,
                child: Text(
                  '公司名称',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  widget.company.name ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: TITLE_WIDTH,
                child: Text(
                  '信用代码',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  widget.company.businessRegistrationNo ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: TITLE_WIDTH,
                child: Text(
                  '法人',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  widget.company.legalRepresentative ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildMedias() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: <Widget>[
                Text('附件',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 20,
                ),
                Text(
                  '点击图片查看大图',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 15),
            child: Attachments(list: widget.company.certificates),
          )
        ],
      ),
    );
  }
}
