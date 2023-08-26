import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/models/isuzuma.dart';
import 'package:tegura/models/isuzuma_score.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/iga/amasuzuma/amanota.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_overview.dart';

class AmasuzumaCard extends StatelessWidget {
  final IsuzumaModel isuzuma;
  final List<IsuzumaScoreModel>? amaUserScores;

  const AmasuzumaCard({
    Key? key,
    required this.isuzuma,
    required this.amaUserScores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usr = Provider.of<UserModel?>(context);

    // FIND A SCORE WHERE THE TAKER ID IS THE CURRENT USER ID AND THE ISUZUMA ID IS THE CURRENT ISUZUMA ID
    final scoreUserIsuzuma = amaUserScores!.isNotEmpty
        ? amaUserScores!.firstWhere((element) =>
            element.takerID == usr!.uid && element.isuzumaID == isuzuma.id)
        : null;

    return Column(
      children: [
        // CARDS ROW FOR IGAZETI, AND IBYAPA - FLEX 50%
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IsuzumaOverview(
                          isuzuma: isuzuma,
                          scoreUserIsuzuma: scoreUserIsuzuma)),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  color: const Color(0xFF00CCE5),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // TITLE
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        isuzuma.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),

                    // BOTTOM BORDER OF THE ABOVE SECTION
                    Container(
                      color: const Color(0xFFFFBD59),
                      height: MediaQuery.of(context).size.height * 0.009,
                    ),

                    // PNG ICON
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 6.0,
                      ),
                      child: Image.asset(
                        'assets/images/isuzuma.png',
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            scoreUserIsuzuma != null
                ? Amanota(
                    score: scoreUserIsuzuma.marks,
                    maxScore: scoreUserIsuzuma.totalMarks,
                  )
                : const Text(
                    'Nturarikora!',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),

        // 3. VERTICAL SPACE
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.04,
        ),
      ],
    );
  }
}
