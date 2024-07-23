import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default Firebase configuration options for the current platform.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpmCP0X8--RA3xmgwvdRH8p4ckH70_56I',
    appId: '1:1080577461306:android:b335d3ced0dbadd8b8f903',
    messagingSenderId: '1080577461306',
    projectId: 'tegura-rw',
    storageBucket: 'tegura-rw.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBtvrbE_PhQDmY_mRVAZ2DnXfjbU6NtWds',
    appId: '1:1080577461306:ios:fcc099783162d587b8f903',
    messagingSenderId: '1080577461306',
    projectId: 'tegura-rw',
    storageBucket: 'tegura-rw.appspot.com',
    iosClientId:
        '1080577461306-ng1nidkiuq62jub56othtrdigj13tfnu.apps.googleusercontent.com',
    iosBundleId: 'com.example.itsindire',
  );
}
