import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/models/profile.dart';
import 'package:tegura/screens/auth/injira.dart';
import 'package:tegura/screens/auth/iyandikishe.dart';
import 'package:tegura/screens/auth/ur_student.dart';
import 'package:tegura/screens/auth/wibagiwe.dart';
import 'package:tegura/screens/ibiciro/ibiciro.dart';
import 'package:tegura/screens/iga/iga_landing.dart';
import 'package:tegura/firebase_services/isomo_progress.dart';
import 'package:tegura/utilities/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tegura/firebase_services/auth.dart';
import 'package:tegura/firebase_services/profiledb.dart';
import 'package:tegura/firebase_services/isomodb.dart';
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
    // RETURN THE APP
    return MultiProvider(
      providers: [
        // PROVIDE FIREBASE FIRESTORE INSTANCE - DB REFERENCE TO PROFILES COLLECTION
        StreamProvider<ProfileModel?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: FirebaseAuth.instance.currentUser != null
              ? ProfileService()
                  .getCurrentProfile(FirebaseAuth.instance.currentUser!.uid)
              : null,

          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error in main2 user: $error");
              print(
                  "The err: ${FirebaseAuth.instance.currentUser != null ? ProfileService().getCurrentProfile(FirebaseAuth.instance.currentUser!.uid) : null}");
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
        // PROVIDE FIREBASE FIRESTORE INSTANCE - DB REFERENCE TO PROFILES COLLECTION
        StreamProvider<List<IsomoModel?>?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: IsomoService()
              .getAllAmasomo(FirebaseAuth.instance.currentUser?.uid),
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error in main2 isomo: $error");
              print(
                  "The err: ${IsomoService().getAllAmasomo(FirebaseAuth.instance.currentUser?.uid)}");
            }
            // RETURN NULL
            return null;
          },
        ),

        StreamProvider<List<CourseProgressModel?>?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: CourseProgressService()
              .getUserProgresses(FirebaseAuth.instance.currentUser?.uid),
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error in get progress: $error");
              print(
                  "The err: ${CourseProgressService().getUserProgresses(FirebaseAuth.instance.currentUser?.uid)}");
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
        theme: ThemeData(primarySwatch: Colors.blue),

        // HOME PAGE - LOADING FIRST
        home: const LoadingLightning(),

        // ROUTES
        routes: {
          '/iga-landing': (context) => const IgaLanding(),
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
