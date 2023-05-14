import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/user.dart';
// import 'package:tegura/screens/auth/auth.dart';
import 'package:tegura/screens/auth/injira.dart';
import 'package:tegura/screens/ibiciro/ibiciro.dart';
import 'package:tegura/screens/iga/iga.dart';
import 'package:tegura/screens/utilities/loading.dart';
import 'package:tegura/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ENTRY POINT OF THE APP - MAIN FUNCTION
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TeguraApp());
}

// MAIN APP WIDGET - STATELESS SINCE IT DOESN'T CHANGE
class TeguraApp extends StatelessWidget {
  const TeguraApp({super.key}); // CONSTRUCTOR

  @override
  Widget build(BuildContext context) {
    // USER STREAM PROVIDER - LISTENS TO AUTH CHANGES
    return StreamProvider<UserModel?>.value(
      value: AuthService().usr,
      initialData: null,
      child: MaterialApp(
        // REMOVE DEBUG BANNER
        debugShowCheckedModeBanner: false,

        // APP THEME
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        // HOME PAGE - LOADING FIRST
        home: const LoadingLightningState(),

        // ROUTES
        routes: {
          '/iga': (context) => const Iga(),
          '/ibiciro': (context) => const Ibiciro(),
          // '/injira': (context) => AuthService().usr == null ? const Auth() : const Auth(),
          '/injira': (context) => const Injira(),
        },
      ),
    );
  }
}
