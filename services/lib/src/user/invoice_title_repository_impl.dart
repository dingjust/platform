import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/user/invoice_title_repository.dart';

class InvoiceTitleRepositoryImpl implements InvoiceTitleRepository{
  const InvoiceTitleRepositoryImpl();

  @override
  Future<List<InvoiceTitleModel>> list() async{
    Response response;
    List<InvoiceTitleModel> result;
    try {
      response = await http$.get(UserApis.invoiceTitles);
    } catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      result = response.data.map<InvoiceTitleModel>((invoiceTitle){
        return InvoiceTitleModel.fromJson(invoiceTitle);
      }).toList();
    }

    return result;
  }

  @override
  Future<InvoiceTitleModel> detail(int id) async{
    Response response;
    InvoiceTitleModel result;
    try {
      response = await http$.get(UserApis.invoiceTitleFromId(id));
    } catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
        result = InvoiceTitleModel.fromJson(response.data);
    }

    return result;
  }

  @override
  Future<String> create(InvoiceTitleModel form) async{
    Response response;
    String result;
    try {
    print(InvoiceTitleModel.toJson(form));
      response = await http$.post(UserApis.invoiceTitles,data: InvoiceTitleModel.toJson(form));
    } catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      result = response.data;
    }

    return result;
  }

  @override
  Future<String> update(InvoiceTitleModel form) async{
    Response response;
    String result;
    print(InvoiceTitleModel.toJson(form));
    try {
      response = await http$.put(UserApis.invoiceTitleFromId(form.id),data: InvoiceTitleModel.toJson(form));
    } catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      result = response.data;
    }

    return result;
  }

  @override
  Future<String> delete(int id) async{
    Response response;
    String result;
    try {
      response = await http$.delete(UserApis.invoiceTitleFromId(id));
    } catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      result = response.data;
    }

    return result;
  }


}
