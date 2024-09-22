import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/isomo_db.dart';
import 'package:itsindire/models/course_progress.dart';
import 'package:itsindire/models/isomo.dart';
import 'package:itsindire/screens/iga/amasuzuma/amasuzuma.dart';
import 'package:itsindire/utilities/cta_button.dart';
import 'package:itsindire/utilities/user_progress.dart';
import 'package:provider/provider.dart';

class AmasomoProgress extends StatefulWidget {
  final List<CourseProgressModel?>? progressesToShow;
  final bool isHagati;

  const AmasomoProgress(
      {Key? key, this.progressesToShow, this.isHagati = false})
      : super(key: key);

  @override
  State<AmasomoProgress> createState() => _AmasomoProgressState();
}

class _AmasomoProgressState extends State<AmasomoProgress> {
  @override
  Widget build(BuildContext context) {

    final sortedProgresses = widget.progressesToShow
      ?..sort((a, b) {
        return a!.courseId.compareTo(b!.courseId);
      });
      
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return MultiProvider(
      providers: [
        StreamProvider<List<IsomoModel?>?>.value(
          value: IsomoService()
              .getAllAmasomo(FirebaseAuth.instance.currentUser?.uid),
          initialData: null,
          catchError: (context, error) => [],
        ),
      ],
      child: Consumer<List<IsomoModel?>?>(builder: (context, allAmasomos, _) {
        if ((sortedProgresses?.isEmpty ?? true) && widget.isHagati) {
          return _buildMessageColumn(
            context,
            'Wasoje amasomo yose!',
            'Kanda hano ukore amasuzuma',
            () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const Amasuzumabumenyi();
              }));
            },
            Colors.green,
          );
        }

        if ((allAmasomos?.isEmpty ?? true) ||
            (sortedProgresses?.isEmpty ?? true)) {
          return _buildMessageColumn(
            context,
            'Nta masomo urasoza!',
            'Inyuma',
            () {
              Navigator.pop(context);
            },
            Colors.red,
          );
        }

        return Column(
          children: sortedProgresses?.map((progress) {
                final isomo = allAmasomos?.firstWhere(
                  (ism) => ism?.id == progress?.courseId,
                  orElse: () => IsomoModel(
                    conclusion: '',
                    id: 0,
                    description: '',
                    introText: '',
                    title: '',
                  ),
                );

                return _buildProgressCard(
                    context, isomo, progress, screenWidth, screenHeight);
              }).toList() ??
              [],
        );
      }),
    );
  }

  Widget _buildMessageColumn(BuildContext context, String messageText,
      String buttonText, VoidCallback onPressed, Color? clr) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final color = clr ?? Colors.green;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.1),
          child: Text(
            messageText,
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02, horizontal: screenWidth * 0.1),
          child: CtaButton(text: buttonText, onPressed: onPressed),
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context, IsomoModel? isomo,
      CourseProgressModel? progress, double screenWidth, double screenHeight) {
    return Column(
      children: [
        Container(
          width: screenWidth * 0.8,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 10, 78, 197),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              width: screenWidth * 0.005,
              color: const Color(0xFFFFBD59),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.04,
              horizontal: screenWidth * 0.01,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.005,
                  ),
                  child: Text(
                    isomo?.title ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: screenWidth * 0.04,
                      color: Colors.black,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
                Container(
                  color: const Color(0xFFFFBD59),
                  height: screenHeight * 0.009,
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    isomo?.description ?? '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: screenWidth * 0.034,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                UserProgress(
                  isomo: isomo ??
                      IsomoModel(
                        conclusion: '',
                        id: 0,
                        description: '',
                        introText: '',
                        title: '',
                      ),
                  courseProgress: progress,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.032,
        ),
      ],
    );
  }
}