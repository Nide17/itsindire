import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/isuzuma_score_db.dart';
import 'package:itsindire/models/isuzuma.dart';
import 'package:itsindire/models/isuzuma_score.dart';
import 'package:provider/provider.dart';

class Amanota extends StatefulWidget {
  final IsuzumaModel isuzuma;
  const Amanota({super.key, required this.isuzuma});

  @override
  State<Amanota> createState() => _AmanotaState();
}

class _AmanotaState extends State<Amanota> {
  @override
  Widget build(BuildContext context) {
    final usr = FirebaseAuth.instance.currentUser;
    return MultiProvider(
      providers: [
        StreamProvider<IsuzumaScoreModel?>.value(
          value: usr == null
              ? null
              : IsuzumaScoreService()
                  .getScoreByID('${usr.uid}_${widget.isuzuma.id}'),
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
      ],
      child: Consumer<IsuzumaScoreModel?>(builder: (context, userScore, _) {
        return usr == null
            ? _buildNoUserWidget(context)
            : _buildUserScoreWidget(context, userScore);
      }),
    );
  }

  Widget _buildNoUserWidget(BuildContext context) {
    return Text(
      '/${widget.isuzuma.questions.length}',
      style: TextStyle(
        color: Colors.red,
        fontSize: MediaQuery.of(context).size.width * 0.08,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildUserScoreWidget(BuildContext context, IsuzumaScoreModel? userScore) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 232, 232),
        borderRadius: BorderRadius.all(Radius.circular(
            MediaQuery.of(context).size.width * 0.02)),
        border: const Border.fromBorderSide(BorderSide(
            color: Color(0xFFFFBD59),
            width: 2,
            style: BorderStyle.solid)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(34, 34, 34, 0.247),
            offset: Offset(0, 7),
            blurRadius: 4,
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.height * 0.012,
        ),
        child: userScore == null
            ? _buildNoScoreWidget(context)
            : _buildScoreWidget(context, userScore),
      ),
    );
  }

  Widget _buildNoScoreWidget(BuildContext context) {
    return Text(
      'Nturarikora',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.red,
        fontSize: MediaQuery.of(context).size.width * 0.032,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildScoreWidget(BuildContext context, IsuzumaScoreModel userScore) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${userScore.marks}/${userScore.totalMarks}",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: (userScore.marks) / (userScore.totalMarks) >= 0.6
                  ? Colors.green
                  : Colors.red,
            )),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Text(
            (userScore.marks) / (userScore.totalMarks) >= 0.6
                ? "Watsinze!"
                : "Watsinzwe!",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: MediaQuery.of(context).size.width * 0.03,
              color: Colors.black87,
            )),
      ],
    );
  }
}
