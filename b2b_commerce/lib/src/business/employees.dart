import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'employees/employee_form.dart';

class EmployeesPage extends StatefulWidget {
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final List<B2BCustomerModel> items = <B2BCustomerModel>[
    B2BCustomerModel.fromJson({'uid': 'zhan', 'name': '湛红波', 'mobileNumber': '13556179554'}),
    B2BCustomerModel.fromJson({'uid': 'zhan1', 'name': '湛红波1', 'mobileNumber': '13556179554'})
  ];

  @override
  Widget build(BuildContext context) {
    List<EmployeeItem> _items = items.map((item) {
      return EmployeeItem(item);
    }).toList();

    return new Scaffold(
      appBar: AppBar(
        title: const Text('员工管理'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeFormPage(null),
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return _items[index];
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeItem extends StatelessWidget {
  EmployeeItem(this.item);

  final B2BCustomerModel item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Card(
        child: ListTile(
          title: Text(
            item.name,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20.0,
            ),
          ),
          subtitle: Text(item.mobileNumber),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeFormPage(item),
              ),
            );
          },
        ),
      ),
    );
  }
}
