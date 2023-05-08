import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/my_alert_widget.dart';
import '../../../../core/presentation/my_appbar.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_widgets.dart';

import 'sign_in_page.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _textControllerEmail = TextEditingController();
  final _textControllerName = TextEditingController();
  final _textControllerPass = TextEditingController();

  @override
  void dispose() {
    _textControllerEmail.dispose();
    _textControllerName.dispose();
    _textControllerPass.dispose();
    super.dispose();
  }
  
  void goToHomePage(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false
    );
  }

  void signUp(BuildContext context) async {
    String email = _textControllerEmail.text.trim();
    String name = _textControllerName.text.trim();
    String password = _textControllerPass.text;

    if(email.isEmpty || name.isEmpty || password.isEmpty){
      MyAlert.showToast(
        context: context, 
        message: 'All fields are required.'
      );
      return;
    }
    final provider = BlocProvider.of<AuthCubit>(context);
    provider.signUp(email: email, name: name, password: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar.empty(context),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: LayoutBuilder(
          builder: (_, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (_, state) {
                    if(state is Authenticated){
                      goToHomePage(context);
                    } else if(state is AuthFailure){
                      MyAlert.showToast(
                        context: context, 
                        message: state.message,
                        duration: const Duration(milliseconds: 2500)
                      );
                    }
                  },
                  builder: (context, state) => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildForm(context, state),
                      buildSectionSignIn()
                    ]
                  )
                )
              )
            )
          )
        )
      )
    );
  }

  Widget buildForm(BuildContext context, AuthState state) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.only(bottom: 25),
        child: Text('Create an account', style: Theme.of(context).textTheme.headlineSmall),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 10),
        child: Text('Register your information', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
      ),
      Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: _textControllerName,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Name'
          )
        )
      ),
      Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextField(
          controller: _textControllerEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Email'
          )
        )
      ),
      Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: MyPasswordField(
          controller: _textControllerPass
        )
      ),
      Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 40),
        child: SizedBox(
          height: 50,
          child: TextButton(
            onPressed: (){
              state is Authenticating ? null : signUp(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9)
            ),     
            child: state is Authenticating 
              ? const SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                )
              : const Text('Sign up', style: TextStyle(color: Colors.white))
          )
        )
      )
    ]);
  }

  Widget buildSectionSignIn(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Do you have an account?"),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SignInPage())
            ), 
            child: const Text('Sign in')
          )
        ]
      )
    );
  }

}