import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/utilities/user_progress.dart';

class ViewLoggedIn extends StatelessWidget {
  // INSTANCE VARIABLES
  final String userId;
  final List<CourseProgressModel?>? progressesToShow;

  // CONSTRUCTOR
  const ViewLoggedIn({super.key, required this.userId, this.progressesToShow});

  @override
  Widget build(BuildContext context) {
    // PROVIDER VARIABLES
    final progresses = Provider.of<List<CourseProgressModel?>?>(context);
    final amasomo = Provider.of<List<IsomoModel?>?>(context);

    // LIST OF PROGRESSES THAT ARE NOT FINISHED BY THE USER AND ALSO THE ONES THAT ARE NOT STARTED
    List<CourseProgressModel?>? notFinishedProgresses;
    List<CourseProgressModel?>? finishedProgresses;

    // GET THE PROGRESSES THAT ARE NOT FINISHED BY THE USER AND ADD THEM TO THE LIST
    if (progresses != null) {
      notFinishedProgresses = progresses
          .where(
              (progress) => progress?.currentIngingo != progress?.totalIngingos)
          .toList();
    }

    // GET THE AMASOMOS THAT ARE NOT STARTED, MAKE EMPTY PROGRESSES FOR THEM, ADD THEM TO THE PROGRESSES LIST
    if (amasomo != null) {
      for (var isomo in amasomo) {
        if (progresses != null) {
          if (!progresses.any((progress) => progress?.courseId == isomo!.id)) {
            notFinishedProgresses?.add(CourseProgressModel(
              courseId: isomo!.id,
              currentIngingo: 0,
              totalIngingos: 1,
              id: '',
              userId: userId,
            ));
          }
        }
      }
    }

    // GET THE PROGRESSES THAT ARE FINISHED BY THE USER AND ADD THEM TO THE LIST
    if (progresses != null) {
      finishedProgresses = progresses
          .where(
              (progress) => progress?.currentIngingo == progress?.totalIngingos)
          .toList();
    }

    print('NOT FINISHED PROGRESSES: $notFinishedProgresses');
    print('FINISHED PROGRESSES: $finishedProgresses');

    // RETURN THE WIDGETS
    return Column(
      children: progressesToShow?.map((progress) {
            // GET THE ISOMO WITH PROGRESS NOT FINISHED
            final isomo =
                amasomo?.firstWhere((isomo) => isomo!.id == progress!.courseId,
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
                            isomo!.title,
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
                            isomo.description,
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
                          isomo: isomo,
                          userId: userId,
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
