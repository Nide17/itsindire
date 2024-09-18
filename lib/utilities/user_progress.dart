import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/payment_db.dart';
import 'package:itsindire/firebase_services/profiledb.dart';
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
    getTotalIngingos();
  }

  @override
  Widget build(BuildContext context) {

    final int? curCourseIngingo = widget.courseProgress != null
        ? widget.courseProgress?.currentIngingo
        : 0;
    final int? unansweredPopQuestions = widget.courseProgress != null
        ? widget.courseProgress?.unansweredPopQuestions
        : 0;
    final double percent = (widget.courseProgress?.totalIngingos != 0 &&
            widget.courseProgress!.totalIngingos >= curCourseIngingo!)
        ? (curCourseIngingo / widget.courseProgress!.totalIngingos)
        : 1.0;

    return MultiProvider(
            providers: [
              StreamProvider<ProfileModel?>.value(
                value: FirebaseAuth.instance.currentUser != null
              ? ProfileService()
                  .getCurrentProfileByID(FirebaseAuth.instance.currentUser!.uid)
              : null,
                initialData: null,
                catchError: (context, error) {
                  return null;
                },
              ),
              StreamProvider<PaymentModel?>.value(
          value: FirebaseAuth.instance.currentUser != null
              ? PaymentService()
                  .getNewestPytByUserId(FirebaseAuth.instance.currentUser!.uid)
              : null,
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
            ],
      child: Consumer<ProfileModel?>(builder: (context, profile, _) {
        final bool isUrStudent = profile != null &&
            profile.urStudent != null &&
            profile.urStudent == true;
          return Consumer<PaymentModel?>(builder: (context, payment, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width * 0.4,
                    animation: true,
                    lineHeight: MediaQuery.of(context).size.height * 0.032,
                    animationDuration: 2500,
                    percent: unansweredPopQuestions != 0 && percent > 0.1 ? percent - 0.1 : percent,
                    center: Text(
                      '${(unansweredPopQuestions != 0 && percent > 0.1) ? ((percent - 0.1) * 100).toStringAsFixed(0) : (percent * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        color: Colors.white,
                      ),
                    ),
                    barRadius: Radius.circular(MediaQuery.of(context).size.width * 0.3),
                    backgroundColor: const Color.fromARGB(255, 76, 87, 99),
                    progressColor:
                        percent > 0.5 ? const Color(0xFF00A651) : const Color(0xFFFF3131),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false, 
                          builder: (BuildContext context) {
                            return payment != null &&
                                    payment.isApproved != true
                                ? const ItsindireAlert(
                                    errorTitle: 'Ntibyagenze neza',
                                    errorMsg: 'Ifatabuguzi ryawe ntiriremezwa!',
                                    alertType: 'error',
                                  )
                                : percent != 1.0 || unansweredPopQuestions != 0
                                    ? ItsindireAlert(
                                        errorTitle: 'IBIJYANYE NIRI SOMO',
                                        errorMsg: loadingRealTotalIngingos
                                            ? 'Tegereza gato ...'
                                            : 'Iri somo ryitwa "${widget.isomo.title}" rigizwe n\’ingingo "$thisCourseTotalIngingos" ni iminota "${(widget.isomo.duration != null && widget.isomo.duration! > 0) ? widget.isomo.duration : widget.courseProgress!.totalIngingos * 3}" gusa!',
                                        firstButtonTitle: 'Inyuma',
                                        firstButtonFunction: () {
                                          Navigator.pop(context);
                                        },
                                        firstButtonColor: const Color(0xFFE60000),
                                        secondButtonTitle:
                                            percent == 0.0 ? 'Tangira' : 'Komeza',
                                        secondButtonFunction: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => payment == null ||
                                                          !payment.endAt
                                                              .isAfter(DateTime.now())
                                                      ? Ibiciro(
                                                          message: isUrStudent
                                                              ? 'Buy a package to continue learning!'
                                                              : 'Banza ugure ifatabuguzi!')
                                                      : IgaContent(
                                                          isomo: widget.isomo,
                                                          courseProgress:
                                                              widget.courseProgress,
                                                          thisCourseTotalIngingos:
                                                              thisCourseTotalIngingos)));
                                        },
                                        secondButtonColor: const Color(0xFF00A651),
                                        alertType: 'success',
                                      )
                                    : (payment == null ||
                                            !payment.endAt.isAfter(DateTime.now()))
                                        ? Ibiciro(
                                            message: isUrStudent
                                                ? 'Buy a package to continue learning!'
                                                : 'Banza ugure ifatabuguzi!')
                                        : IsuzumeContent(
                                            isomo: widget.isomo,
                                            courseProgress: widget.courseProgress,
                                          );
                          });
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
                          (percent == 0.0)
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
            }
          );
        }
      ),
    );
  }
}
