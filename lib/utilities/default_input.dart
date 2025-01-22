import 'package:flutter/material.dart';

class DefaultInput extends StatefulWidget {
  final String? placeholder;
  final String? validation;
  final int maxLines;
  final bool? enabled;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final bool isPassword;

  const DefaultInput({
    super.key,
    this.placeholder,
    this.validation,
    this.maxLines = 1,
    this.enabled,
    this.onChanged,
    this.keyboardType,
    this.isPassword = false,
  });

  // EMAIL VALIDATION REGEX
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  // VALIDATION - EMAIL
  static String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Injiza imeyili yawe! - Please enter your email!';
    }
    if (!_emailRegExp.hasMatch(value)) {
      return 'Injiza imeyili nyayo! - Please enter a valid email!';
    }
    return null;
  }

  // VALIDATION - PASSWORD
  static String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Injiza ijambobanga! - Please enter your password!';
    }

    if (value.length < 6) {
      return 'Injiza inyuguti 6 zitarenga 24! - Please enter a password between 6 and 24 characters!';
    }
    return null;
  }

  // VALIDATION - MTN NUMBER
  static String? _validateMtnNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Injiza numero yawe ya MTN nyayo (imibare 10)! - Please enter valid MTN number!';
    }
    // Check if the input matches the required format and length
    if (!RegExp(r'^(078|079)[0-9]{7}$').hasMatch(value)) {
      return 'Injiza numero yawe ya MTN nyayo (imibare 10)! - Please enter a valid MTN number!';
    }
    return null;
  }

  @override
  State<DefaultInput> createState() => _DefaultInputState();
}

class _DefaultInputState extends State<DefaultInput> {
  bool _isObscure = true;

  String? _validateEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return widget.validation;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          maxLines: widget.maxLines,
          onChanged: widget.onChanged,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: const TextStyle(
              color: Color(0xFF7FC8DF),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 139, 145, 155), width: 3.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 139, 145, 155), width: 3.0),
              borderRadius: BorderRadius.circular(20.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            errorStyle: const TextStyle(
              fontSize: 9.0,
              color: Colors.red,
              overflow: TextOverflow.ellipsis,
            ),
            errorMaxLines: 2,
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onTap: () {
                      setState(() => _isObscure = !_isObscure);
                    },
                    child: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Color.fromARGB(255, 139, 145, 155),
                    ),
                  )
                : null,
          ),
          validator: (widget.placeholder!.contains('Imeyili') ||
                  widget.placeholder!.contains('E-mail'))
              ? DefaultInput._validateEmail
              : widget.isPassword
                  ? DefaultInput._validatePassword
                  : (widget.placeholder!.contains('Nimero yawe ya MTN') ||
                          widget.placeholder!.contains('Your MTN Number'))
                      ? DefaultInput._validateMtnNumber
                      : _validateEmpty,
          onSaved: (value) {},
          keyboardType: widget.keyboardType ??
              ((widget.placeholder!.contains('Nimero yawe ya MTN') ||
                      widget.placeholder!.contains('Your MTN Number'))
                  ? TextInputType.number
                  : (widget.placeholder!.contains('Imeyili') ||
                          widget.placeholder!.contains('E-mail'))
                      ? TextInputType.emailAddress
                      : TextInputType.text),
          obscureText: widget.isPassword ? _isObscure : false,
          enabled: widget.enabled,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.024,
        )
      ],
    );
  }
}
