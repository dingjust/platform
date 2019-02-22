import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'employees/employee_form.dart';
import 'search/employee_search.dart';

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
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: const Text('员工管理'),
        actions: <Widget>[
          IconButton(
            icon: Icon(B2BIcons.search,size: 20,),
            onPressed: () => showSearch(context: context, delegate: EmployeeSearchDelegate()),
          ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeFormPage(null),
            ),
          );
        },
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
        elevation: 0,
        margin: EdgeInsets.only(top: 5),
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
