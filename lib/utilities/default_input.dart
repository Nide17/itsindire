import 'package:flutter/material.dart';

class DefaultInput extends StatelessWidget {
  // INSTANCE VARIABLES
  final String? placeholder;
  final String? validation;
  final int maxLines;
  final Function(String)? onChanged;
  final bool? obscureText;

  // CONSTRUCTOR
  const DefaultInput({
    super.key,
    this.placeholder,
    this.validation,
    this.maxLines = 1,
    this.onChanged,
    this.obscureText,
  });

  // EMAIL VALIDATION REGEX
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  // VALIDATION - EMAIL
  static String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Injiza imeyili yawe!';
    }
    if (!_emailRegExp.hasMatch(value)) {
      return 'Injiza imeyili nyayo!';
    }
    return null;
  }

  // VALIDATION - PASSWORD
  static String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Injiza ijambobanga!';
    }

    if (value.length < 6) {
      return 'Injiza inyuguti 6 zitarenga 24!';
    }
    return null;
  }

  // VALIDATION - EMPTY
  static String? _validateEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Uzuza hano!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // INPUT
        TextFormField(
          maxLines: maxLines,
          obscureText: obscureText ?? false,

          // ON CHANGED
          onChanged: onChanged,

          textAlignVertical: TextAlignVertical.center,

          // STYLING
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(
              color: Color(0xFF7FC8DF),
            ),

            // BACKGROUND COLOR
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),

            // HEIGHT
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
          ),

          // VALIDATION IF EMAIL OR PASSWORD
          validator: placeholder == 'Imeyili'
              ? _validateEmail
              : placeholder == 'Ijambobanga'
                  ? _validatePassword
                  : _validateEmpty,

          // ON SAVED VALIDATION
          onSaved: (value) {},
        ),

        // VERTICAL SPACE
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.024,
        )
      ],
    );
  }
}
