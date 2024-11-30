import "package:flutter/material.dart";
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
            padding: const EdgeInsets.all(16.0),
            children: [
              const GradientTitle(
                title: 'KONTI YAWE',
                icon: 'assets/images/avatar.svg',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Description(
                  text:
                      'Ikaze ${authState.currentProfile!.username}, aya ni amakuri ya konti yawe kuri Itsindire.',
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        _isDeleting
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Siba konti yawe!'),
                                        content: const Text(
                                            'Ubu se wifuza gusiba konti yawe kuri Itsindire? ushobora kuyisiba ariko igenda burundu.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Oya',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              setState(() {
                                                _isDeleting = true;
                                              });
                                              try {
                                                await authState.deleteAccount();
                                                Navigator.of(context).popUntil(
                                                    (route) => route.isFirst);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Konti yawe yasibwe neza.'),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              } catch (e) {
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Habayeho ikosa: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              } finally {
                                                setState(() {
                                                  _isDeleting = false;
                                                });
                                              }
                                            },
                                            child: const Text('Yego',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
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
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProfileInfo(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
