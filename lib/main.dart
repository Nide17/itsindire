import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/profile.dart';
import 'package:tegura/screens/auth/injira.dart';
import 'package:tegura/screens/auth/iyandikishe.dart';
import 'package:tegura/screens/auth/ur_student.dart';
import 'package:tegura/screens/auth/wibagiwe.dart';
import 'package:tegura/screens/ibiciro/ibiciro.dart';
import 'package:tegura/screens/iga/iga.dart';
import 'package:tegura/screens/utilities/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tegura/services/auth.dart';
import 'package:tegura/services/database.dart';
import 'firebase_options.dart';
import 'package:tegura/models/user.dart';

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

    return MultiProvider(
      providers: [
        // PROVIDE FIREBASE FIRESTORE INSTANCE - DB REFERENCE TO PROFILES COLLECTION
        StreamProvider<ProfileModel?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: DatabaseService()
              .getCurrentUser(FirebaseAuth.instance.currentUser?.uid),
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error in main2: $error");
              print(
                  "The err: ${DatabaseService().getCurrentUser(FirebaseAuth.instance.currentUser?.uid)}");
            }
            // RETURN NULL
            return null;
          },
        ),

        // PROVIDE FIREBASE AUTH INSTANCE
        StreamProvider<UserModel?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: AuthService().getUser,
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error in main: $error");
            }

            // RETURN NULL
            return null;
          },
        ),
      ],
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
          '/iyandikishe': (context) => const Iyandikishe(),
          '/ur-student': (context) => const UrStudent(),
          '/wibagiwe': (context) => const Wibagiwe(),
        },
      ),
    );
  }
}
