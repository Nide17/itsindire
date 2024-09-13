import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/firebase_services/pop_question_db.dart';
import 'package:itsindire/firebase_services/isomo_db.dart';
import 'package:itsindire/firebase_services/ingingo_db.dart';
import 'package:itsindire/firebase_services/isomo_progress.dart';
import 'package:itsindire/models/pop_question.dart';
import 'package:itsindire/models/course_progress.dart';
import 'package:itsindire/models/ingingo.dart';
import 'package:itsindire/models/isomo.dart';
import 'package:itsindire/screens/iga/hagati/hagati.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:itsindire/screens/iga/utils/circle_progress.dart';
import 'package:itsindire/screens/iga/utils/content_details.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/direction_button.dart';
import 'package:itsindire/utilities/loading_widget.dart';

class IgaContent extends StatefulWidget {
  final IsomoModel isomo;
  final dynamic courseProgress;
  final int thisCourseTotalIngingos;

  const IgaContent({
    super.key,
    required this.isomo,
    required this.courseProgress,
    required this.thisCourseTotalIngingos,
  });

  @override
  State<IgaContent> createState() => _IgaContentState();
}

class _IgaContentState extends State<IgaContent> {
  int _skip = 0;
  int _increment = 0;
  IsomoModel? nextIsomo;
  int nextIsomoTotalIngingos = 0;
  bool _isMounted = false;
  bool loadingTotalIngingos = true;
  final ScrollController _scrollController = ScrollController();
  bool isMovingForward = true;

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

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  void changeSkipNumber(int number) {
    setState(() {
      _skip += number;
      if (_skip < 0) {
        _skip = 0;
        Navigator.pop(context);
      }
      isMovingForward = number > 0;
      _increment = isMovingForward ? 5 : -5;
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
          catchError: (context, error) => [],
        ),
        StreamProvider<CourseProgressModel?>.value(
          value: CourseProgressService().getProgress(usr?.uid, widget.isomo.id),
          initialData: null,
          catchError: (context, error) => null,
        ),
        StreamProvider<List<PopQuestionModel>?>.value(
          value: PopQuestionService().getPopQuestionsByIsomoID(widget.isomo.id),
          initialData: null,
          catchError: (context, error) => [],
        ),
      ],
      child: Consumer<CourseProgressModel?>(
        builder: (context, progress, _) {
          final int totalIngingos =
              progress?.totalIngingos ?? widget.courseProgress.totalIngingos;
          final int currentIngingo =
              progress?.currentIngingo ?? widget.courseProgress.currentIngingo;
          final int unansweredPopQuestions = progress?.unansweredPopQuestions ??
              widget.courseProgress.unansweredPopQuestions;

          return Consumer<List<PopQuestionModel>?>(
            builder: (context, popQuestions, _) {
              return Consumer<List<IngingoModel>?>(
                builder: (context, ingingos, _) {
                  return ingingos == null
                      ? const Scaffold(body: LoadingWidget())
                      : currentIngingo >= totalIngingos &&
                              unansweredPopQuestions == 0
                          ? Scaffold(
                              body: ItsindireAlert(
                                errorTitle: 'Isomo rirarangiye!',
                                errorMsg:
                                    'Wasoje neza ingingo zose zigize iri somo 🙂!',
                                firstButtonTitle: 'Funga',
                                firstButtonFunction: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Hagati()),
                                    ModalRoute.withName('/iga-landing'),
                                  );
                                },
                                firstButtonColor: const Color(0xFFE60000),
                                secondButtonTitle:
                                    nextIsomo != null ? 'Irindi somo' : '',
                                secondButtonFunction: nextIsomo != null
                                    ? () {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return ItsindireAlert(
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
                                                    builder: (context) =>
                                                        IgaContent(
                                                      isomo: nextIsomo!,
                                                      courseProgress:
                                                          CourseProgressModel(
                                                        id: '${nextIsomo!.id}_${usr!.uid}',
                                                        userId: usr.uid,
                                                        totalIngingos:
                                                            nextIsomoTotalIngingos,
                                                        currentIngingo: 0,
                                                        courseId: nextIsomo!.id,
                                                        unansweredPopQuestions:
                                                            popQuestions!
                                                                .length,
                                                      ),
                                                      thisCourseTotalIngingos:
                                                          widget
                                                              .thisCourseTotalIngingos,
                                                    ),
                                                  ),
                                                );
                                              },
                                              secondButtonColor:
                                                  const Color(0xFF00A651),
                                            );
                                          },
                                        );
                                      }
                                    : null,
                                alertType: 'success',
                              ),
                            )
                          : AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                final offsetAnimation = isMovingForward
                                    ? Tween<Offset>(
                                            begin: const Offset(1.0, 0.0),
                                            end: Offset.zero)
                                        .animate(animation)
                                    : Tween<Offset>(
                                            begin: const Offset(-1.0, 0.0),
                                            end: Offset.zero)
                                        .animate(animation);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              child: Scaffold(
                                key: ValueKey<int>(_skip),
                                backgroundColor: Colors.white,
                                appBar: PreferredSize(
                                  preferredSize: Size.fromHeight(58.0),
                                  child: AppBarItsindire(),
                                ),
                                body: ScrollbarTheme(
                                  data: ScrollbarThemeData(
                                    thumbColor: WidgetStateProperty.all(
                                        const Color(0xFF00A651)),
                                  ),
                                  child: Scrollbar(
                                    controller: _scrollController,
                                    child: ContentDetails(
                                      isomo: widget.isomo,
                                      controller: _scrollController,
                                    ),
                                  ),
                                ),
                                bottomNavigationBar: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFBD59),
                                        offset: const Offset(0, 2),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Center(
                                        child: Text(
                                          widget.isomo.title,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                            color: Color.fromARGB(255, 0, 193, 218),
                                            fontWeight: FontWeight.w900,
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
                                            isomo: widget.isomo,
                                          ),
                                          const CircleProgress(),
                                          DirectionButton(
                                            buttonText: 'komeza',
                                            direction: 'komeza',
                                            opacity: 1,
                                            skip: _skip,
                                            increment: _increment,
                                            changeSkipNumber: changeSkipNumber,
                                            scrollTop: _scrollToTop,
                                            isomo: widget.isomo,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                },
              );
            },
          );
        },
      ),
    );
  }
}
