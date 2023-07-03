import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../widgets/loader_dialog_widget.dart';
import '../widgets/sign_out_dialog_widget.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void getUser(BuildContext context) {
    final provider = BlocProvider.of<AuthCubit>(context);
    provider.getUser();
  }

  void signOut(BuildContext context) async {
    loaderDialog(context, 'Closing...');
    final provider = BlocProvider.of<AuthCubit>(context);
    await Future.delayed(const Duration(seconds: 1), (){});
    provider.signOut();
    if(context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(context),
          body: RefreshIndicator(
            onRefresh: () async {
              getUser(context);
            },
            child: Column(children: [
              checkState(context, state)
            ])
          ) 
        );
      }
    );
  }

  Widget checkState(BuildContext context, dynamic state) {
    switch(state.runtimeType){
      case AuthInitial:
        getUser(context);
        return buildLoading();
      case Authenticated:
        return buildMessage('Welcome, ${state.user.name}');
      case AuthFailure:
        return buildMessage(state.message);
      case Authenticating:
        return buildLoading();
      default:
        return buildMessage('');
    }
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Home'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: IconButton(
            onPressed: () {
              signOutDialog(context, 
                onPressedSignOut: (){
                  signOut(context);
                }
              );
            }, 
            icon: const Icon(Icons.exit_to_app_outlined)
          ),
        )
      ]
    );
  }

  Widget buildMessage(String message){
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(children: [
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Text(message)
            )
          ]);
        }
      )
    );
  }

  Widget buildLoading(){
    return const Expanded(
      child: Center(child: CircularProgressIndicator())
    );
  }

}