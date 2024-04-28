import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function? callback;
  final Widget? title;
  CustomButton({Key? key, this.title, this.callback}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          color: const Color.fromARGB(255, 243, 33, 33),
          child: TextButton(
            onPressed: () => callback!(),
            child: title!,
          ),
        ),
      ),
    );
  }
}
