import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/ifatabuguzi_db.dart';
import 'package:itsindire/firebase_services/profiledb.dart';
import 'package:itsindire/main.dart';
import 'package:itsindire/models/ifatabuguzi.dart';
import 'package:itsindire/models/profile.dart';
import 'package:itsindire/screens/ibiciro/ifatabuguzi.dart';
import 'package:itsindire/screens/iga/utils/gradient_title.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/description.dart';
import 'package:itsindire/utilities/no_internet.dart';
import 'package:provider/provider.dart';

class Ibiciro extends StatefulWidget {
  final String? message;
  const Ibiciro({super.key, this.message});

  @override
  State<Ibiciro> createState() => _IbiciroState();
}

class _IbiciroState extends State<Ibiciro> {
  bool everDisconnected = false;
  bool isUrStudent = false;
  List<IfatabuguziModel?> subscriptionsToUse = [];

  @override
  Widget build(BuildContext context) {
    final conn = Provider.of<ConnectionStatus>(context);

    if (conn.isOnline == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              textAlign: TextAlign.center,
              isUrStudent == true
                  ? 'No internet connection!'
                  : 'Nta internet mufite!.',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 255, 8, 0),
            duration: const Duration(seconds: 3),
          ),
        );
      });
      everDisconnected = true;
    }

    if (conn.isOnline == true && everDisconnected == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isUrStudent == true ? 'Back online!' : 'Internet yagarutse!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 0, 255, 85),
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }

    return MultiProvider(
      providers: [
        StreamProvider<ProfileModel?>.value(
          value: FirebaseAuth.instance.currentUser != null
              ? ProfileService()
                  .getCurrentProfileByID(FirebaseAuth.instance.currentUser!.uid)
              : null,
          initialData: null,
          catchError: (context, error) => null,
        ),
        StreamProvider<List<IfatabuguziModel?>?>.value(
          value: IfatabuguziService().amafatabuguzi,
          initialData: null,
          catchError: (context, error) {
            return [];
          },
        ),
      ],
      child: Consumer<ProfileModel?>(builder: (context, profile, _) {
        if (profile != null) {
          isUrStudent = profile.urStudent ?? false;
        }

        return Consumer<List<IfatabuguziModel?>?>(
            builder: (context, amafatabuguzi, _) {
          if (amafatabuguzi != null) {
            if (profile != null && profile.urStudent == true) {
              subscriptionsToUse = amafatabuguzi
                  .where((element) => element!.type == 'ur')
                  .toList();
            } else {
              subscriptionsToUse = amafatabuguzi
                  .where((element) => element!.type == 'standard')
                  .toList();
            }
          }
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 71, 103, 158),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(58.0),
              child: AppBarItsindire(),
            ),
            body: conn.isOnline == false
                ? const NoInternet()
                : ScrollbarTheme(
                    data: ScrollbarThemeData(
                      thumbColor: WidgetStateProperty.all(Color(0xFFFFBD59)),
                    ),
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          widget.message != null
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                  ),
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * 0.04,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDE59),
                                    border: Border.all(
                                      width: 2.0,
                                      color: const Color.fromARGB(
                                          255, 255, 204, 0),
                                    ),
                                    borderRadius: BorderRadius.circular(24.0),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromARGB(255, 59, 57, 77),
                                        offset: Offset(0, 3),
                                        blurRadius: 8,
                                        spreadRadius: -7,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.message!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          fontWeight: FontWeight.w900,
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          GradientTitle(
                              title: isUrStudent == true
                                  ? ' UR STUDENTS PACKAGES'
                                  : 'IBICIRO BYO KWIGA',
                              icon: 'assets/images/ibiciro.svg'),
                          Description(
                              text: profile?.urStudent == true
                                  ? 'Please pay for the package you want to use, then start learning.'
                                  : 'Ishyura amafaranga ahwanye n\'ifatabuguzi wifuza, uhite utangira kwiga.'),
                          Column(
                            children:
                                subscriptionsToUse.asMap().entries.map((entry) {
                              int index = entry.key;
                              final IfatabuguziModel? item = entry.value;
                              return Ifatabuguzi(
                                  index: index,
                                  ifatabuguzi: item ?? IfatabuguziModel(
                                    id: '',
                                    igihe: '',
                                    igiciro: 0,
                                    ibirimo: [],
                                    ubusobanuro: '',
                                    type: '',
                                  ),
                                  curWidget: runtimeType.toString(),
                                  isUrStudent: isUrStudent);
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
      }),
    );
  }
}