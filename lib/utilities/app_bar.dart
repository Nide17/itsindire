import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itsindire/firebase_services/auth.dart';
import 'package:itsindire/firebase_services/payment_db.dart';
import 'package:itsindire/firebase_services/profiledb.dart';
import 'package:itsindire/models/payment.dart';
import 'package:itsindire/models/profile.dart';
import 'package:provider/provider.dart';

class AppBarItsindire extends StatefulWidget {
  const AppBarItsindire({super.key});

  @override
  State<AppBarItsindire> createState() => _AppBarItsindireState();
}

class _AppBarItsindireState extends State<AppBarItsindire> {
  final CollectionReference paymentsCollection =
      FirebaseFirestore.instance.collection('payments');

  // payments stream
  Stream<QuerySnapshot> get payments {
    if (FirebaseAuth.instance.currentUser != null) {
      return paymentsCollection
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots();
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
            doc['userId'] == FirebaseAuth.instance.currentUser!.uid) {
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
    return MultiProvider(
      providers: [
        StreamProvider<PaymentModel?>.value(
          value: FirebaseAuth.instance.currentUser != null
              ? PaymentService()
                  .getNewestPytByUserId(FirebaseAuth.instance.currentUser!.uid)
              : null,
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
        StreamProvider<ProfileModel?>.value(
          value: FirebaseAuth.instance.currentUser != null
              ? ProfileService()
                  .getCurrentProfileByID(FirebaseAuth.instance.currentUser!.uid)
              : null,
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
      ],
      child: Consumer<AuthState>(builder: (context, authState, _) {
        return Consumer<ProfileModel?>(builder: (context, profile, _) {
          return Consumer<PaymentModel?>(builder: (context, newestPyt, _) {
            final user = FirebaseAuth.instance.currentUser;

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
                  Text('Itsindire.rw',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w900,
                        fontSize: MediaQuery.of(context).size.width * 0.048,
                      )),
                ],
              ),
              actions: <Widget>[
                if (user != null && profile != null)
                  IconButton(
                    icon: profile.photo == ''
                        ? SvgPicture.asset(
                            'assets/images/avatar.svg',
                            height: MediaQuery.of(context).size.height * 0.048,
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(profile.photo ?? ''),
                          ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
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
                            icon: profile.photo == ''
                                ? SvgPicture.asset(
                                    'assets/images/avatar.svg',
                                    height: MediaQuery.of(context).size.height *
                                        0.048,
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      profile.photo ?? '',
                                      scale: 2,
                                    ),
                                  ),
                            title: Align(
                              alignment: Alignment.center,
                              child: Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(
                                    text: capitalizeWords(user.displayName ??
                                        profile.username ??
                                        ''),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text: '\n${user.email}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
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
                                            : newestPyt.getRemainingDays() >
                                                        0 &&
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
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: newestPyt != null &&
                                                  newestPyt.getRemainingDays() >
                                                      0
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
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.024,
                                    ),
                                  if (newestPyt != null &&
                                      newestPyt.getRemainingDays() > 0 &&
                                      newestPyt.isApproved == true)
                                    Text(
                                        'Rizarangira kuri ${newestPyt.getFormatedEndDate()}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.004,
                                          fontWeight: FontWeight.w600,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.0032,
                                          fontWeight: FontWeight.w600,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.032,
                                          color: const Color.fromARGB(
                                              255, 0, 27, 116),
                                        )),
                                  if (newestPyt != null &&
                                      newestPyt.getRemainingDays() > 0 &&
                                      newestPyt.isApproved == false)
                                    Container(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.016),
                                      child: Align(
                                        child: Text(
                                            'Murakoze kwishyura, ifatabuguzi ryawe riri kwigwaho...',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              color: const Color.fromARGB(
                                                  255, 255, 0, 0),
                                            )),
                                      ),
                                    ),
                                  const SizedBox(height: 10.0),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        dynamic result =
                                            await authState.logOut();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result != null
                                                  ? result
                                                  : 'Ntibikunze, ongera ugerageze!',
                                            ),
                                            duration:
                                                const Duration(seconds: 10),
                                            backgroundColor:
                                                const Color(0xFF00A651),
                                          ),
                                        );
                                        if (Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.logout,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.048,
                                      ),
                                      label: Text(
                                        'Sohoka',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.014,
                                        ),
                                        backgroundColor:
                                            const Color(0xFF5B8BDF),
                                        foregroundColor:
                                            const Color(0xFFFFBD59),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            );
          });
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
