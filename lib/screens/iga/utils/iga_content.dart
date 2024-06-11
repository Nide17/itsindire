import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/isomo_db.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/ingingo.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/firebase_services/isomo_progress.dart';
import 'package:tegura/screens/iga/utils/tegura_alert.dart';
import 'package:tegura/screens/iga/wasoje/wasoje.dart';
import 'package:tegura/utilities/app_bar.dart';
import 'package:tegura/utilities/direction_button.dart';
import 'package:tegura/firebase_services/ingingo_db.dart';
import 'package:tegura/screens/iga/utils/circle_progress.dart';
import 'package:tegura/screens/iga/utils/content_details.dart';
import 'package:tegura/utilities/loading_widget.dart';

class IgaContent extends StatefulWidget {
  final IsomoModel isomo;
  final dynamic courseProgress;
  final int thisCourseTotalIngingos;

  const IgaContent(
      {super.key,
      required this.isomo,
      required this.courseProgress,
      required this.thisCourseTotalIngingos});

  @override
  State<IgaContent> createState() => _IgaContentState();
}

class _IgaContentState extends State<IgaContent> {
  int _skip = 0;
  int _increment = 0;
  final ScrollController _scrollController = ScrollController();
  IsomoModel? nextIsomo;
  int nextIsomoTotalIngingos = 0;
  bool _isMounted = false;
  bool loadingTotalIngingos = true;

  // getIsomoById
  Future<void> getNextIsomo() async {
    final IsomoModel? irindisomo =
        await IsomoService().getIsomoById(widget.isomo.id + 1);
    if (_isMounted) {
      setState(() {
        nextIsomo = irindisomo;
      });
    }
  }

  Future<void> getNextIsomoTotalIngingos() async {
    Stream<IsomoIngingoSum> totalIngingos =
        IngingoService().getTotalIsomoIngingos(widget.isomo.id + 1);

    totalIngingos.listen((event) {
      setState(() {
        nextIsomoTotalIngingos = event.totalIngingos;
        loadingTotalIngingos = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _skip = (widget.courseProgress != null &&
            widget.courseProgress.currentIngingo !=
                widget.courseProgress.totalIngingos)
        ? widget.courseProgress.currentIngingo
        : 0;

    _isMounted = true;
    getNextIsomo();
    getNextIsomoTotalIngingos();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isMounted = false;
    super.dispose();
  }

  _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  void changeSkipNumber(int number) {
    setState(() {
      _skip = _skip + number;
      if (_skip < 0) {
        _skip = 0;
        Navigator.pop(context);
      }

      if (number > 0) {
        _increment = 5;
      } else {
        _increment = -5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final usr = FirebaseAuth.instance.currentUser;
    const int ingingosPageLimit = 5;

    return MultiProvider(
      providers: [
        StreamProvider<List<IngingoModel>?>.value(
          value: _skip >= 0
              ? IngingoService().getIngingosByIsomoIdPaginated(
                  widget.isomo.id, ingingosPageLimit, _skip)
              : const Stream<List<IngingoModel>?>.empty(),
          initialData: null,
          catchError: (context, error) {
            return [];
          },
        ),
        StreamProvider<CourseProgressModel?>.value(
          value: CourseProgressService().getProgress(usr?.uid, widget.isomo.id),
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
      ],
      child: Consumer<CourseProgressModel?>(
        builder: (context, progress, _) {
          final int totalIngingos = progress != null
              ? progress.totalIngingos
              : widget.courseProgress.totalIngingos;
          final int currentIngingo = progress != null
              ? progress.currentIngingo
              : widget.courseProgress.currentIngingo;

          return Consumer<List<IngingoModel>?>(
            builder: (context, ingingos, _) {
              return ingingos == null
                  ? const Scaffold(
                      body: LoadingWidget(),
                    )
                  : currentIngingo >= totalIngingos
                      ? Scaffold(
                          body: TeguraAlert(
                              errorTitle: 'Isomo rirarangiye!',
                              errorMsg:
                                  'Wasoje neza ingingo zose zigize iri somo 🙂!',
                              firstButtonTitle: 'Funga',
                              firstButtonFunction: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Wasoje()),
                                  ModalRoute.withName('/iga-landing'),
                                );
                              },
                              firstButtonColor: const Color(0xFFE60000),
                              secondButtonTitle:
                                  nextIsomo != null ? 'Irindi somo' : '',
                              secondButtonFunction: nextIsomo != null
                                  ? () {
                                      // Open dialog for next isomo in the list using TeguraAlert
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return TeguraAlert(
                                              errorTitle: 'IBIJYANYE NIRI SOMO',
                                              errorMsg:
                                                  'Ugiye kwiga isomo ryitwa "${nextIsomo!.title}" rigizwe n’ingingo "${nextIsomoTotalIngingos}" ni iminota "${(nextIsomo!.duration != null && nextIsomo!.duration! > 0) ? nextIsomo!.duration : nextIsomoTotalIngingos * 3}" gusa!',
                                              firstButtonTitle: 'Inyuma',
                                              firstButtonFunction: () {
                                                Navigator.popAndPushNamed(
                                                    context, '/iga-landing');
                                              },
                                              firstButtonColor:
                                                  const Color(0xFFE60000),
                                              secondButtonTitle: 'Tangira',
                                              secondButtonFunction: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => IgaContent(
                                                            isomo: nextIsomo!,
                                                            courseProgress: CourseProgressModel(
                                                                id:
                                                                    '${nextIsomo!.id}_${usr!.uid}',
                                                                userId: usr.uid,
                                                                totalIngingos:
                                                                    nextIsomoTotalIngingos,
                                                                currentIngingo:
                                                                    0,
                                                                courseId:
                                                                    nextIsomo!
                                                                        .id),
                                                            thisCourseTotalIngingos:
                                                                widget
                                                                    .thisCourseTotalIngingos)));
                                              },
                                              secondButtonColor:
                                                  const Color(0xFF00A651),
                                            );
                                          });
                                    }
                                  : null,
                              alertType: 'success'),
                        )
                      : Scaffold(
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          appBar: PreferredSize(
                            preferredSize: Size.fromHeight(58.0),
                            child: AppBarTegura(),
                          ),
                          body: ScrollbarTheme(
                            data: ScrollbarThemeData(
                              thumbColor:
                                  WidgetStateProperty.all(Color(0xFF00A651)),
                            ),
                            child: Scrollbar(
                              controller: _scrollController,
                              child: ContentDetails(
                                  isomo: widget.isomo,
                                  controller: _scrollController),
                            ),
                          ),
                          bottomNavigationBar: Container(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFFBD59),
                                  offset: Offset(0, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: Text(
                                    widget.isomo.title,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                      color: const Color(0xFF9D14DD),
                                      fontWeight: FontWeight.w900,
                                      decoration: TextDecoration.underline,
                                      decorationColor: const Color(0xFF0500E5),
                                      decorationThickness: 4.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    DirectionButton(
                                        buttonText: 'inyuma',
                                        direction: 'inyuma',
                                        opacity: 1,
                                        skip: _skip,
                                        increment: _increment,
                                        changeSkipNumber: changeSkipNumber,
                                        scrollTop: _scrollToTop,
                                        isomo: widget.isomo),
                                    const CircleProgress(),
                                    DirectionButton(
                                        buttonText: 'komeza',
                                        direction: 'komeza',
                                        opacity: 1,
                                        skip: _skip,
                                        increment: _increment,
                                        changeSkipNumber: changeSkipNumber,
                                        scrollTop: _scrollToTop,
                                        isomo: widget.isomo),
                                  ],
                                ),
                              ],
                            ),
                          ));
            },
          );
        },
      ),
    );
  }
}
