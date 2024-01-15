import 'package:flutter/material.dart';

class DefaultInput extends StatefulWidget {
  final String? placeholder;
  final String? validation;
  final int maxLines;
  final Function(String)? onChanged;

  const DefaultInput({
    super.key,
    this.placeholder,
    this.validation,
    this.maxLines = 1,
    this.onChanged,
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

  static final RegExp _mtnRegExp = RegExp(
    r'^07[89][0-9]{7}$',
  );

  // VALIDATION - MTN NUMBER
  static String? _validateMtnNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Injiza numero yawe ya MTN! - Please enter your MTN number!';
    }
    if (!_mtnRegExp.hasMatch(value)) {
      return 'Injiza numero yawe ya MTN nyayo! - Please enter a valid MTN number!';
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
              vertical: 16.0,
              horizontal: 24.0,
            ),
            suffixIcon: (widget.placeholder == 'Ijambobanga' ||
                    widget.placeholder == 'Password')
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    child: const Icon(
                      Icons.visibility,
                      color: Color.fromARGB(255, 139, 145, 155),
                    ),
                  )
                : null,
          ),
          validator: (widget.placeholder == 'Imeyili' ||
                  widget.placeholder == 'E-mail')
              ? DefaultInput._validateEmail
              : (widget.placeholder == 'Ijambobanga' ||
                      widget.placeholder == 'Password')
                  ? DefaultInput._validatePassword
                  : (widget.placeholder == 'Nimero yawe ya MTN' ||
                          widget.placeholder == 'Your MTN Number')
                      ? DefaultInput._validateMtnNumber
                      : _validateEmpty,
          onSaved: (value) {},
          keyboardType: (widget.placeholder == 'Nimero yawe ya MTN' ||
                  widget.placeholder == 'Your MTN Number')
              ? TextInputType.number
              : (widget.placeholder == 'Imeyili' ||
                      widget.placeholder == 'E-mail')
                  ? TextInputType.emailAddress
                  : TextInputType.text,
          obscureText: (widget.placeholder == 'Ijambobanga' ||
                  widget.placeholder == 'Password')
              ? _isObscure
              : false,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.024,
        )
      ],
    );
  }
}
