import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/payment_db.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/models/payment.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/ibiciro/ibiciro.dart';
import 'package:tegura/screens/iga/utils/tegura_alert.dart';
import 'package:tegura/screens/iga/utils/iga_content.dart';
import 'package:tegura/screens/iga/utils/isuzume_content.dart';
import 'package:tegura/firebase_services/isomo_progress.dart';

class UserProgress extends StatelessWidget {
  final IsomoModel isomo;
  final String userId;
  final int totalIngingos;

  const UserProgress({
    super.key,
    required this.isomo,
    required this.userId,
    required this.totalIngingos,
  });

  @override
  Widget build(BuildContext context) {
    final progresses = Provider.of<List<CourseProgressModel?>?>(context);
    final usr = Provider.of<UserModel?>(context);

    final courseProgress =
        progresses?.firstWhere((progress) => progress!.courseId == isomo.id,
            orElse: () => CourseProgressModel(
                  courseId: isomo.id,
                  currentIngingo: 0,
                  totalIngingos: 1,
                  id: '',
                  userId: '',
                ));

    final int curCourseIngingo =
        courseProgress != null ? courseProgress.currentIngingo : 1;

    final double percent = (courseProgress != null &&
            courseProgress.totalIngingos != 0 &&
            courseProgress.totalIngingos >= curCourseIngingo)
        ? (curCourseIngingo / courseProgress.totalIngingos)
        : 1.0;

    return MultiProvider(
      providers: [
        StreamProvider<PaymentModel?>.value(
          value: usr != null
              ? PaymentService().getNewestPytByUserId(usr.uid)
              : null,
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
      ],
      child: Consumer<PaymentModel?>(builder: (context, payment, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width * 0.4,
              animation: true,
              lineHeight: MediaQuery.of(context).size.height * 0.032,
              animationDuration: 2500,
              percent: percent,
              center: Text(
                '${(percent * 100).toStringAsFixed(0)}%',
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
                if (courseProgress?.totalIngingos != totalIngingos) {
                  CourseProgressService().updateUserCourseProgress(
                    userId,
                    isomo.id,
                    curCourseIngingo,
                    totalIngingos,
                  );
                }

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return payment != null && payment.isApproved != true
                          ? const TeguraAlert(
                              errorTitle: 'Ntibyagenze neza',
                              errorMsg: 'Ifatabuguzi ryawe ntiryemeje!',
                              alertType: 'error',
                            )
                          : percent != 1.0
                              ? TeguraAlert(
                                  errorTitle: 'IBIJYANYE NIRI SOMO',
                                  errorMsg:
                                      'Ugiye kwiga isomo ryitwa "${isomo.title}" rigizwe n’ingingo "$totalIngingos" ni iminota "${(isomo.duration != null && isomo.duration! > 0) ? isomo.duration : totalIngingos * 3}" gusa!',
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
                                            builder: (context) => payment ==
                                                        null ||
                                                    !payment.endAt
                                                        .isAfter(DateTime.now())
                                                ? const Ibiciro(
                                                    message:
                                                        'Banza ugure ifatabuguzi!')
                                                : IgaContent(
                                                    isomo: isomo,
                                                    courseProgress:
                                                        courseProgress,
                                                  )));
                                  },
                                  secondButtonColor: const Color(0xFF00A651),
                                  alertType: 'success',
                                )
                              : IsuzumeContent(
                                  isomo: isomo,
                                  courseProgress: courseProgress,
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
                        : percent == 1.0
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
      }),
    );
  }
}
