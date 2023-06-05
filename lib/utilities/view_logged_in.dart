import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/course_progress.dart';
import 'package:tegura/models/isomo.dart';
import 'package:tegura/utilities/user_progress.dart';
import 'package:tegura/services/course_progress.dart';
import 'package:tegura/services/ingingodb.dart';

class ViewLoggedIn extends StatelessWidget {
  // INSTANCE VARIABLES
  final double progress;
  final String userId;
  final IsomoModel isomo;

  // CONSTRUCTOR
  const ViewLoggedIn(
      {super.key,
      required this.progress,
      required this.isomo,
      required this.userId});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        // DB REFERENCE TO COURSE PROGRESS COLLECTION
        StreamProvider<CourseProgressModel?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: CourseProgressService().getProgress(userId, isomo.id),
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error in logged in: $error");
              print(
                  "The err: ${CourseProgressService().getProgress(userId, isomo.id)}");
            }
            // RETURN NULL
            return null;
          },
        ),

        // STREAM PROVIDER FOR TOTAL INGINGOS FOR A PARTICULAR COURSE OR ISOMO
        StreamProvider<int?>.value(
          // WHAT TO GIVE TO THE CHILDREN WIDGETS
          value: IngingoService().getTotalIsomoIngingos(isomo.id),
          initialData: null,

          // CATCH ERRORS
          catchError: (context, error) {
            // PRINT THE ERROR
            if (kDebugMode) {
              print("Error in logged in for ingingos: $error");
              print("The err: ${IngingoService().getTotalIsomoIngingos(isomo.id)}");
            }
            // RETURN NULL
            return null;
          },
        ),
      ],
      child: Column(
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
                      isomo.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
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
                        fontSize: MediaQuery.of(context).size.width * 0.034,
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
                      ),
                ],
              ),
            ),
          ),
          // VERTICAL SPACE
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
        ],
      ),
    );
  }
}
