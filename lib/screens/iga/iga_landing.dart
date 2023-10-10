import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tegura/main.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/screens/ibiciro/reba_ibiciro_button.dart';
import 'package:tegura/utilities/appbar.dart'; // APP BAR
import 'package:tegura/screens/iga/iga_data.dart';
import 'package:tegura/firebase_services/isomodb.dart';
import 'package:tegura/utilities/no_internet.dart'; // DATA FOR THE IGA PAGE

class IgaLanding extends StatefulWidget {
  const IgaLanding({Key? key}) : super(key: key);

  @override
  State<IgaLanding> createState() => _IgaLandingState();
}

class _IgaLandingState extends State<IgaLanding> {
  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    final conn = Provider.of<ConnectionStatus>(context);
    print("conn in ibiciro ${conn.isOnline}");
    bool everDisconnected = false;

    // WHEN CONNECTION IS LOST, NOTIFY USER. IF IT COMES BACK AFTER BEING LOST NOTIFY USER TOO
    if (conn.isOnline == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              textAlign: TextAlign.center,
              'Nta internet mufite!.',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 255, 8, 0),
            duration: Duration(seconds: 3),
          ),
        );
      });
      everDisconnected = true;
    }

    // WHEN CONNECTION IS BACK, NOTIFY USER
    if (conn.isOnline == true && everDisconnected == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Internet yagarutse!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Color.fromARGB(255, 0, 255, 85),
            duration: Duration(seconds: 3),
          ),
        );
      });
    }

    return MultiProvider(
      providers: [
        // PROVIDE FIREBASE FIRESTORE INSTANCE - DB REFERENCE TO PROFILES COLLECTION
        StreamProvider<List<IsomoModel?>?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: null,
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error in iga landing: $error");
              print(
                  "The err: ${IsomoService().getAllAmasomo(FirebaseAuth.instance.currentUser?.uid)}");
            }
            // RETURN NULL
            return [];
          },
        ),
      ],
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 71, 103, 158),

          // APP BAR
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(58.0),
            child: AppBarTegura(),
          ),

          // PAGE BODY
          body:
              // IF THERE IS NO INTERNET - SHOW "No internet" and BUTTON UNDER IT TO REFRESH BOTH CENTERED HOR. AND VERT.
              conn.isOnline == false
                  ? const NoInternet()
                  : ListView(
                      // CHILDREN OF THE COLUMN WIDGET
                      children: igaList.asMap().entries.map((entry) {
                        final bool isFirst = entry.key == 0;
                        final bool isLast = entry.key == igaList.length - 1;
                        final double height = isFirst
                            ? MediaQuery.of(context).size.height * 0.06
                            : MediaQuery.of(context).size.height * 0.025;
                        final Map<String, dynamic> item = entry.value;

                        return Column(
                          children: <Widget>[
                            // 1. VERTICAL SPACE
                            SizedBox(height: height),

                            // 2. BUTTON CONTAINER WIDGET
                            Container(
                              width: MediaQuery.of(context).size.width * .9,
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.012,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.025,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00CCE5),
                                borderRadius: BorderRadius.circular(30.0),
                              ),

                              // GestureDetector WIDGET, ROW WITH ICON AND TEXT - BUTTON
                              child: GestureDetector(
                                // NAVIGATE TO THE CHILD PAGE
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              item['screen']));
                                },
                                child: Row(
                                  children: <Widget>[
                                    // HORIZONTAL SPACE
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.025,
                                    ),

                                    // SVG ICON
                                    SvgPicture.asset(
                                      item['icon'],
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                    ),

                                    // HORIZONTAL SPACE
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.025,
                                    ),

                                    // TEXT WIDGET
                                    Text(item['text'],
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.045,
                                          color: const Color(0xFF000000),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ),

                            // 3. BOTTOM BORDER IF LAST ITEM
                            if (isLast)
                              Column(children: <Widget>[
                                // VERTICAL SPACE
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),

                                // BOTTOM BORDER
                                Container(
                                  color: const Color(0xFF000000),
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),

                                // VERTICAL SPACE
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                              ])
                          ],
                        );
                      }).toList(),
                    ),
          bottomNavigationBar: const RebaIbiciro()),
    );
  }
}
