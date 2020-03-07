import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class CompanyProfileItem extends StatefulWidget {
  CompanyProfileModel companyProfile;
  CompanyProfileItem(this.companyProfile);

  CompanyProfileItemState createState() => CompanyProfileItemState();
}

class CompanyProfileItemState extends State<CompanyProfileItem> {
  FocusNode _descriptionFocusNode = FocusNode();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _descriptionController.text = widget.companyProfile.description;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
//        Padding(
//          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//          child: Text(
//            '上传图片',
//            style: TextStyle(
//              fontSize: 17,
//              color: Colors.grey,
//            ),
//          ),
//        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          child: EditableAttachments(list: widget.companyProfile.medias,
            isCut: true,
            ratioX: 1.9,
            ratioY: 1.0,
            maxNum: 1,),
        ),
        TextFieldComponent(
          focusNode: _descriptionFocusNode,
          controller: _descriptionController,
          leadingText: Text('说明',style: TextStyle(fontSize: 16,color: Colors.grey,)),
          textAlign: TextAlign.start,
          onChanged: (value){
            widget.companyProfile.description = value == '' ? null : value;
          },
        )
      ],
    );
  }
}
