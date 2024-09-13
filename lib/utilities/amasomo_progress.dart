import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/isomo_db.dart';
import 'package:itsindire/models/course_progress.dart';
import 'package:itsindire/models/isomo.dart';
import 'package:itsindire/utilities/loading_widget.dart';
import 'package:itsindire/utilities/user_progress.dart';
import 'package:provider/provider.dart';

class AmasomoProgress extends StatefulWidget {
  final List<CourseProgressModel?>? progressesToShow;

  const AmasomoProgress({super.key, this.progressesToShow});

  @override
  State<AmasomoProgress> createState() => _AmasomoProgressState();
}

class _AmasomoProgressState extends State<AmasomoProgress> {
  @override
  Widget build(BuildContext context) {
    if (widget.progressesToShow != null) {
      widget.progressesToShow?.sort(
          (a, b) => b!.progressPercentage.compareTo(a!.progressPercentage));
    }

    if (widget.progressesToShow != null) {
      widget.progressesToShow
          ?.sort((a, b) => a!.courseId.compareTo(b!.courseId));
    }

    return MultiProvider(
      providers: [
        StreamProvider<List<IsomoModel?>?>.value(
          value: IsomoService()
              .getAllAmasomo(FirebaseAuth.instance.currentUser?.uid),
          initialData: null,
          catchError: (context, error) {
            return [];
          },
        ),
      ],
      child: Consumer<List<IsomoModel?>?>(builder: (context, allAmasomos, _) {
        // Show loader when either allAmasomos or progressesToShow are loading
        if (allAmasomos == null || widget.progressesToShow == null) {
          return Center(
            child: const LoadingWidget(),
          );
        }

        // Show empty message if there's no data
        if (allAmasomos.isEmpty || widget.progressesToShow!.isEmpty) {
          return Center(
            child: Text(
              'Nta masomo yabonetse!',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w900,
                color: Colors.red,
              ),
            ),
          );
        }

        return Column(
          children: widget.progressesToShow?.map((progress) {
                final IsomoModel? isomo = allAmasomos.firstWhere(
                    (ism) => ism!.id == progress!.courseId,
                    orElse: () => IsomoModel(
                        conclusion: '',
                        id: 0,
                        description: '',
                        introText: '',
                        title: ''));

                return Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 10, 78, 197),
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          width: MediaQuery.of(context).size.width * 0.005,
                          color: const Color(0xFFFFBD59),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.04,
                          horizontal: MediaQuery.of(context).size.width * 0.01,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.02,
                                  vertical: MediaQuery.of(context).size.height *
                                      0.005),
                              child: Text(
                                isomo?.title ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.black,
                                  overflow: TextOverflow.clip,
                                ),
                              ),
                            ),
                            Container(
                              color: const Color(0xFFFFBD59),
                              height:
                                  MediaQuery.of(context).size.height * 0.009,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                isomo?.description ?? '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.034,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            UserProgress(
                              isomo: isomo ??
                                  IsomoModel(
                                      conclusion: '',
                                      id: 0,
                                      description: '',
                                      introText: '',
                                      title: ''),
                              courseProgress: progress,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.032,
                    ),
                  ],
                );
              }).toList() ??
              [],
        );
      }),
    );
  }
}
