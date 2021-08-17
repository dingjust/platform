import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets.dart';

///数字步进器
class NumberStepper extends StatefulWidget {
  final double initVal;

  final double step;

  final double? min;

  final double? max;

  final ValueChanged<double?>? onChange;

  final double iconSize;

  final Color iconColor;

  ///省略小数点后位数
  final int asFixedNum;

  NumberStepper(
      {Key? key,
      this.initVal = 1,
      this.step = 1,
      this.min,
      this.max,
      this.onChange,
      this.iconSize = 12,
      this.asFixedNum = 0,
      this.iconColor = Colors.orangeAccent})
      : super(key: key);

  @override
  _NumberStepperState createState() => _NumberStepperState();
}

class _NumberStepperState extends State<NumberStepper> {
  TextEditingController? controller;

  @override
  void initState() {
    controller = TextEditingController(
        text: '${widget.initVal.toStringAsFixed(widget.asFixedNum)}');
    super.initState();
  }

  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            double? val = double.tryParse(controller!.text);
            if (val != null &&
                (widget.min != null ? val > widget.min! : true)) {
              val = val - widget.step;
              setState(() {
                controller!.text = val!.toStringAsFixed(widget.asFixedNum);
              });
              if (widget.onChange != null) {
                widget.onChange!.call(val);
              }
            }
          },
          child: Icon(
            B2BIcons.remove_rect,
            size: widget.iconSize,
            color: widget.iconColor,
          ),
        ),
        Expanded(
            child: Container(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(fontSize: 15),
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
            //只能输入数字
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (val) {
              double? number = double.tryParse(val);
              if (number != null) {
                double? result;

                if (widget.min != null && number < widget.min!) {
                  setState(() {
                    controller!.text = widget.min.toString();
                    result = widget.min;
                  });
                } else if (widget.max != null && number > widget.max!) {
                  setState(() {
                    controller!.text = widget.max.toString();
                    result = widget.max;
                  });
                } else {
                  result = number;
                }
                if (widget.onChange != null) {
                  widget.onChange!.call(result);
                }
              }
            },
          ),
        )),
        GestureDetector(
          onTap: () {
            double? val = double.tryParse(controller!.text);
            if (val != null &&
                (widget.max != null ? val < widget.max! : true)) {
              val = val + widget.step;
              setState(() {
                controller!.text = val!.toStringAsFixed(widget.asFixedNum);
              });
              if (widget.onChange != null) {
                widget.onChange!.call(val);
              }
            }
          },
          child: Icon(
            B2BIcons.add_rect,
            size: widget.iconSize,
            color: widget.iconColor,
          ),
        ),
      ],
    );
  }
}
