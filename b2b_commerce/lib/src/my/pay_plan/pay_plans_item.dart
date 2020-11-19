import 'package:flutter/material.dart';
import 'package:models/models.dart';

class PayPlanItem extends StatelessWidget {
  final CompanyPayPlanModel model;

  final ValueChanged<CompanyPayPlanModel> onItemTap;

  final isSelected;

  const PayPlanItem(
      {Key key, this.model, this.isSelected = false, this.onItemTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        child: Material(
          color: isSelected ? Color.fromRGBO(255, 214, 12, 0.2) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
              onTap: () => onTap(context),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_buildRow1(), _buildRow2(), _buildRow3()],
                  ))),
        ));
  }

  Widget _buildRow1() {
    return Row(
      children: [
        Expanded(
            child: Text(
          '${model.name}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xff263238),
              fontSize: 18),
        ))
      ],
    );
  }

  Widget _buildRow2() {
    TextStyle textStyle = TextStyle(color: Colors.grey, fontSize: 16);

    return Row(
      children: [
        Expanded(
          child: Text(
            '联系人：',
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),
        Expanded(
            flex: 2,
            child: Text(
              '联系方式：',
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ))
      ],
    );
  }

  Widget _buildRow3() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Row(
          children: [
            Text('类型：',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: Color(0xff448aff)),
              ),
              child: Text(
                '',
                overflow: TextOverflow.ellipsis,
                // style: textStyle,
              ),
            )
          ],
        )),
        // _buildTag()
      ],
    );
  }

  // Widget _buildTag() {
  //   bool certified = model.partner != null &&
  //       model.partner.approvalStatus == ArticleApprovalStatus.approved;

  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 10),
  //     child: Center(
  //       child: Text(
  //         certified ? '已认证' : '未认证',
  //         style: TextStyle(
  //             color:
  //                 certified ? Color.fromRGBO(103, 194, 58, 1) : Colors.black54,
  //             fontSize: 16),
  //       ),
  //     ),
  //     decoration: BoxDecoration(
  //         border: Border.all(
  //             color: certified
  //                 ? Color.fromRGBO(225, 243, 216, 1)
  //                 : Colors.grey[200],
  //             width: 0.5),
  //         color:
  //             certified ? Color.fromRGBO(240, 249, 235, 1) : Colors.grey[200]),
  //   );
  // }

  void onTap(BuildContext context) async {
    //有点击事件调用
    if (onItemTap != null) {
      onItemTap.call(model);
    } else {
      // 没有则跳转详情页
      //TODO:命名路由详情跳转
    }
  }
}
