import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/my_alert_widget.dart';
import '../../../../core/presentation/my_appbar.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/custom_text_form_field.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _nameFieldKey = GlobalKey<FormFieldState>();
  final _passwordFieldKey = GlobalKey<FormFieldState>();

  final _emailFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void initState() {
    _emailFocus.addListener(() {
      validateTextFormField(_emailFieldKey, _emailFocus);
    });
    _nameFocus.addListener(() {
      validateTextFormField(_nameFieldKey, _nameFocus);
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

  void signUp(BuildContext context) async {
    if(!_formKey.currentState!.validate()){
      return;
    }

    String email = _emailFieldKey.currentState!.value.trim();
    String name = _nameFieldKey.currentState!.value.trim();
    String password = _passwordFieldKey.currentState!.value;

    final provider = BlocProvider.of<AuthCubit>(context);
    provider.signUp(email: email, name: name, password: password);
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _nameFocus.dispose();
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
    return Form(
      key: _formKey,
      child: Column(children: [
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
          child: CustomTextFormField(
            formFieldKey: _nameFieldKey,
            focusNode: _nameFocus,
            hintText: 'Name',
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if(value == null || value.isEmpty){
                return 'Please enter your name';
              }
              return null;
            }
          )
        ),
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: CustomTextFormField(
            formFieldKey: _emailFieldKey,
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Email',
            validator: (value) {
              if(value == null || value.isEmpty){
                return 'Please enter your email';
              }
              return null;
            }
          )
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
                return 'Please enter a valid password';
              }
              return null;
            }
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
      ])
    );
  }

  Widget buildSectionSignIn(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Do you have an account?"),
          TextButton(
            onPressed: () {
              context.push('/signin');
            }, 
            child: const Text('Sign in')
          )
        ]
      )
    );
  }

}