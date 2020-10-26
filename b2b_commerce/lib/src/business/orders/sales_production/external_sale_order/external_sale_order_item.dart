import 'package:core/core.dart';
import 'package:flutter/material.dart';

///外接订单块
class ExternalSaleOrderItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: <Widget>[_Header(), _Row1(), _Row2(), _End()],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {
        // Navigator.of(itemContext).push(
        //   MaterialPageRoute(
        //       builder: (context) => SaleOrderDetailPage(
        //             code: widget.model.code,
        //             callback: () {
        //               //回调刷新State
        //               Provider.of<SaleOrdersState>(itemContext).clear();
        //             },
        //           )),
        // );
      },
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            '单号：SO00000001',
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
              border: Border.all(color: Color.fromRGBO(103, 194, 58, 1))),
          child: Center(
            child: Text(
              '线上',
              style: TextStyle(
                  color: Color.fromRGBO(103, 194, 58, 1), fontSize: 10),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '待接单',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFFFD600),
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}

class _Row1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.only(right: 5),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://img13.360buyimg.com/jdcms/s150x150_jfs/t1/124452/23/15961/228167/5f92a3dbEea4f45ef/9a708b638748e18a.jpg.webp'),
            radius: 20,
          ),
        ),
        Expanded(
            child: Text(
          '宁波衣加衣供应链管理有限公司',
          overflow: TextOverflow.ellipsis,
        )),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Center(
            child: Text(
              '未签合同',
              style: TextStyle(color: Colors.black54, fontSize: 10),
            ),
          ),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 0.5),
              color: Colors.grey[200]),
        )
      ],
    );
  }
}

class _Row2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('合作方式：包公包料'),
        Text(
          '创建时间：${DateFormatUtil.formatYMD(DateTime.now())}',
          style: TextStyle(fontSize: 14),
        )
      ],
    );
  }
}

class _End extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 3,
            child: RichText(
                text: TextSpan(
                    text: '产品数：',
                    style: TextStyle(color: Colors.black87),
                    children: [
                  TextSpan(
                      text: '3',
                      style: TextStyle(color: Color.fromRGBO(255, 102, 102, 1)))
                ]))),
        Expanded(
            flex: 4,
            child: RichText(
                text: TextSpan(
                    text: '订单数量：',
                    style: TextStyle(color: Colors.black87),
                    children: [
                  TextSpan(
                      text: '300',
                      style: TextStyle(color: Color.fromRGBO(255, 102, 102, 1)))
                ]))),
        Expanded(
            flex: 6,
            child: RichText(
                text: TextSpan(
                    text: '订单金额：',
                    style: TextStyle(color: Colors.black87),
                    children: [
                  TextSpan(
                      text: '￥1300.0',
                      style: TextStyle(color: Color.fromRGBO(255, 102, 102, 1)))
                ]))),
      ],
    );
  }
}
