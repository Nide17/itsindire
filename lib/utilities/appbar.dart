import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/payment_db.dart';
import 'package:tegura/firebase_services/profiledb.dart';
import 'package:tegura/main.dart';
import 'package:tegura/models/payment.dart';
import 'package:tegura/models/profile.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/firebase_services/auth.dart';

class AppBarTegura extends StatefulWidget {
  const AppBarTegura({Key? key}) : super(key: key);

  @override
  State<AppBarTegura> createState() => _AppBarTeguraState();
}

class _AppBarTeguraState extends State<AppBarTegura> {
  @override
  Widget build(BuildContext context) {
    // GET PROVIDER USER
    final usr = Provider.of<UserModel?>(context);
    final conn = Provider.of<ConnectionStatus>(context);
    print("Conn in app bar build: ${conn.isOnline}");

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
        StreamProvider<ProfileModel?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value:
              usr != null ? ProfileService().getCurrentProfile(usr.uid) : null,
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error in get progress: $error");
              print("The err: ${ProfileService().getCurrentProfile(usr?.uid)}");
            }
            // RETURN NULL
            return null;
          },
        ),
      ],
      child: Consumer<PaymentModel?>(builder: (context, payment, _) {
        
        return Consumer<ProfileModel?>(builder: (context, profile, _) {
          String username = profile != null
              ? profile.username!
              : usr != null
                  ? usr.email!
                  : 'User';
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
              if (usr != null && profile != null)
                IconButton(
                  // USE CUSTOM ICON - SVG
                  icon: profile.photo == null || profile.photo == ''
                      ? SvgPicture.asset(
                          'assets/images/avatar.svg',
                          height: MediaQuery.of(context).size.height * 0.048,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(profile.photo!),
                        ),
                  onPressed: () {
                    // OPEN A DIALOG BOX TO DISPLAY USER DETAILS AND LOGOUT BUTTON
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          icon: profile.photo == null || profile.photo == ''
                              ? SvgPicture.asset(
                                  'assets/images/avatar.svg',
                                  height: MediaQuery.of(context).size.height *
                                      0.048,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    profile.photo!,
                                    scale: 2,
                                  ),
                                ),
                          title: Align(
                            alignment: Alignment.center,
                            child: Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(
                                  text: capitalizeWords(username),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                        text: '\n${usr.email}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.0)),
                                  ]),
                            ),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 201, 222, 255),
                          elevation: 10.0,
                          shadowColor: const Color(0xFFFFF59D),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.024,
                                ),
                                Align(
                                  child: Text(
                                      payment == null
                                          ? 'NTA FATABUGUZI URAFATA'
                                          : payment.getRemainingDays() > 0
                                              ? 'IFATABUGUZI RYAWE'
                                              : 'IFATABUGUZI RYARANGIYE!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        decoration: TextDecoration.underline,
                                        color: payment != null &&
                                                payment.getRemainingDays() > 0
                                            ? const Color.fromARGB(255, 0, 0, 0)
                                            : const Color.fromARGB(
                                                255, 255, 0, 0),
                                      )),
                                ),
                                if (payment != null &&
                                    payment.getRemainingDays() > 0 &&
                                    payment.isApproved == true)
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.024,
                                  ),
                                if (payment != null &&
                                    payment.getRemainingDays() > 0 &&
                                    payment.isApproved == true)
                                  Text(
                                      'Rizarangira: ${payment.getFormatedEndDate()}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0,
                                          color:
                                              Color.fromARGB(255, 61, 61, 61))),
                                const SizedBox(height: 10.0),
                                if (payment != null &&
                                    payment.getRemainingDays() > 0 &&
                                    payment.isApproved == true)
                                  Text(
                                      'Iminsi usigaje: ${payment.getRemainingDays()}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15.0,
                                          color:
                                              Color.fromARGB(255, 61, 61, 61))),
                                const SizedBox(height: 10.0),
                                if (payment != null &&
                                    payment.getRemainingDays() > 0 &&
                                    payment.isApproved == false)
                                  const Text('Ntiriremezwa',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
                                        color: Color.fromARGB(255, 255, 0, 0),
                                      )),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            // LOGOUT BUTTON WITH logout.svg ICON
                            GestureDetector(
                              onTap: () {
                                // CLOSE THE DIALOG BOX
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                // LOGOUT THE USER USING THE AUTH SERVICE INSTANCE
                                AuthService().logOut();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: null,
                                    icon: SvgPicture.asset(
                                      'assets/images/logout.svg',
                                      width: 24.0,
                                      height: 24.0,
                                    ),
                                  ),
                                  const Text(
                                    'Sohoka',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
