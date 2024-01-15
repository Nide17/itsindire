// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/ingingo_db.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/models/payment.dart';
import 'package:tegura/models/profile.dart';
import 'package:tegura/screens/ibiciro/ibiciro.dart';
import 'package:tegura/screens/iga/utils/tegura_alert.dart';
import 'package:tegura/screens/iga/utils/iga_content.dart';
import 'package:tegura/screens/iga/utils/isuzume_content.dart';

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
    final profile = Provider.of<ProfileModel?>(context);
    final payment = Provider.of<PaymentModel?>(context);
    final int? curCourseIngingo = widget.courseProgress != null
        ? widget.courseProgress?.currentIngingo
        : 0;
    final double percent = (widget.courseProgress?.totalIngingos != 0 &&
            widget.courseProgress!.totalIngingos >= curCourseIngingo!)
        ? (curCourseIngingo / widget.courseProgress!.totalIngingos)
        : 1.0;
    final bool isUrStudent = profile != null &&
        profile.urStudent != null &&
        profile.urStudent == true;

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
          barRadius: Radius.circular(MediaQuery.of(context).size.width * 0.3),
          backgroundColor: const Color.fromARGB(255, 76, 87, 99),
          progressColor:
              percent > 0.5 ? const Color(0xFF00A651) : const Color(0xFFFF3131),
        ),
        GestureDetector(
          onTap: () {
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
                              errorMsg: loadingRealTotalIngingos
                                  ? 'Tegereza gato ...'
                                  : 'Ugiye kwiga isomo ryitwa "${widget.isomo.title}" rigizwe n’ingingo "$thisCourseTotalIngingos" ni iminota "${(widget.isomo.duration != null && widget.isomo.duration! > 0) ? widget.isomo.duration : widget.courseProgress!.totalIngingos * 3}" gusa!',
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
  }
}
