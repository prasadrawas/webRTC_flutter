import 'package:flutter/material.dart';

import '../shared/dimensions/dimensions.dart';

class TextEditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  String? Function(String?)? validator;
  TextInputType keyboardType;
  int maxLines;
  bool filled;
  double? height;
  TextEditField({
    Key? key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.height = 48,
    this.validator,
    this.filled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: Dimens.px15, bottom: Dimens.px10),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          autocorrect: false,
          validator: validator,
          textCapitalization: (keyboardType == TextInputType.text)
              ? TextCapitalization.words
              : TextCapitalization.none,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: !filled
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimens.px5))
                : null,
            filled: filled,
            labelText: label,
          ),
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }
}
