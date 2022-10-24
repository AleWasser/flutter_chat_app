import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final String butttonText;
  final void Function()? onPressed;

  const BlueButton({
    Key? key,
    required this.butttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 2,
        primary: Colors.blue,
        shape: const StadiumBorder(),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            butttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
