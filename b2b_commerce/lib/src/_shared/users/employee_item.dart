import 'package:b2b_commerce/src/business/employees/employee_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class EmployeeItem extends StatefulWidget {
  EmployeeItem(this.item);

  B2BCustomerModel item;

  EmployeeItemState createState() => EmployeeItemState();
}

class EmployeeItemState extends State<EmployeeItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      onLongPress: (){
//        ShowDialogUtil.showAlertDialog(context, '是否删除该员工', ()async{
//          String result = await UserRepositoryImpl().employeeDelete(widget.item.id);
//          if(result != null){
//            Navigator.pop(context);
//            ShowDialogUtil.showSnakeBar(context, '删除员工成功');
//            EmployeeBLoC.instance.getB2BCustomerData();
//          }else{
//            Navigator.pop(context);
//            ShowDialogUtil.showSnakeBar(context, '删除员工失败');
//            EmployeeBLoC.instance.getB2BCustomerData();
//          }
//        });
//      },
      child: SizedBox(
        height: 75,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
          ),
          child: ListTile(
            title: Text(
              widget.item.name,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            subtitle: Text(
              widget.item.mobileNumber,
              style: TextStyle(color: Colors.black),
            ),
            trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(formatRoleNames(widget.item.roles)),
                Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                ),
              ],
            ),
            onTap: () async {
              dynamic result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeFormPage(item: widget.item),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  //格式化角色
  String formatRoleNames(List<RoleModel> roles) {
    String text = '';
    if (ClassHandleUtil.isNotEmpty(roles)) {
      text += roles[0].name;
      if (roles.length > 1) {
        text += '、...';
      }
    }
    return text;
  }
}
