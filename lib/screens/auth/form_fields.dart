
import 'package:flutter/material.dart';
import 'package:itsindire/utilities/default_input.dart';

class FormFields extends StatelessWidget {
  final Function(String) onUsernameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;

  const FormFields({
    required this.onUsernameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultInput(
          placeholder: 'Izina',
          validation: 'Injiza izina ryawe!',
          onChanged: onUsernameChanged,
        ),
        DefaultInput(
          placeholder: 'Imeyili',
          validation: 'Injiza imeyili yawe!',
          onChanged: onEmailChanged,
        ),
        DefaultInput(
          placeholder: 'Ijambobanga',
          validation: 'Injiza ijambobanga!',
          onChanged: onPasswordChanged,
        ),
      ],
    );
  }
}