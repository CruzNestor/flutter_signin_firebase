import 'package:flutter/material.dart';


void loaderDialog(BuildContext context, String msg){
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:(BuildContext context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(children: [
          const SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(strokeWidth: 2.0),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(msg)
          ),
        ]),
      )
    ),
  );
}