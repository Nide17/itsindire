import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/auth.dart';
import 'package:tegura/firebase_services/payment_db.dart';
import 'package:tegura/firebase_services/profiledb.dart';
import 'package:tegura/models/payment.dart';
import 'package:tegura/models/profile.dart';

class AppBarTegura extends StatefulWidget {
  const AppBarTegura({super.key});

  @override
  State<AppBarTegura> createState() => _AppBarTeguraState();
}

class _AppBarTeguraState extends State<AppBarTegura> {
  final CollectionReference paymentsCollection =
      FirebaseFirestore.instance.collection('payments');
  String currentDeviceId = '';
  bool deviceCheckCompleted = false;

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
    final user = FirebaseAuth.instance.currentUser;
    final authState = Provider.of<AuthState>(context, listen: false);

    AndroidId androidId = AndroidId();
    androidId.getId().then((value) {
      if (!mounted) return;

      if (user != null) {
        authState.setCurrentUser(user);
        authState.setIsLoggedIn(true);
      }

      currentDeviceId = value ?? '';
      deviceCheckCompleted = true;
    });

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

            if (deviceCheckCompleted && user != null && profile != null) {
              String? profileDevice = profile.lastLoggedInDeviceId;

              print('Log out - Current device: $currentDeviceId');

              if (profileDevice == null || profileDevice.isEmpty) {
                print('Log out - Null Profile device: $profileDevice');
                DocumentReference profileRef;
                final FirebaseFirestore _firestore = FirebaseFirestore.instance;

                profileRef = _firestore.collection('profiles').doc(user.uid);

                // Update the lastLoggedInDeviceId
                profileRef.update({'lastLoggedInDeviceId': currentDeviceId});
              }

              if (currentDeviceId.isNotEmpty &&
                  profileDevice != null &&
                  currentDeviceId != profileDevice) {
                print(
                    'Log out - Device check completed: $deviceCheckCompleted');
                authState.logOut();
              }
            }

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
                if (user != null && profile != null && profile.username != '')
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
                                    text:
                                        capitalizeWords(user.displayName ?? ''),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                          text: '\n${user.email}',
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
                                          fontWeight: FontWeight.w500,
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
                                          fontWeight: FontWeight.w500,
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
                                              fontWeight: FontWeight.w500,
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

                                        if (result == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Gusohoka ntibikunze. Ongera ugerageze!'),
                                              duration:
                                                  const Duration(seconds: 10),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 255, 0, 0),
                                            ),
                                          );
                                        }

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(result),
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
                                          fontWeight: FontWeight.w500,
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
