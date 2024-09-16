import 'package:flutter/material.dart';

class DefaultInput extends StatelessWidget {
  // INSTANCE VARIABLES
  String? _name;
  String? placeholder;
  String? validation;
  int? maxLines = 1;

  // CONSTRUCTOR
  DefaultInput({super.key, this.placeholder, this.validation, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          maxLines: maxLines,
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

          // VALIDATION
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validation;
            }
            return null;
          },
          onSaved: (value) {
            _name = value;
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        )
      ],
    );
  }
}
