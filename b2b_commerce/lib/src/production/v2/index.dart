import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/production/v2/progress_work_sheet_list.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

const _status = EnumModel('ALL', '全部');

///生产进度工单
class ProductionProgressPage extends StatefulWidget {
  @override
  _ProductionProgressPageState createState() => _ProductionProgressPageState();
}

class _ProductionProgressPageState extends State<ProductionProgressPage> {
  bool isSearching = false;
  TextEditingController controller;
  FocusNode focusNode;
  String appBarTitle = '生产进度';

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProgressWorkSheetState>(
      create: (context) => ProgressWorkSheetState(),
      child: Scaffold(
        appBar: _buildAppbar(),
        body: ProgressWorkSheetView(status: _status),
      ),
    );
  }

  Widget _buildAppbar() {
    return isSearching
        ? AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Consumer<ProgressWorkSheetState>(
            builder: (context, ProgressWorkSheetState state, _) => SearchAppbarTitle(
              controller: controller,  
              focusNode: focusNode,
              onSearch: () {
                state.setKeyword(controller.text);
                if (controller.text == '') {
                  setState(() {
                    isSearching = false;
                  });
                }
              },
              onChange: (v) {
                state.setKeyword(controller.text);
              },
            )
          ),
        )
        : AppBarFactory.buildDefaultAppBar(
            '$appBarTitle',
            actions: <Widget>[_buildSearchButton()]
          );
  }

  Widget _buildSearchButton() {
    return IconButton(
      icon: const Icon(B2BIcons.search, size: 20),
      onPressed: () {
        setState(() {
          isSearching = true;
        });
      },
    );
  }
}
