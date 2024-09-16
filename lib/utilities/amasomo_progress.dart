import 'package:flutter/material.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/utilities/user_progress.dart';

class AmasomoProgress extends StatefulWidget {
  // INSTANCE VARIABLES
  final String userId;
  final List<CourseProgressModel?>? progressesToShow;
  final List<IsomoModel?>? amasomo;
  final List<CourseProgressModel?>? progresses;

  // CONSTRUCTOR
  const AmasomoProgress(
      {super.key,
      required this.userId,
      this.progressesToShow,
      this.amasomo,
      this.progresses});

  @override
  State<AmasomoProgress> createState() => _AmasomoProgressState();
}

class _AmasomoProgressState extends State<AmasomoProgress> {
  @override
  Widget build(BuildContext context) {

    // LIST OF PROGRESSES THAT ARE NOT FINISHED BY THE USER AND ALSO THE ONES THAT ARE NOT STARTED
    List<CourseProgressModel?>? notFinishedProgresses;

    // GET THE PROGRESSES THAT ARE NOT FINISHED BY THE USER AND ADD THEM TO THE LIST
    if (widget.progresses != null) {
      notFinishedProgresses = widget.progresses
          ?.where(
              (progress) => progress?.currentIngingo != progress?.totalIngingos)
          .toList();
    }

    // GET THE AMASOMOS THAT ARE NOT STARTED, MAKE EMPTY PROGRESSES FOR THEM, ADD THEM TO THE PROGRESSES LIST
    if (widget.amasomo != null) {
      for (var isomo in widget.amasomo!) {
        if (widget.progresses != null) {
          if (!widget.progresses!.any((progress) => progress?.courseId == isomo!.id)) {
            notFinishedProgresses?.add(CourseProgressModel(
              courseId: isomo!.id,
              currentIngingo: 0,
              totalIngingos: 1,
              id: '',
              userId: widget.userId,
            ));
          }
        }
      }
    }

    // SORT BY THE PROGRESS PERCENTAGE IN DESCENDING ORDER (THE ONES WITH THE HIGHEST PERCENTAGE FIRST)
    if (widget.progressesToShow != null) {
      widget.progressesToShow?.sort((a, b) => b!.progressPercentage
          .compareTo(a!.progressPercentage)); // SORT IN DESCENDING ORDER
    }

    // SORT BY ISOMOID IN ASCENDING ORDER (THE ONES WITH THE LOWEST ISOMOID FIRST)
    if (widget.progressesToShow != null) {
      widget.progressesToShow?.sort((a, b) => a!.courseId.compareTo(b!.courseId));
    }

    // NEXT, SORT BY THE NUMBER OF INGINGOS IN DESCENDING ORDER (THE ONES WITH THE HIGHEST NUMBER OF INGINGOS FIRST)
    if (widget.progressesToShow != null) {
      widget.progressesToShow?.sort((a, b) => b!.totalIngingos
          .compareTo(a!.totalIngingos)); // SORT IN DESCENDING ORDER
    }

    // RETURN THE WIDGETS
    return Column(
      children: widget.progressesToShow?.map((progress) {
            // GET THE ISOMO WITH PROGRESS NOT FINISHED
            final isomo =
                widget.amasomo?.firstWhere((isomo) => isomo!.id == progress!.courseId,
                    orElse: () => IsomoModel(
                          title: '',
                          description: '',
                          conclusion: '',
                          id: 0,
                          introText: '',
                        ));

            // RETURN THE WIDGETS
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C64C6),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * 0.04,
                      horizontal: MediaQuery.of(context).size.width * 0.01,
                    ),
                    child: Column(
                      children: [
                        // TITLE
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.02, vertical: 4.0),
                          child: Text(
                            // IF TITLE NOT NULL
                            isomo?.title ?? '',

                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        // BOTTOM BORDER OF THE ABOVE SECTION
                        Container(
                          color: const Color(0xFFFFBD59),
                          height: MediaQuery.of(context).size.height * 0.009,
                        ),

                        // VERTICAL SPACE
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),

                        // DESCRIPTION
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

                        // VERTICAL SPACE
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
                          userId: widget.userId,
                          totalIngingos: progress!.totalIngingos,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
              ],
            );
          }).toList() ??
          [],
    );
  }
}
