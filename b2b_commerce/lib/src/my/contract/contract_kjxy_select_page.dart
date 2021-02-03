import 'package:b2b_commerce/src/_shared/contract/contract_single_select_list.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class ContractKjxySelectPage extends StatefulWidget {
  ContractModel contractModel;
  String companyCode;
  bool isFrame;

  ContractKjxySelectPage(
      {this.companyCode, this.isFrame = false, this.contractModel});

  _ContractKjxySelectPageState createState() => _ContractKjxySelectPageState();
}

class _ContractKjxySelectPageState extends State<ContractKjxySelectPage> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContractListState()),
      ],
      child: Consumer<ContractListState>(builder: (context, contractState, _) {
        contractState.queryFormData['isFrame'] = widget.isFrame;
        contractState.queryFormData['partyACompany'] = widget.companyCode;
        contractState.queryFormData['state'] = 'COMPLETE';
        return Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            title: Text('框架协议合同模板'),
            centerTitle: true,
          ),
          body: contractState.contractModels != null
              ? ContractSingleSelectList(
                  contractListState: contractState,
                  model: widget.contractModel,
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      }),
    );
  }
}
