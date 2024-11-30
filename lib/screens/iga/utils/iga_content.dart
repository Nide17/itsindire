import 'dart:async';

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
  final ScrollController _scrollController = ScrollController();
  bool isMovingForward = true;
  bool loadingNextIsomo = true;
  StreamSubscription<List<CourseProgressModel?>>?
      _finishedProgressesSubscription;

  @override
  void initState() {
    super.initState();
    _skip = _calculateInitialSkip();
    _fetchNextIsomo();
    loadingNextIsomo = false;
  }

  @override
  void dispose() {
    _finishedProgressesSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  int _calculateInitialSkip() {
    if (widget.courseProgress != null &&
        widget.courseProgress.currentIngingo !=
            widget.courseProgress.totalIngingos) {
      return widget.courseProgress.currentIngingo;
    }
    return 0;
  }

  Future<void> _fetchNextIsomo() async {
    try {
      final finishedProgressesStream = CourseProgressService()
          .getFinishedProgresses(FirebaseAuth.instance.currentUser!.uid);

      _finishedProgressesSubscription =
          finishedProgressesStream?.listen((progresses) {
        if (progresses.isNotEmpty) {
          _processFinishedProgresses(progresses);
        }
      }, onError: (error) {
        print('Error fetching finished progresses: $error');
      });
    } catch (e) {
      print('Error fetching next isomo: $e');
    }
  }

  void _processFinishedProgresses(List<CourseProgressModel?> progresses) async {
    final finishedCourses = progresses
        .where((progress) =>
            progress?.currentIngingo == progress?.totalIngingos &&
            progress?.unansweredPopQuestions == 0)
        .toList();

    final finishedCourseIds =
        finishedCourses.map((progress) => progress!.courseId).toSet();

    int irindisomoId = widget.isomo.id + 1;
    IsomoModel? nextIsomoCandidate;

    while (finishedCourseIds.contains(irindisomoId)) {
      irindisomoId++;
    }
    nextIsomoCandidate = await IsomoService().getIsomoById(irindisomoId);

    if (mounted) setState(() => nextIsomo = nextIsomoCandidate);
    if (nextIsomo?.id != null) {
      IngingoService().getTotalIsomoIngingos(widget.isomo.id).listen((event) {
        if (mounted)
          setState(() => nextIsomoTotalIngingos = event.realTotalIngingos);
      });
    }
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
        StreamProvider<List<IngingoModel>>.value(
          value: _skip >= 0
              ? IngingoService().getIngingosByIsomoIdPaginated(
                  widget.isomo.id, ingingosPageLimit, _skip)
              : const Stream<List<IngingoModel>>.empty(),
          initialData: [],
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
                  if (ingingos == null) {
                    return const Scaffold(body: const LoadingWidget());
                  }
                  return loadingNextIsomo
                      ? const LoadingWidget()
                      : _buildContent(context, currentIngingo, totalIngingos,
                          unansweredPopQuestions, popQuestions, usr);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    int currentIngingo,
    int totalIngingos,
    int unansweredPopQuestions,
    List<PopQuestionModel>? popQuestions,
    User? usr,
  ) {
    if (currentIngingo >= totalIngingos && unansweredPopQuestions == 0) {
      return _buildCompletionScreen(context, popQuestions, usr);
    }

    return _buildIngingosScreen(context, currentIngingo, totalIngingos);
  }

  Widget _buildCompletionScreen(
    BuildContext context,
    List<PopQuestionModel>? popQuestions,
    User? usr,
  ) {
    return Scaffold(
      body: ItsindireAlert(
        errorTitle: 'Isomo rirarangiye!',
        errorMsg: 'Wasoje neza ingingo zose zigize iri somo 😄!',
        firstButtonTitle: 'Funga',
        firstButtonFunction: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Hagati()),
            ModalRoute.withName('/iga-landing'),
          );
        },
        firstButtonColor: const Color(0xFFE60000),
        secondButtonTitle: nextIsomo != null ? 'Irindi somo' : '',
        secondButtonFunction: nextIsomo != null
            ? () {
                _startNextIsomo(context, popQuestions, usr);
              }
            : null,
        alertType: 'success',
      ),
    );
  }

  Widget _buildIngingosScreen(
      BuildContext context, int currentIngingo, int totalIngingos) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation = isMovingForward
            ? Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                .animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut))
            : Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                .animate(CurvedAnimation(
                    parent: animation, curve: Curves.easeInOut));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: Scaffold(
        key: ValueKey<int>(_skip),
        backgroundColor: Colors.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarItsindire(),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              automaticallyImplyLeading: false,
              collapsedHeight: MediaQuery.of(context).size.height * 0.042,
              toolbarHeight: MediaQuery.of(context).size.height * 0.042,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.2,
                titlePadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.008,
                ),
                title: Text(
                  widget.isomo.title,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.018,
                    color: const Color.fromARGB(255, 0, 193, 218),
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: ScrollbarTheme(
                data: const ScrollbarThemeData(
                  thumbColor: WidgetStatePropertyAll(Color(0xFF00A651)),
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  child: ContentDetails(
                    isomo: widget.isomo,
                    controller: _scrollController,
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.092,
      decoration: const BoxDecoration(
        color: Colors.white,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    );
  }

  void _startNextIsomo(
      BuildContext context, List<PopQuestionModel>? popQuestions, User? usr) {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ItsindireAlert(
          errorTitle: 'IBIJYANYE NIRI SOMO',
          errorMsg:
              'Ugiye kwiga isomo ryitwa "${nextIsomo!.title}" rigizwe n\’ingingo "${nextIsomoTotalIngingos}" ni iminota "${(nextIsomo!.duration != null && nextIsomo!.duration! > 0) ? nextIsomo!.duration : nextIsomoTotalIngingos * 4}" gusa!',
          firstButtonTitle: 'Inyuma',
          firstButtonFunction: () {
            Navigator.popAndPushNamed(context, '/iga-landing');
          },
          firstButtonColor: const Color(0xFFE60000),
          secondButtonTitle: 'Tangira',
          secondButtonFunction: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IgaContent(
                  isomo: nextIsomo!,
                  courseProgress: CourseProgressModel(
                    id: '${nextIsomo!.id}_${usr!.uid}',
                    userId: usr.uid,
                    totalIngingos: nextIsomoTotalIngingos,
                    currentIngingo: 0,
                    courseId: nextIsomo!.id,
                    unansweredPopQuestions: popQuestions!.length,
                  ),
                  thisCourseTotalIngingos: widget.thisCourseTotalIngingos,
                ),
              ),
            );
          },
          secondButtonColor: const Color(0xFF00A651),
        );
      },
    );
  }
}
