import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/presentation/my_alert_widget.dart';
import '../../../../core/presentation/my_appbar.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/custom_text_form_field.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void initState() {
    _emailFocus.addListener(() {
      validateTextFormField(_emailFieldKey, _emailFocus);
    });
    _passwordFocus.addListener(() {
      validateTextFormField(_passwordFieldKey, _passwordFocus);
    });
    super.initState();
  }

  void validateTextFormField(GlobalKey<FormFieldState> key, FocusNode focus) {
    if(!focus.hasFocus){
      key.currentState?.validate();
    }
  }

  void signIn(BuildContext context) async {
    if(!_formKey.currentState!.validate()){
      return;
    }
    
    String email = _emailFieldKey.currentState!.value.trim();
    String password = _passwordFieldKey.currentState!.value;

    final provider = BlocProvider.of<AuthCubit>(context);
    provider.signIn(email: email, password: password);
  }

  void signInWithGoogle(BuildContext context) async{
    final provider = BlocProvider.of<AuthCubit>(context);
    provider.signInWithGoogle();
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
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
                    if(state is AuthFailure){
                      MyAlert.showToast(
                        context: context, 
                        message: state.message,
                        duration: const Duration(milliseconds: 3000)
                      );
                    }
                  },
                  builder: (context, state) => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildForm(context, state),
                      buildSectionSocial(context, state),
                      buildSectionSignUp()
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
    return Form(
      key: _formKey,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text('Hello again!', style: Theme.of(context).textTheme.headlineSmall),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(bottom: 10),
          child: Text('Account information', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: CustomTextFormField(
            formFieldKey: _emailFieldKey,
            focusNode: _emailFocus,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if(value == null || value.isEmpty){
                return 'Please enter your email';
              }
              return null;
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: CustomTextFormField(
            formFieldKey: _passwordFieldKey,
            focusNode: _passwordFocus,
            hintText: 'Password',
            variant: TextFormFieldVariant.password,
            validator: (value) {
              if(value == null || value.isEmpty){
                return 'Please enter your password';
              }
              return null;
            },
          )
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 40),
          child: SizedBox(
            height: 50,
            child: TextButton(
              onPressed: (){
                state is Authenticating || state is AuthenticatingWithGoogle
                  ? null 
                  : signIn(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9)
              ),     
              child: state is Authenticating 
                ? const SizedBox(width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                  )
                : const Text('Sign in', style: TextStyle(color: Colors.white))
            )
          )
        )
      ])
    );
  }

  Widget buildSectionSocial(BuildContext context, AuthState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Divider(
                thickness: 1
              )
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 40.0),
              child: Text("Or continue with"),
            ),
            SizedBox(
              width: 100,
              child: Divider(
                thickness: 1
              )
            )
          ]
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: (){
              state is Authenticating || state is AuthenticatingWithGoogle 
                ? null 
                : signInWithGoogle(context);
            }, 
            child: state is AuthenticatingWithGoogle
              ? const SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2)
              )
              : const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Ionicons.logo_google),
                  Padding(
                    padding: EdgeInsets.only(top: 2.0, left: 8.0),
                    child: Text('Google',style: TextStyle(fontSize: 16.0)),
                  )
                ]
            )
          )
        )
      ]
    );
  }

  Widget buildSectionSignUp() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't you have an account?"),
          TextButton(
            onPressed: () {
              context.push('/signup');
            },
            child: const Text('Sign up')
          )
        ]
      )
    );
  }

}