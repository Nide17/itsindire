import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itsindire/firebase_services/auth.dart';
import 'package:itsindire/firebase_services/ifatabuguzi_db.dart';
import 'package:itsindire/firebase_services/payment_db.dart';
import 'package:itsindire/firebase_services/profiledb.dart';
import 'package:itsindire/models/ifatabuguzi.dart';
import 'package:itsindire/models/payment.dart';
import 'package:itsindire/models/profile.dart';
import 'package:itsindire/screens/iga/utils/countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/single_child_widget.dart';

class AppBarItsindire extends StatefulWidget {
  const AppBarItsindire({super.key});

  @override
  State<AppBarItsindire> createState() => _AppBarItsindireState();
}

class _AppBarItsindireState extends State<AppBarItsindire> {
  final CollectionReference paymentsCollection =
      FirebaseFirestore.instance.collection('payments');
  late StreamSubscription<QuerySnapshot> _paymentsSubscription;
  User? currentUser;
  int remainingSeconds = 0;
  late ScaffoldMessengerState scaffoldMessenger;
  late AuthState authState;
  bool isProcessingPayment = false;

  // payments stream
  Stream<QuerySnapshot> get payments => currentUser != null
      ? paymentsCollection
          .where('userId', isEqualTo: currentUser!.uid)
          .snapshots()
          .handleError((error) {
          _showSnackBar('Error fetching payments: $error',
              const Color.fromARGB(255, 255, 0, 0));
        })
      : const Stream.empty();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCurrentUser();
      _subscribeToPayments();
    });
  }

  void _initializeCurrentUser() {
    setState(() {
      currentUser = Provider.of<AuthState>(context, listen: false).currentUser;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
    authState = Provider.of<AuthState>(context, listen: false);
    // Listen for changes in AuthState
    authState.addListener(_authStateListener);
  }

  @override
  void dispose() {
    _paymentsSubscription.cancel();
    authState.removeListener(_authStateListener);
    super.dispose();
  }

  void _authStateListener() {
    setState(() {
      currentUser = Provider.of<AuthState>(context, listen: false).currentUser;
    });
  }

  void _subscribeToPayments() {
    _paymentsSubscription = payments.listen((event) {
      if (!mounted) return;
      for (var change in event.docChanges) {
        _handlePaymentChange(change);
      }
    }, onError: (error) {
      _showSnackBar('Error in payment subscription: $error',
          const Color.fromARGB(255, 255, 0, 0));
    });
  }

  void _handlePaymentChange(DocumentChange change) async {
    dynamic pyt = change.doc.data();
    if (currentUser == null) {
      print('Current user is null.');
      return;
    }

    if (change.type == DocumentChangeType.modified &&
        pyt['userId'] == currentUser!.uid) {
      if (pyt['isApproved'] == true &&
          pyt['endAt'].toDate().isAfter(DateTime.now())) {
        // Prevent recursive updates
        if (isProcessingPayment) return;
        isProcessingPayment = true;

        // Fetch the IfatabuguziModel
        IfatabuguziModel? ifatabuguzi = await IfatabuguziService()
            .getIfatabuguziById(pyt['ifatabuguziID'])
            .then((docSnapshot) {
          if (docSnapshot.exists) {
            return IfatabuguziModel.fromSnapshot(docSnapshot);
          }
          return null;
        });

        if (ifatabuguzi != null) {
          DateTime newCreatedAt = DateTime.now();
          DateTime newEndAt =
              newCreatedAt.add(Duration(days: ifatabuguzi.getDays()));

          // Check if the dates need to be updated
          if (pyt['createdAt'].toDate().isBefore(newCreatedAt) ||
              pyt['endAt'].toDate().isBefore(newEndAt)) {
            // Update the start and end date of the subscription
            await paymentsCollection.doc(change.doc.id).update({
              'createdAt': newCreatedAt,
              'endAt': newEndAt,
            });
          }
        }

        _showSnackBar('Ifatabuguzi ryawe ryemejwe. Ubu watangira kwiga!',
            const Color(0xFF00A651));

        isProcessingPayment = false;
      } else if (pyt['endAt'].toDate().isBefore(DateTime.now())) {
        _showSnackBar(
            'Gura irindi fatabuguzi!', const Color.fromARGB(255, 255, 0, 0));
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    scaffoldMessenger.showSnackBar(_buildSnackBar(message, color));
  }

  SnackBar _buildSnackBar(String message, Color backgroundColor) {
    return SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      action: SnackBarAction(
        label: 'Funga',
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _buildProviders(),
      child: Consumer<AuthState>(builder: (context, authState, _) {
        return Consumer<ProfileModel?>(builder: (context, profile, _) {
          return Consumer<PaymentModel?>(builder: (context, newestPyt, _) {
            return _buildAppBar(context, profile, newestPyt, authState);
          });
        });
      }),
    );
  }

  List<SingleChildWidget> _buildProviders() {
    return [
      StreamProvider<PaymentModel?>.value(
        value: currentUser != null
            ? PaymentService().getNewestPytByUserId(currentUser!.uid)
            : null,
        initialData: null,
        catchError: (context, error) => null,
      ),
      StreamProvider<ProfileModel?>.value(
        value: currentUser != null
            ? ProfileService().getCurrentProfileByID(currentUser!.uid)
            : null,
        initialData: null,
        catchError: (context, error) => null,
      ),
    ];
  }

  AppBar _buildAppBar(BuildContext context, ProfileModel? profile,
      PaymentModel? newestPyt, AuthState authState) {
    String ifatabuguziID = dotenv.env['TRIAL_SUBSCRIPTION_ID'] ?? '';

    if (newestPyt != null) {
      remainingSeconds = newestPyt.getRemainingMilliseconds() ~/ 1000;
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
      title: _buildTitle(context),
      actions: (currentUser != null && profile != null)
          ? _buildActions(context, profile, newestPyt, authState, ifatabuguziID)
          : [],
    );
  }

  List<Widget> _buildActions(BuildContext context, ProfileModel profile,
      PaymentModel? newestPyt, AuthState authState, String ifatabuguziID) {
    return [
      if (newestPyt != null && newestPyt.ifatabuguziID == ifatabuguziID)
        _buildCountdownTimer(context),
      _buildProfileIcon(context, profile, newestPyt, authState),
    ];
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildProfileIcon(BuildContext context, ProfileModel profile,
      PaymentModel? newestPyt, AuthState authState) {
    return IconButton(
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFFBD59), width: 2.0),
        ),
        child: profile.photo == ''
            ? SvgPicture.asset(
                'assets/images/avatar.svg',
                height: MediaQuery.of(context).size.height * 0.048,
                colorFilter: const ColorFilter.mode(
                    const Color(0xFFFFBD59), BlendMode.srcIn),
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(profile.photo ?? ''),
              ),
      ),
      onPressed: () {
        _showProfileDialog(context, profile, newestPyt, authState);
      },
    );
  }

  Widget _buildCountdownTimer(BuildContext context) {
    return CountdownTimer(
      duration: 1 + remainingSeconds,
      onTimerExpired: () {
        ScaffoldMessenger.of(context).showSnackBar(_buildSnackBar(
            'IGERAGEZA RYARANGIYE, GURA IFATABUGUZI!',
            const Color.fromARGB(255, 255, 0, 0)));
      },
    );
  }

  void _showProfileDialog(BuildContext context, ProfileModel profile,
      PaymentModel? newestPyt, AuthState authState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildProfileDialog(context, profile, newestPyt, authState);
      },
    );
  }

  Widget _buildProfileDialog(BuildContext context, ProfileModel profile,
      PaymentModel? newestPyt, AuthState authState) {
    String? email = currentUser?.email;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.024),
        side: BorderSide(
          color: const Color(0xFF5B8BDF),
          width: MediaQuery.of(context).size.width * 0.01,
        ),
      ),
      icon: profile.photo == ''
          ? SvgPicture.asset(
              'assets/images/avatar.svg',
              height: MediaQuery.of(context).size.height * 0.048,
              colorFilter: const ColorFilter.mode(
                  const Color(0xFF5B8BDF), BlendMode.srcIn),
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
          style: const TextStyle(color: const Color(0xFF5B8BDF)),
          textAlign: TextAlign.center,
          TextSpan(
              text: capitalizeWords(
                  currentUser?.displayName ?? profile.username ?? ''),
              style: const TextStyle(fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: '\n${currentUser?.email ?? ''}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 12.0)),
              ]),
        ),
      ),
      backgroundColor: const Color(0xFFFFBD59),
      elevation: 10.0,
      shadowColor: const Color(0xFF5B8BDF),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            (email != 'nidehazard10@gmail.com' && email != 'testing@mail.com')
                ? _buildSubscriptionStatus(context, newestPyt)
                : Container(),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLogoutButton(context, authState),
                _buildAccountDetailsButton(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionStatus(
      BuildContext context, PaymentModel? newestPyt) {
    String ifatabuguziID = dotenv.env['TRIAL_SUBSCRIPTION_ID'] ?? '';

    if (newestPyt == null) {
      return _buildSubscriptionStatusText(context, 'NTA FATABUGUZI URAFATA',
          const Color.fromARGB(255, 255, 0, 0));
    } else if (newestPyt.getRemainingMilliseconds() <= 0) {
      return _buildSubscriptionStatusText(context, 'IFATABUGUZI RYARANGIYE!',
          const Color.fromARGB(255, 255, 0, 0));
    } else if (newestPyt.isApproved == false &&
        newestPyt.getRemainingMilliseconds() > 0) {
      return _buildSubscriptionStatusText(
          context,
          'Mwishyuye, ifatabuguzi ryanyu riri kwigwaho...',
          const Color.fromARGB(255, 255, 0, 0));
    } else if (newestPyt.isApproved == true &&
        newestPyt.getRemainingMilliseconds() > 0) {
      String remainingText = _getRemainingText(newestPyt);
      return Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.012),
            height: MediaQuery.of(context).size.height * 0.002,
            color: const Color(0xFF5B8BDF),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.024),
          _buildSubscriptionStatusText(
              context, 'IFATABUGUZI RYAWE', const Color.fromARGB(255, 0, 0, 0)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.024),
          _buildSubscriptionStatusText(
              context,
              newestPyt.getFormatedEndDate() ==
                      new DateFormat('yyyy-MM-dd').format(DateTime.now())
                  ? 'Rirarangira uyu munsi!'
                  : 'Rizarangira kuri ${newestPyt.getFormatedEndDate()}',
              newestPyt.getFormatedEndDate() ==
                      new DateFormat('yyyy-MM-dd').format(DateTime.now())
                  ? const Color.fromARGB(255, 255, 0, 0)
                  : const Color(0xFF5B8BDF)),
          _buildSubscriptionStatusText(
              context,
              remainingText,
              newestPyt.getRemainingDays() > 1
                  ? const Color(0xFF5B8BDF)
                  : const Color.fromARGB(255, 255, 0, 0)),
          SizedBox(height: MediaQuery.of(context).size.height * 0.024),
          Container(
            margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.012),
            height: MediaQuery.of(context).size.height * 0.002,
            color: const Color(0xFF5B8BDF),
          ),
        ],
      );
    } else if (newestPyt.ifatabuguziID == ifatabuguziID) {
      return _buildSubscriptionStatusText(
          context,
          newestPyt.getRemainingMilliseconds() > 0
              ? 'USIGAJE IMINOTA ${newestPyt.getRemainingMinutes()}, GURA IFATABUGUZI VUBA!'
              : 'IGERAGEZA RYARANGIYE, GURA IFATABUGUZI',
          const Color.fromARGB(255, 255, 0, 0));
    } else {
      return _buildSubscriptionStatusText(context, 'NTA FATABUGUZI MUFITE',
          const Color.fromARGB(255, 255, 0, 0));
    }
  }

  Widget _buildSubscriptionStatusText(
      BuildContext context, String text, Color color) {
    return Align(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: MediaQuery.of(context).size.width * 0.032,
          color: color,
        ),
      ),
    );
  }

  String _getRemainingText(PaymentModel newestPyt) {
    if (newestPyt.getRemainingDays() > 1) {
      return 'Usigaje iminsi ${newestPyt.getRemainingDays()}';
    } else if (newestPyt.getRemainingDays() == 1) {
      return 'Usigaje umunsi umwe!';
    } else if (newestPyt.getRemainingHours() > 1) {
      return 'Usigaje amasaha ${newestPyt.getRemainingHours()}';
    } else if (newestPyt.getRemainingHours() == 1) {
      return 'Usigaje isaha imwe!';
    } else if (newestPyt.getRemainingMinutes() > 1) {
      return 'Usigaje iminota ${newestPyt.getRemainingMinutes()}';
    } else if (newestPyt.getRemainingMinutes() == 1) {
      return 'Usigaje umunota umwe!';
    } else {
      return 'Usigaje Amasegonda make!';
    }
  }

  Widget _buildLogoutButton(BuildContext context, AuthState authState) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        onPressed: () async {
          dynamic result = await authState.logOut();

          _showSnackBar(
              result != null ? result : 'Ntibikunze, ongera ugerageze!',
              const Color(0xFF00A651));
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        icon: Icon(
          Icons.logout,
          size: MediaQuery.of(context).size.width * 0.03,
        ),
        label: Text(
          'Sohoka',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.of(context).size.width * 0.03,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.006,
          ),
          backgroundColor: const Color(0xFF5B8BDF),
          foregroundColor: const Color(0xFFFFBD59),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountDetailsButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed('/account');
        },
        icon: Icon(
          Icons.account_circle,
          size: MediaQuery.of(context).size.width * 0.03,
        ),
        label: Text(
          'Byinshi',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: MediaQuery.of(context).size.width * 0.03,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.006,
          ),
          backgroundColor: const Color(0xFF5B8BDF),
          foregroundColor: const Color(0xFFFFBD59),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.02),
          ),
        ),
      ),
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
