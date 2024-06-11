import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/profiledb.dart';
import 'package:tegura/models/profile.dart';
import 'firebase_options.dart';
import 'firebase_services/isuzuma_score_db.dart';

import 'package:tegura/firebase_services/auth.dart';
import 'package:tegura/firebase_services/ibibazo_bibaza_db.dart';
import 'package:tegura/firebase_services/ifatabuguzi_db.dart';
import 'package:tegura/firebase_services/isuzuma_db.dart';
import 'package:tegura/firebase_services/payment_db.dart';
import 'package:tegura/firebase_services/isomo_progress.dart';
import 'package:tegura/firebase_services/isomo_db.dart';

import 'package:tegura/models/ibibazo_bibaza.dart';
import 'package:tegura/models/ifatabuguzi.dart';
import 'package:tegura/models/isuzuma.dart';
import 'package:tegura/models/isuzuma_score.dart';
import 'package:tegura/models/payment.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/isomo.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:tegura/screens/auth/injira.dart';
import 'package:tegura/screens/auth/iyandikishe.dart';
import 'package:tegura/screens/auth/ur_student.dart';
import 'package:tegura/screens/auth/wibagiwe.dart';
import 'package:tegura/screens/ibiciro/ibiciro.dart';
import 'package:tegura/screens/iga/iga_landing.dart';

import 'package:tegura/utilities/loading_lightning.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TeguraApp());
}

class ConnectionStatus extends ChangeNotifier {
  bool isOnline = false;

  void setOnline() {
    isOnline = true;
    notifyListeners();
  }

  void setOffline() {
    isOnline = false;
    notifyListeners();
  }

  void toggle() {
    isOnline = !isOnline;
    notifyListeners();
  }

  void set(bool value) {
    isOnline = value;
    notifyListeners();
  }
}

class TeguraApp extends StatefulWidget {
  const TeguraApp({super.key});
  @override
  State<TeguraApp> createState() => _TeguraAppState();
}

class _TeguraAppState extends State<TeguraApp> {
  List<ConnectivityResult> _connectionStatusList = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late ConnectionStatus _currentStatus;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _currentStatus = ConnectionStatus();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatusList);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();

      if (result.contains(ConnectivityResult.none)) {
        _currentStatus.setOffline();
      } else {
        _currentStatus.setOnline();
      }
    } on PlatformException catch (e) {
      print(e.toString());
      _currentStatus.setOffline();
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatusList(result);
  }

  Future<void> _updateConnectionStatusList(
      List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatusList = result;
    });

    if (_connectionStatusList.contains(ConnectivityResult.none)) {
      _currentStatus.setOffline();
    } else {
      _currentStatus.setOnline();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectionStatus>(
          create: (context) => _currentStatus,
        ),
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => ProfileService()),
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
        StreamProvider<List<IsomoModel?>?>.value(
          value: IsomoService()
              .getAllAmasomo(FirebaseAuth.instance.currentUser?.uid),
          initialData: null,
          catchError: (context, error) {
            return [];
          },
        ),
        StreamProvider<List<CourseProgressModel?>?>.value(
          value: CourseProgressService()
              .getUserProgresses(FirebaseAuth.instance.currentUser?.uid),
          initialData: null,
          catchError: (context, error) {
            return [];
          },
        ),
        StreamProvider<List<IfatabuguziModel?>?>.value(
          value: IfatabuguziService().amafatabuguzi,
          initialData: null,
          catchError: (context, error) {
            return [];
          },
        ),
        StreamProvider<List<IbibazoBibazaModel>>.value(
          value: IbibazoBibazaService().ibibazoBibaza,
          initialData: const [],
        ),
        StreamProvider<List<IsuzumaModel>?>.value(
          value: IsuzumaService().amasuzumabumenyi,
          initialData: null,
          catchError: (context, error) {
            return [];
          },
        ),
        StreamProvider<List<IsuzumaScoreModel>?>.value(
          value: IsuzumaScoreService()
              .getScoresByTakerID(FirebaseAuth.instance.currentUser?.uid ?? ''),
          initialData: null,
          catchError: (context, error) {
            return [];
          },
        ),
      ],
      child: Consumer<AuthState>(builder: (context, authState, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const LoadingLightning(
            duration: 4,
          ),
          routes: {
            '/iga-landing': (context) => const IgaLanding(),
            '/ibiciro': (context) => const Ibiciro(),
            '/injira': (context) => const Injira(),
            '/iyandikishe': (context) => const Iyandikishe(),
            '/ur-student': (context) => const UrStudent(),
            '/wibagiwe': (context) => const Wibagiwe(),
          },
        );
      }),
    );
  }
}
