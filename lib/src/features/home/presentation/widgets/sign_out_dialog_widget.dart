import 'package:flutter/material.dart';


void signOutDialog(BuildContext context, {required void Function() onPressedSignOut}) {
  showGeneralDialog(
    context: context,
    barrierLabel: '',
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) => AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      title: Text('Sign out', 
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Text('Are you sure you want to sign out?'),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12, bottom: 10, left: 12),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPressedSignOut.call();
            },
            child: const Text('Sign out'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 12, bottom: 10, left: 12),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', 
              style: TextStyle(color: Theme.of(context).hintColor)
            ),
          ),
        )
      ],
    ),
    transitionBuilder: (_, a1, a2, child) => Transform.scale(
      scale: a1.value,
      child: child
    ) 
  );
}