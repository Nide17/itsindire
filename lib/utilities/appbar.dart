import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/payment_db.dart';
import 'package:tegura/models/payment.dart';
import 'package:tegura/models/profile.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/firebase_services/auth.dart';

class AppBarTegura extends StatefulWidget {
  // INSTANCE VARIABLES
  final ProfileModel? profile;

  const AppBarTegura({Key? key, this.profile}) : super(key: key);

  @override
  State<AppBarTegura> createState() => _AppBarTeguraState();
}

class _AppBarTeguraState extends State<AppBarTegura> {
  @override
  Widget build(BuildContext context) {
    // GET PROVIDER USER
    final usr = Provider.of<UserModel?>(context);

    return MultiProvider(
      providers: [
        // GET CURRENT PAYMENT PLAN
        StreamProvider<PaymentModel?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: usr != null
              ? PaymentService().getLatestpaymentsByUserId(usr.uid)
              : null,
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error in get progress: $error");
              print(
                  "The err: ${PaymentService().getLatestpaymentsByUserId(usr!.uid)}");
            }
            // RETURN NULL
            return null;
          },
        ),
      ],
      child: Consumer<PaymentModel?>(builder: (context, payment, _) {
        return Consumer<ProfileModel?>(builder: (context, profile, _) {
          String? username = widget.profile != null
              ? widget.profile?.username
              : profile?.username;
          return AppBar(
            backgroundColor: const Color(0xFF5B8BDF),
            automaticallyImplyLeading: false,

            // BOTTOM BORDER OF THE APP BAR
            bottom: PreferredSize(
              // SET RESPONSIVE HEIGHT OF THE BOTTOM BORDER
              preferredSize: MediaQuery.of(context).size * 0.001,
              child: Container(
                color: const Color(0xFFFFBD59),
                height: MediaQuery.of(context).size.height * 0.01,
              ),
            ),
            title: Row(
              children: <Widget>[
                // ARRAY OF WIDGETS - ROW
                SvgPicture.asset(
                  'assets/images/car.svg',
                  height: MediaQuery.of(context).size.height * 0.045,
                ),

                // SPACING BETWEEN THE TWO WIDGETS
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.012,
                ),
                Text('Tegura.rw', // TEXT WIDGET
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w900,
                      fontSize: MediaQuery.of(context).size.width * 0.048,
                    )),
              ],
            ),

            // USER PROFILE ICON BUTTON - RIGHT SIDE OF THE APP BAR
            // CHECK IF USER IS LOGGED IN OR NOT BEFORE
            actions: <Widget>[
              // IF USER IS LOGGED IN
              if (usr != null)
                IconButton(
                  // USE CUSTOM ICON - SVG
                  icon: SvgPicture.asset(
                    'assets/images/avatar.svg',
                    height: MediaQuery.of(context).size.height * 0.048,
                  ),
                  onPressed: () {
                    // OPEN A DIALOG BOX TO DISPLAY USER DETAILS AND LOGOUT BUTTON
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            username != null
                                ? 'Ikaze ${capitalizeWords(username)}'
                                : 'Ikaze!',
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 201, 222, 255),
                          elevation: 10.0,
                          shadowColor: const Color(0xFFFFF59D),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                    username != null
                                        ? 'Izina: ${capitalizeWords(username)}'
                                        : 'User',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    )),
                                const SizedBox(height: 10.0),
                                Text('Email: ${usr.email}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    )),
                                const SizedBox(height: 16.0),
                                Align(
                                  child: Text(
                                      (payment!.getRemainingDays() > 0)
                                          ? 'IFATABUGUZI'
                                          : 'IFATABUGUZI RYARANGIYE!',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        decoration: TextDecoration.underline,
                                      )),
                                ),
                                if (payment.getRemainingDays() > 0)
                                  const SizedBox(height: 10.0),
                                if (payment.getRemainingDays() > 0)
                                  Text(
                                      'Rizarangira: ${payment.getFormatedEndDate()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      )),
                                const SizedBox(height: 10.0),
                                if (payment.getRemainingDays() > 0)
                                  Text(
                                      'Iminsi usigaje: ${payment.getRemainingDays()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      )),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 74, 185, 0),
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: const Text('Logout',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 252, 255, 79))),
                              onPressed: () {
                                // CLOSE THE DIALOG BOX
                                Navigator.of(context).pop();

                                // LOGOUT THE USER USING THE AUTH SERVICE INSTANCE
                                AuthService().logOut();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
            ],
          );
        });
      }),
    );
  }

  String capitalizeWords(String input) {
    List<String> words = input.split(' ');
    List<String> capitalizedWords = [];

    for (String word in words) {
      if (word.isNotEmpty) {
        capitalizedWords
            .add('${word[0].toUpperCase()}${word.substring(1).toLowerCase()}');
      } else {
        capitalizedWords.add(word);
      }
    }

    return capitalizedWords.join(' ');
  }
}
