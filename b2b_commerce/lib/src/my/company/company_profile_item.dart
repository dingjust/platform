import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class CompanyProfileItem extends StatefulWidget {
  CompanyProfileModel companyProfile;
  CompanyProfileItem(this.companyProfile);

  CompanyProfileItemState createState() => CompanyProfileItemState();
}

class CompanyProfileItemState extends State<CompanyProfileItem> {
  FocusNode __descriptionFocusNode = FocusNode();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _descriptionController.text = widget.companyProfile.description;;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
          child: Text(
            '上传图片',
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey,
            ),
          ),
        ),
        EditableAttachments(list: widget.companyProfile.medias,),
        TextFieldComponent(
          focusNode: __descriptionFocusNode,
          controller: _descriptionController,
          leadingText: '说明',
          leadingColor: Colors.grey,
        )
      ],
    );
  }
}
