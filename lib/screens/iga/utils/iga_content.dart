import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/ingingo.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/models/pop_question.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/iga/utils/circle_progress.dart';
import 'package:tegura/screens/iga/utils/content_details.dart';
import 'package:tegura/services/isomo_progress.dart';
import 'package:tegura/services/pop_question_db.dart';
import 'package:tegura/utilities/appbar.dart';
import 'package:tegura/utilities/direction_button.dart';
import 'package:tegura/services/ingingodb.dart';

class IgaContent extends StatefulWidget {
// INSTANCE VARIABLES
  final IsomoModel isomo;
  final dynamic courseProgress;

  const IgaContent(
      {super.key, required this.isomo, required this.courseProgress});

  @override
  State<IgaContent> createState() => _IgaContentState();
}

class _IgaContentState extends State<IgaContent> {
  // _skip is curCourseIngingo
  int _skip =
      0; // MOVED TO INSTANCE VARIABLES TO MAKE CHANGES BE RETAINED ON REBUILDS

  // VALUE TO ADD TO THE LIST OF INGINGOS - ON NEXT OR PREV BUTTON CLICK
  int _addToGetNextQuestions = 0;

  // SET THE SKIP TO THE CURRENT INGINGO IF IT IS NOT NULL
  @override
  void initState() {
    super.initState();
    _skip = widget.courseProgress != null &&
            widget.courseProgress.currentIngingo !=
                widget.courseProgress.totalIngingos
        ? widget.courseProgress.currentIngingo
        : 0;
  }

  // CALLBACK TO CHANGE THE SKIP STATE
  void changeSkip(int val) {
    setState(() {
      _skip = _skip + val;
      if (_skip < 0) {
        _skip = 0;
        // GO BACK TO THE PREVIOUS PAGE IF NO MORE PREV CONTENT
        Navigator.pop(context);
      }

      // SET THE ADD VALUE DEPENDING ON THE DIRECTION
      if (val > 0) {
        _addToGetNextQuestions = 5;
      } else {
        _addToGetNextQuestions = -5;
      }
    });
  }

  // LIST OF INGINGOS STATE
  List<IngingoModel?>? ingingosState = [];

  // BUILD METHOD TO BUILD THE UI OF THE APP
  @override
  Widget build(BuildContext context) {
    // GET THE USER
    final usr = Provider.of<UserModel?>(context);

    // RETURN THE WIDGETS
    const int limit = 5;

    return MultiProvider(
      providers: [
        // STREAM PROVIDER FOR THE INGINGOS
        StreamProvider<List<IngingoModel>?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: _skip >= 0
              ? IngingoService()
                  .getIngingosByIsomoIdPaginated(widget.isomo.id, limit, _skip)
              : const Stream<List<IngingoModel>?>.empty(),
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error in for ingingos: $error");
              print(
                  "The err: ${IngingoService().getIngingosByIsomoIdPaginated(widget.isomo.id, limit, _skip)}");
            }
            // RETURN NULL
            return null;
          },
        ),

        // DB REFERENCE TO COURSE PROGRESS COLLECTION
        StreamProvider<CourseProgressModel?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: CourseProgressService().getProgress(usr?.uid, widget.isomo.id),
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error iga content cp: $error");
              print(
                  "The err: ${CourseProgressService().getProgress(usr?.uid, widget.isomo.id)}");
            }
            // RETURN NULL
            return null;
          },
        ),

        // STREAM PROVIDER FOR TOTAL INGINGOS FOR A PARTICULAR COURSE OR ISOMO
        StreamProvider<IngingoSum?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: IngingoService().getTotalIsomoIngingos(widget.isomo.id),
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error iga content ti: $error");
              print(
                  "The err: ${IngingoService().getTotalIsomoIngingos(widget.isomo.id)}");
            }
            // RETURN NULL
            return null;
          },
        ),

        // STREAM PROVIDER FOR POP QUESTIONS
        StreamProvider<List<PopQuestionModel>?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: PopQuestionService().getPopQuestionsByIngingoIDs(
              widget.isomo.id,
              List<int>.from(ingingosState!
                  .map((ing) => ing!.id + _addToGetNextQuestions))),
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error iga content pq: $error");
              print(
                  "The err: ${PopQuestionService().getPopQuestionsByIngingoIDs(widget.isomo.id, List<int>.from(ingingosState!.map((e) => e!.id + _addToGetNextQuestions)))}");
            }
            // RETURN NULL
            return null;
          },
        ),
      ],

      // COURSE PROGRESS CONSUMER
      child: Consumer<CourseProgressModel?>(
        builder: (context, progress, _) {
          // LIST OF INGINGOS CONSUMER
          return Consumer<List<IngingoModel>?>(
            builder: (context, ingingos, _) {
              // SET THE INGINGOS STATE
              ingingosState = ingingos;

              // LIST OF POP QUESTIONS CONSUMER
              return Consumer<List<PopQuestionModel>?>(
                builder: (context, popQuestions, _) {
                  // PRINT ID FOR EACH OF POP QUESTIONS
                  if (kDebugMode) {
                    if (popQuestions != null) {
                      popQuestions.forEach((pq) {
                        print("Pop question id: ${pq.id}");
                      });
                    }
                  }
                  // RETURN THE WIDGETS
                  return Scaffold(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),

                    // APP BAR
                    appBar: PreferredSize(
                      preferredSize: MediaQuery.of(context).size * 0.07,
                      child: const AppBarTegura(),
                    ),

                    // PAGE BODY
                    body: ContentDetails(isomo: widget.isomo, userID: usr?.uid),
                    bottomNavigationBar: progress != null && ingingos != null
                        ? Container(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 72, 255, 0),
                                  offset: Offset(0, -1),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // 2. INYUMA BUTTON
                                DirectionButton(
                                    buttonText: 'inyuma',
                                    direction: 'inyuma',
                                    opacity: 1,
                                    skip: _skip,
                                    // SET STATE TO CHANGE THE SKIP BY SUBTRACTING 2 ON EACH BACKWARD BUTTON PRESS
                                    changeSkip: changeSkip,
                                    isomo: widget.isomo),

                                // 1. PERCENTAGE INDICATOR
                                const CircleProgress(),

                                // 3. KOMEZA BUTTON
                                DirectionButton(
                                    buttonText: 'komeza',
                                    direction: 'komeza',
                                    opacity: 1,
                                    skip: _skip,
                                    // SET STATE TO CHANGE THE SKIP BY ADDING 2 ON EACH FORWARD BUTTON PRESS
                                    changeSkip: changeSkip,
                                    isomo: widget.isomo),
                              ],
                            ),
                          )
                        : null,
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
