import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:itsindire/utilities/default_input.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/utilities/description.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/firebase_services/auth.dart';

class Konti extends StatefulWidget {
  const Konti({super.key});

  @override
  State<Konti> createState() => _KontiState();
}

// STATE FOR THE SIGN IN PAGE - STATEFUL
class _KontiState extends State<Konti> {
  final _formKey = GlobalKey<FormState>();
  String password = '';
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthState>(builder: (context, authState, _) {
      if (authState.currentProfile == null) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 71, 103, 158),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarItsindire(),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff14e4ff), Color(0xFF5B8BDF)],
              stops: [0.01, 0.6],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: ListView(
            children: [
              const GradientTitle(
                title: 'KONTI YAWE',
                icon: 'assets/images/avatar.svg',
              ),
              Description(
                text:
                    'Ikaze ${authState.currentProfile!.username}, aya ni amakuri ya konti yawe kuri Itsindire.',
              ),
              _buildProfileInfo(
                context,
                'Izina rya konti',
                authState.currentProfile!.username ?? 'N/A',
              ),
              _buildProfileInfo(
                context,
                'Imeyili',
                authState.currentProfile!.email ?? 'N/A',
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultInput(
                            placeholder: 'Ijambobanga',
                            validation: 'Injiza ijambobanga!',
                            onChanged: (value) =>
                                setState(() => password = value),
                          ),
                          _isDeleting
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () => _showDeleteAccountDialog(
                                      context, authState),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                      vertical: 12.0,
                                    ),
                                  ),
                                  child: const Text('Siba konti yawe',
                                      style: TextStyle(color: Colors.white)),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showDeleteAccountDialog(BuildContext context, AuthState authState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Siba konti yawe!'),
          content: const Text(
              'Ubu se wifuza gusiba konti yawe kuri Itsindire? ushobora kuyisiba ariko igenda burundu.'),
          actions: [
            _buildDialogButton(
              context: context,
              label: 'Oya',
              color: Colors.green,
              onPressed: () => Navigator.of(context).pop(),
            ),
            _buildDialogButton(
              context: context,
              label: 'Yego',
              color: Colors.red,
              onPressed: () => _deleteAccount(context, authState),
            ),
          ],
        );
      },
    );
  }

  TextButton _buildDialogButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(color: Colors.white)),
      style: TextButton.styleFrom(backgroundColor: color),
    );
  }

  Future<void> _deleteAccount(BuildContext context, AuthState authState) async {
    setState(() {
      _isDeleting = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        await authState.deleteAccount(user.uid, user.email!, password);
        Navigator.of(context).popUntil((route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Konti yawe yasibwe neza.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _showErrorSnackBar(
            context, 'Email is not provided. Log out and log in again.');
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Habayeho ikosa: $e');
    } finally {
      setState(() {
        _isDeleting = false;
      });
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.03,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
