import 'package:flutter/material.dart';

class ApparelProductPricesInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('商品价格'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ApparelProductPricesInput(),
      ),
    );
  }
}

class ApparelProductPricesInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      ListTile(
        title: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: '供货价',
            hintText: '请输入供货价，必填',
          ),
        ),
      ),
      ListTile(
        title: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: '建议零售价',
            hintText: '请输入建议零售价，必填',
          ),
        ),
      ),
      ListTile(
        title: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: '会员价（A）',
            hintText: '请输入，必填',
          ),
        ),
      ),
      ListTile(
        title: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: '会员价（B）',
            hintText: '请输入，必填',
          ),
        ),
      ),
      ListTile(
        title: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: '会员价（C）',
            hintText: '请输入，必填',
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            children: <Widget>[
              Text('阶梯价'),
              StaircasePricesInput(),
              StaircasePricesInput(),
              StaircasePricesInput(),
            ],
          ),
        ),
      ),
    ]);
  }
}

class StaircasePricesInput extends StatelessWidget {
  StaircasePricesInput();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '起订量',
                  ),
                ),
              ),
              Text('以上，价格：'),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '价格',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
