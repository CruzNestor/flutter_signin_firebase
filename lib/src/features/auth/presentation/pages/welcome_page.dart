import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../../../core/constants/ui_constants.dart';
import '../../../../core/presentation/my_appbar.dart';


class WelcomePage extends StatelessWidget {
  
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: MyAppBar.hidden(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 10),
            child: Text(UIConstants.APP_NAME, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
          ),
          Container(
            alignment: Alignment.center,
            child: const FlutterLogo(
              size: 180,
            )
          ),
          SizedBox(
            child: Column(children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'We welcome to',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  UIConstants.APP_NAME,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: TextButton(
                  onPressed: (){
                    context.push('/signup');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white
                  ),
                  child: const Text('Sign up')
                )
              ),
              Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10.0, right: 10.0, bottom: 20.0, left: 10.0),
                child: OutlinedButton(
                  onPressed: (){
                    context.push('/signin');
                  },
                  child: const Text('Sign in')
                )
              )
            ])
          )
        ]
      )
    );
  }
}