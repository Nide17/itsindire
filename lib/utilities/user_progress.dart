import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/auth.dart';
import 'package:itsindire/firebase_services/payment_db.dart';
import 'package:itsindire/firebase_services/profiledb.dart';
import 'package:itsindire/screens/auth/iyandikishe.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/firebase_services/ingingo_db.dart';
import 'package:itsindire/models/course_progress.dart';
import 'package:itsindire/models/isomo.dart';
import 'package:itsindire/models/payment.dart';
import 'package:itsindire/models/profile.dart';
import 'package:itsindire/screens/ibiciro/ibiciro.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:itsindire/screens/iga/utils/iga_content.dart';
import 'package:itsindire/screens/iga/utils/isuzume_content.dart';

class UserProgress extends StatefulWidget {
  final IsomoModel isomo;
  final CourseProgressModel? courseProgress;

  const UserProgress({
    super.key,
    required this.isomo,
    required this.courseProgress,
  });

  @override
  State<UserProgress> createState() => _UserProgressState();
}

class _UserProgressState extends State<UserProgress> {
  int thisCourseTotalIngingos = 0;
  bool loadingRealTotalIngingos = true;
  User? currentUser;

  Future<void> getTotalIngingos() async {
    Stream<IsomoIngingoSum> totalIngingos =
        IngingoService().getTotalIsomoIngingos(widget.isomo.id);

    totalIngingos.listen((event) {
      setState(() {
        thisCourseTotalIngingos = event.totalIngingos;
        loadingRealTotalIngingos = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        currentUser =
            Provider.of<AuthState>(context, listen: false).currentUser;
      });
      getTotalIngingos();
    });
  }

  void _showProgressDialog(BuildContext context, PaymentModel? payment,
      double percent, int? unansweredPopQuestions, bool isUrStudent) {
    if (_shouldShowErrorDialog(payment)) {
      _showErrorDialog(
          context, 'Ntibyagenze neza', 'Ifatabuguzi ryawe ntiriremezwa!');
      return;
    }

    if (percent == 1.0 && unansweredPopQuestions == 0) {
      _showIsuzume(context, payment, isUrStudent);
      return;
    }

    _showProgressDialogContent(
        context, payment, percent, unansweredPopQuestions, isUrStudent);
  }

  bool _shouldShowErrorDialog(PaymentModel? payment) {
    return currentUser != null &&
        payment != null &&
        currentUser?.email != 'nidehazard10@gmail.com' &&
        currentUser?.email != 'testing@mail.com' &&
        payment.isApproved != true;
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ItsindireAlert(
          errorTitle: title,
          errorMsg: message,
          alertType: 'error',
        );
      },
    );
  }

  void _showIsuzume(
      BuildContext context, PaymentModel? payment, bool isUrStudent) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return (currentUser?.email != 'nidehazard10@gmail.com' &&
                currentUser?.email != 'testing@mail.com' &&
                payment?.endAt?.isBefore(DateTime.now()) == true)
            ? Ibiciro(
                message: isUrStudent
                    ? 'Buy a package to continue learning!'
                    : 'Banza ugure ifatabuguzi!')
            : IsuzumeContent(
                isomo: widget.isomo,
                courseProgress: widget.courseProgress,
              );
      },
    );
  }

  void _showProgressDialogContent(BuildContext context, PaymentModel? payment,
      double percent, int? unansweredPopQuestions, bool isUrStudent) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ItsindireAlert(
          errorTitle: 'IBIJYANYE NIRI SOMO',
          errorMsg: loadingRealTotalIngingos
              ? 'Tegereza gato ...'
              : 'Iri somo ryitwa "${widget.isomo.title}" rigizwe n’ingingo "$thisCourseTotalIngingos" ni iminota "${(widget.isomo.duration != null && widget.isomo.duration! > 0) ? widget.isomo.duration : widget.courseProgress!.totalIngingos * 4}" gusa!',
          firstButtonTitle: 'Inyuma',
          firstButtonFunction: () {
            Navigator.pop(context);
          },
          firstButtonColor: const Color(0xFFE60000),
          secondButtonTitle: percent == 0.0 ? 'Tangira' : 'Komeza',
          secondButtonFunction: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => currentUser == null
                    ? const Iyandikishe()
                    : currentUser?.email != 'nidehazard10@gmail.com' &&
                            currentUser?.email != 'testing@mail.com' &&
                            (payment == null ||
                                payment.endAt?.isBefore(DateTime.now()) == true)
                        ? Ibiciro(
                            message: isUrStudent
                                ? 'Buy a package to continue learning!'
                                : 'Banza ugure ifatabuguzi!')
                        : IgaContent(
                            isomo: widget.isomo,
                            thisCourseTotalIngingos: thisCourseTotalIngingos,
                          ),
              ),
            );
          },
          secondButtonColor: const Color(0xFF00A651),
          alertType: 'success',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int? curCourseIngingo = widget.courseProgress?.currentIngingo ?? 0;
    final int? unansweredPopQuestions =
        widget.courseProgress?.unansweredPopQuestions ?? 0;

    final double percent = (widget.courseProgress?.totalIngingos != 0 &&
            widget.courseProgress!.totalIngingos >= curCourseIngingo!)
        ? (curCourseIngingo / widget.courseProgress!.totalIngingos)
        : 1.0;

    return MultiProvider(
      providers: [
        StreamProvider<ProfileModel?>.value(
          value: currentUser != null
              ? ProfileService().getCurrentProfileByID(currentUser!.uid)
              : null,
          initialData: null,
          catchError: (context, error) => null,
        ),
        StreamProvider<PaymentModel?>.value(
          value: currentUser != null
              ? PaymentService().getNewestPytByUserId(currentUser!.uid)
              : null,
          initialData: null,
          catchError: (context, error) => null,
        ),
      ],
      child: Consumer<ProfileModel?>(builder: (context, profile, _) {
        final bool isUrStudent = profile?.urStudent == true;
        return Consumer<PaymentModel?>(builder: (context, payment, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LinearPercentIndicator(
                width: MediaQuery.of(context).size.width * 0.4,
                animation: true,
                lineHeight: MediaQuery.of(context).size.height * 0.032,
                animationDuration: 2500,
                percent: unansweredPopQuestions != 0 && percent > 0.1
                    ? percent - 0.1
                    : percent,
                center: Text(
                  '${(unansweredPopQuestions != 0 && percent > 0.1) ? ((percent - 0.1) * 100).toStringAsFixed(0) : (percent * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    color: Colors.white,
                  ),
                ),
                barRadius:
                    Radius.circular(MediaQuery.of(context).size.width * 0.3),
                backgroundColor: const Color.fromARGB(255, 76, 87, 99),
                progressColor: percent > 0.5
                    ? const Color(0xFF00A651)
                    : const Color(0xFFFF3131),
              ),
              GestureDetector(
                onTap: () {
                  _showProgressDialog(context, payment, percent,
                      unansweredPopQuestions, isUrStudent);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.033,
                  decoration: BoxDecoration(
                    color: const Color(0XFF00CCE5),
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.3),
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: MediaQuery.of(context).size.width * 0.004,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      percent == 0.0
                          ? "TANGIRA"
                          : percent == 1.0 && unansweredPopQuestions == 0
                              ? "ISUZUME"
                              : "KOMEZA",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      }),
    );
  }
}
