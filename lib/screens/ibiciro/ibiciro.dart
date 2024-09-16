import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/ifatabuguzi_db.dart';
import 'package:tegura/main.dart';
import 'package:tegura/models/ifatabuguzi.dart';
import 'package:tegura/models/profile.dart';
import 'package:tegura/screens/ibiciro/ifatabuguzi.dart';
import 'package:tegura/screens/ibiciro/subscription.dart';
import 'package:tegura/screens/iga/utils/gradient_title.dart';
import 'package:tegura/utilities/description.dart';
import 'package:tegura/utilities/app_bar.dart';
import 'package:tegura/utilities/loading_widget.dart';
import 'package:tegura/utilities/no_internet.dart';

class Ibiciro extends StatefulWidget {
  final String? message;
  const Ibiciro({super.key, this.message});

  @override
  State<Ibiciro> createState() => _IbiciroState();
}

class _IbiciroState extends State<Ibiciro> {
  @override
  Widget build(BuildContext context) {
    final conn = Provider.of<ConnectionStatus>(context);
    bool everDisconnected = false;
    List<IfatabuguziModel?> subscriptionsToUse = [];

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
        StreamProvider<List<IfatabuguziModel?>?>.value(
          value: IfatabuguziService().amafatabuguzi,
          initialData: null,

          catchError: (context, error) {
            return [];
          },
        ),
      ],
      child: Consumer<ProfileModel?>(builder: (context, profile, _) {
        return Consumer<List<IfatabuguziModel?>?>(
            builder: (context, amafatabuguzi, child) {
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

          if (amafatabuguzi == null) {
            return const LoadingWidget();
          } else {
            return Scaffold(
                backgroundColor: const Color.fromARGB(255, 71, 103, 158),
                appBar: const PreferredSize(
                  preferredSize: Size.fromHeight(58.0),
                  child: AppBarTegura(),
                ),
                body:
                    conn.isOnline == false
                        ? const NoInternet() :
                        ListView(
                            children: [
                              widget.message != null
                                  ? Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.03,
                                      ),
                                      padding: EdgeInsets.all(
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFDE59),
                                        border: Border.all(
                                          width: 2.0,
                                          color: const Color.fromARGB(
                                              255, 255, 204, 0),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        boxShadow: const [
                                          BoxShadow(
                                            color:
                                                Color.fromARGB(255, 59, 57, 77),
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
                              const GradientTitle(
                                  title: 'IBICIRO BYO KWIGA',
                                  icon: 'assets/images/ibiciro.svg'),
                              Description(
                                  text: profile?.urStudent == true
                                      ? 'Please pay for the package you want to use, then start learning.'
                                      : 'Ishyura amafaranga ahwanye n\'ifatabuguzi wifuza, uhite utangira kwiga.'),
                              Column(
                                children: subscriptionsToUse
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  int index = entry.key;
                                  final IfatabuguziModel? item = entry.value;

                                  if (profile?.urStudent == true &&
                                      item!.type == 'ur') {
                                    return Subscription(
                                      title: 'PACK NO. ${index + 1}',
                                      ifatabuguzi: item,
                                      curWidget: runtimeType.toString(),
                                    );
                                  } else {
                                    return Ifatabuguzi(
                                        title: 'IFATABUGUZI RYA ${index + 1}',
                                        ifatabuguzi: item ??
                                            IfatabuguziModel(
                                              id: '',
                                              igihe: '',
                                              igiciro: 0,
                                              ibirimo: [],
                                              ubusobanuro: '',
                                              type: '',
                                            ),
                                        curWidget: runtimeType.toString());
                                  }
                                }).toList(),
                              ),
                            ],
                          ));
          }
        });
      }),
    );
  }
}
