import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class FindingFactoryBtnsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildFree(context),
            _buildAuthentication(context),
            _buildFast(context),
            _buildAll(context)
          ],
        ),
      ),
    );
  }

  Widget _buildAll(BuildContext context) {
    return _IconButton(
      icon: Icon(
        B2BIcons.factory_all,
        color: Color.fromRGBO(148, 161, 246, 1.0),
        size: 30,
      ),
      title: '全部工厂',
      onPressed: () async {
        List<CategoryModel> categories =
            await Provider.of<MajorCategoryState>(context).getMajorCategories();
        List<LabelModel> labels =
            await Provider.of<LabelState>(context).getLabels();
        labels = labels
            .where((label) =>
                label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();
//        labels.add(LabelModel(name: '已认证', id: 1000000));
        if (categories != null && labels != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => FactoryPage(
              FactoryCondition(
                  starLevel: 0,
                  adeptAtCategories: [],
                  labels: [],
                  cooperationModes: []),
              route: '全部工厂',
              categories: categories,
              labels: labels,
            ),
          ));
        }
      },
    );
  }

  Widget _buildFree(BuildContext context) {
    return _IconButton(
      icon: Icon(
        B2BIcons.clothes,
        color: Colors.lightBlue,
        size: 30,
      ),
      title: '免费打样',
      onPressed: () async {
        List<CategoryModel> categories =
            await Provider.of<MajorCategoryState>(context).getMajorCategories();
        List<LabelModel> labels =
            await Provider.of<LabelState>(context).getLabels();
        labels = labels
            .where((label) =>
                label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();

        ///筛选标签=>免费打样
        List<LabelModel> conditionlabels =
            labels.where((label) => label.name == '免费打样').toList();
        if (categories != null && labels != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FactoryPage(
                FactoryCondition(
                    starLevel: 0,
                    adeptAtCategories: [],
                    labels: conditionlabels,
                    cooperationModes: []),
                route: '免费打样',
                categories: categories,
                labels: labels,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAuthentication(BuildContext context) {
    return _IconButton(
      icon: Icon(
        B2BIcons.authentication,
        color: Colors.lightGreen,
        size: 30,
      ),
      title: '认证工厂',
      onPressed: () async {
        List<CategoryModel> categories =
            await Provider.of<MajorCategoryState>(context).getMajorCategories();
        List<LabelModel> labels =
            await Provider.of<LabelState>(context).getLabels();
        labels = labels
            .where((label) =>
                label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();

        ///筛选标签=>免费打样
        List<LabelModel> conditionlabels =
            labels.where((label) => label.name == '已认证').toList();
        if (categories != null && labels != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FactoryPage(
                FactoryCondition(
                    starLevel: 0,
                    adeptAtCategories: [],
                    labels: conditionlabels,
                    cooperationModes: []),
                route: '认证工厂',
                categories: categories,
                labels: labels,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildFast(BuildContext context) {
    return _IconButton(
      icon: Icon(
        B2BIcons.thunder,
        color: Color.fromRGBO(212, 35, 122, 1.0),
        size: 30,
      ),
      title: '快反工厂',
      onPressed: () async {
        List<CategoryModel> categories =
            await Provider.of<MajorCategoryState>(context).getMajorCategories();
        List<LabelModel> labels =
            await Provider.of<LabelState>(context).getLabels();
        labels = labels
            .where((label) =>
                label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();

        ///筛选标签=>免费打样
        List<LabelModel> conditionlabels =
            labels.where((label) => label.name == '快反工厂').toList();
        if (categories != null && labels != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FactoryPage(
                FactoryCondition(
                    starLevel: 0,
                    adeptAtCategories: [],
                    labels: conditionlabels,
                    cooperationModes: []),
                route: '快反工厂',
                categories: categories,
                labels: labels,
              ),
            ),
          );
        }
      },
    );
  }
}

class _IconButton extends StatelessWidget {
  @required
  final VoidCallback onPressed;

  @required
  final String title;

  @required
  final Icon icon;

  const _IconButton({Key key, this.onPressed, this.title, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: FlatButton(
        onPressed: onPressed,
        child: Column(
          children: <Widget>[
            Expanded(flex: 1, child: icon),
            Container(
              child: Text(
                '$title',
                overflow: TextOverflow.visible,
                style: TextStyle(fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
