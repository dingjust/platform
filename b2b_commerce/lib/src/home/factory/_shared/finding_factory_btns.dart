import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../factory_page.dart';

class FindingFactoryBtnsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildAll(context),
          _buildFree(context),
          _buildAuthentication(context),
          _buildFast(context),
        ],
      ),
    );
  }

  Widget _buildAll(BuildContext context) {
    return _IconButton(
      icon: B2BV2Image.factory_1(width: 28, height: 28),
      title: '全部工厂',
      onPressed: () async {
        List<CategoryModel> categories =
            await Provider.of<MajorCategoryState>(context, listen: false)
                .getMajorCategories();
        List<LabelModel> labels =
            await Provider.of<LabelState>(context, listen: false).getLabels();
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
      icon: B2BV2Image.factory_2(width: 28, height: 28),
      title: '免费打样',
      onPressed: () async {
        List<CategoryModel> categories =
        await Provider.of<MajorCategoryState>(context, listen: false)
            .getMajorCategories();
        List<LabelModel> labels =
        await Provider.of<LabelState>(context, listen: false).getLabels();
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
              builder: (context) =>
                  FactoryPage(
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
      icon: B2BV2Image.factory_4(width: 28, height: 28),
      title: '认证工厂',
      onPressed: () async {
        List<CategoryModel> categories =
        await Provider.of<MajorCategoryState>(context, listen: false)
            .getMajorCategories();
        List<LabelModel> labels =
        await Provider.of<LabelState>(context, listen: false).getLabels();
        labels = labels
            .where((label) =>
        label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();

        if (categories != null && labels != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FactoryPage(
                    FactoryCondition(
                        starLevel: 0,
                        adeptAtCategories: [],
                        cooperationModes: [],
                        approvalStatuses: 'approved',
                        labels: []),
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
      icon: B2BV2Image.factory_3(width: 28, height: 28),
      title: '快反工厂',
      onPressed: () async {
        List<CategoryModel> categories =
        await Provider.of<MajorCategoryState>(context, listen: false)
            .getMajorCategories();
        List<LabelModel> labels =
        await Provider.of<LabelState>(context, listen: false).getLabels();
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
              builder: (context) =>
                  FactoryPage(
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
  final Widget icon;

  const _IconButton({Key key, this.onPressed, this.title, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            height: 60,
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: onPressed,
                child: Column(
                  children: <Widget>[
                    Expanded(flex: 1, child: icon),
                    Container(
                      child: Text(
                        '$title',
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff666666),
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
