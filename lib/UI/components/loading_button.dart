import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final String buttonText;
  final Function() onPressed;
  Color color;
  Color? buttonTextColor;
  bool isLoading;
  double height;
  double? width;
  bool textCapital;

  LoadingButton(
      {Key? key,
      required this.buttonText,
      required this.onPressed,
      required this.color,
      this.height = 48,
      this.width = 300,
      this.isLoading = false,
      this.textCapital = true,
      this.buttonTextColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
            ),
          ),
          onPressed: !isLoading ? onPressed : null,
          child: _buttonText(),
        ),
      ),
    );
  }

  Widget _buttonText() {
    return !isLoading
        ? Text(
            buttonText.toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          )
        : SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              strokeWidth: 1,
              color: buttonTextColor ?? Colors.white,
            ),
          );
  }
}
