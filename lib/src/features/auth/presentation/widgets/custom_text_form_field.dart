import 'package:flutter/material.dart';


enum TextFormFieldVariant {
  text, email, password
}

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    this.controller,
    this.focusNode,
    this.formFieldKey,
    this.hintText = 'Error field',
    this.keyboardType = TextInputType.text,
    this.validator,
    this.variant = TextFormFieldVariant.text,
    this.textCapitalization = TextCapitalization.none,
    super.key
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final GlobalKey<FormFieldState>? formFieldKey;
  final String hintText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextFormFieldVariant variant;
  final String? Function(String? value)? validator;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isObscure = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    if(widget.variant == TextFormFieldVariant.password){
      _isObscure = true;
    }
    if(widget.focusNode != null) {
      focusNode = widget.focusNode!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.formFieldKey,
      controller: widget.controller,
      focusNode: focusNode,
      keyboardType: widget.keyboardType,
      obscureText: _isObscure,
      textCapitalization: widget.textCapitalization,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.variant == TextFormFieldVariant.password 
          ? IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility_off : Icons.visibility,
              color: focusNode.hasFocus 
                ? Theme.of(context).primaryColor
                : Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.70)
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            }
          )
          : null
      )
    );
  }
}