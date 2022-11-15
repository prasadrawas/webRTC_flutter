import 'package:flutter/material.dart';

import '../../../constants/color_constants.dart';
import '../dimensions/dimensions.dart';

class AppTheme {
  AppTheme._();

  static const TextStyle richText = TextStyle(
    fontSize: Dimens.px14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
    height: 1.5,
  );

  static const TextStyle richTextLink = TextStyle(
    fontSize: Dimens.px14,
    fontWeight: FontWeight.w500,
    color: ColorConstants.darkYellow,
    height: 1.5,
  );

  static const TextStyle onBoardingH1Blue = TextStyle(
    fontSize: Dimens.px25,
    fontWeight: FontWeight.bold,
    color: ColorConstants.blue10,
  );

  static const TextStyle onBoardingH1Yellow = TextStyle(
    fontSize: Dimens.px22,
    fontWeight: FontWeight.bold,
    color: ColorConstants.darkYellow,
  );

  static const TextStyle headingText = TextStyle(
    fontSize: Dimens.px20,
    fontWeight: FontWeight.bold,
    color: ColorConstants.black,
  );
}
