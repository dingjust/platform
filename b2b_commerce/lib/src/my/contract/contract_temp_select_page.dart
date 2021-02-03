import 'package:b2b_commerce/src/_shared/contract/contract_temp_single_select_list.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class ContractTempSelectPage extends StatefulWidget {
  ContractTemplateModel contractTempModel;
  String title;
  String type;

  ContractTempSelectPage({
    this.title,
    this.contractTempModel,
    this.type,
  });

  _ContractTempSelectPageState createState() => _ContractTempSelectPageState();
}

class _ContractTempSelectPageState extends State<ContractTempSelectPage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContractTempListState()),
      ],
      child: Consumer<ContractTempListState>(
          builder: (context, contractTempListState, _) {
        contractTempListState.queryFormData['type'] = widget.type;
        return Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            title: Text(widget.title ?? '合同模板'),
            centerTitle: true,
          ),
          body: contractTempListState.contractTempModels != null
              ? ContractTempSingleSelectList(
                  contractTempListState: contractTempListState,
                  model: widget.contractTempModel,
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }
}
