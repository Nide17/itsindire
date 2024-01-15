import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/auth.dart';
import 'package:tegura/firebase_services/payment_db.dart';
import 'package:tegura/firebase_services/profiledb.dart';
// import 'package:tegura/main.dart';
import 'package:tegura/models/payment.dart';
import 'package:tegura/models/profile.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/iga/utils/tegura_alert.dart';

class AppBarTegura extends StatefulWidget {
  const AppBarTegura({super.key});

  @override
  State<AppBarTegura> createState() => _AppBarTeguraState();
}

class _AppBarTeguraState extends State<AppBarTegura> {
  final CollectionReference paymentsCollection =
      FirebaseFirestore.instance.collection('payments');
  final usr = FirebaseAuth.instance.currentUser;

  // payments stream
  Stream<QuerySnapshot> get payments {
    if (usr != null) {
      return paymentsCollection.where('userId', isEqualTo: usr!.uid).snapshots();
    }
    return const Stream.empty();
  }

  @override
  void initState() {
    super.initState();
    payments.listen((event) {
      for (var change in event.docChanges) {
        dynamic doc = change.doc.data();
        if (change.type == DocumentChangeType.modified &&
            doc['userId'] == usr!.uid) {
          String msg = doc['isApproved'] == true
              ? 'Ifatabuguzi ryawe ryemejwe. Ubu watangira kwiga!'
              : 'Ifatabuguzi ryawe ryahinduwe. Murakoze!';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg),
              action: SnackBarAction(
                label: 'Funga',
                onPressed: () {
                  ScaffoldMessenger.of(context).clearSnackBars();
                },
              ),
              duration: const Duration(seconds: 20),
              backgroundColor: doc['isApproved'] == true
                  ? const Color(0xFF00A651)
                  : const Color.fromARGB(255, 255, 0, 0),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final usr = Provider.of<UserModel?>(context);
    // final conn = Provider.of<ConnectionStatus>(context);
    // ignore: avoid_print
    // print('Connection status: ${conn.toString()}');

// PROVIDERS
    return MultiProvider(
      providers: [
        StreamProvider<PaymentModel?>.value(
          value: usr != null
              ? PaymentService().getNewestPytByUserId(usr.uid)
              : null,
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
        StreamProvider<ProfileModel?>.value(
          value:
              usr != null ? ProfileService().getCurrentProfile(usr.uid) : null,
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
      ],

      // CONSUMERS
      child: Consumer<PaymentModel?>(builder: (context, newestPyt, _) {
        return Consumer<ProfileModel?>(builder: (context, profile, _) {
          String username = profile != null
              ? profile.username!
              : usr != null
                  ? usr.email!
                  : 'User';
          return AppBar(
            backgroundColor: const Color(0xFF5B8BDF),
            automaticallyImplyLeading: false,
            bottom: PreferredSize(
              preferredSize: MediaQuery.of(context).size * 0.001,
              child: Container(
                color: const Color(0xFFFFBD59),
                height: MediaQuery.of(context).size.height * 0.01,
              ),
            ),
            title: Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/car.svg',
                  height: MediaQuery.of(context).size.height * 0.045,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.012,
                ),
                Text('Tegura.rw',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w900,
                      fontSize: MediaQuery.of(context).size.width * 0.048,
                    )),
              ],
            ),
            actions: <Widget>[
              if (usr != null && profile != null)
                IconButton(
                  icon: profile.photo == null || profile.photo == ''
                      ? SvgPicture.asset(
                          'assets/images/avatar.svg',
                          height: MediaQuery.of(context).size.height * 0.048,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(profile.photo!),
                        ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.024),
                            side: BorderSide(
                              color: const Color(0xFF5B8BDF),
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                          ),
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
                          backgroundColor: const Color(0xFFFFBD59),
                          elevation: 10.0,
                          shadowColor: const Color(0xFF5B8BDF),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.024,
                                ),
                                Align(
                                  child: Text(
                                      newestPyt == null
                                          ? 'NTA FATABUGUZI URAFATA'
                                          : newestPyt.getRemainingDays() > 0 &&
                                                  newestPyt.isApproved == true
                                              ? 'IFATABUGUZI RYAWE'
                                              : newestPyt.getRemainingDays() >
                                                          0 &&
                                                      newestPyt.isApproved ==
                                                          false
                                                  ? ''
                                                  : 'IFATABUGUZI RYARANGIYE!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        color: newestPyt != null &&
                                                newestPyt.getRemainingDays() > 0
                                            ? const Color.fromARGB(
                                                255, 255, 255, 255)
                                            : const Color.fromARGB(
                                                255, 255, 0, 0),
                                      )),
                                ),
                                if (newestPyt != null &&
                                    newestPyt.getRemainingDays() > 0 &&
                                    newestPyt.isApproved == true)
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.024,
                                  ),
                                if (newestPyt != null &&
                                    newestPyt.getRemainingDays() > 0 &&
                                    newestPyt.isApproved == true)
                                  Text(
                                      'Rizarangira kuri ${newestPyt.getFormatedEndDate()}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.004,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.036,
                                        color: const Color.fromARGB(
                                            255, 0, 27, 116),
                                      )),
                                if (newestPyt != null &&
                                    newestPyt.getRemainingDays() > 0 &&
                                    newestPyt.isApproved == true)
                                  Text(
                                      'Usigaje iminsi ${newestPyt.getRemainingDays()}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.0032,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.032,
                                        color: const Color.fromARGB(
                                            255, 0, 27, 116),
                                      )),
                                const SizedBox(height: 10.0),
                                if (newestPyt != null &&
                                    newestPyt.getRemainingDays() > 0 &&
                                    newestPyt.isApproved == false)
                                  Text('Ifatabuguzi ryawe ntiriremezwa',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        color: const Color.fromARGB(
                                            255, 255, 0, 0),
                                      )),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TeguraAlert(
                                      errorTitle: 'Gusohoka',
                                      errorMsg: 'Ushaka gusohoka?',
                                      firstButtonTitle: 'YEGO',
                                      firstButtonFunction: () {
                                        Navigator.popUntil(
                                            context, (route) => route.isFirst);
                                        AuthService().logOut();
                                      },
                                      firstButtonColor: const Color(0xFFE60000),
                                      secondButtonTitle: 'OYA',
                                      secondButtonFunction: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      secondButtonColor:
                                          const Color(0xFF00A651),
                                    );
                                  },
                                );
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
