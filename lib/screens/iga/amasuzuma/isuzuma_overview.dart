import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/isomo_db.dart';
import 'package:itsindire/firebase_services/isuzuma_score_db.dart';
import 'package:itsindire/models/isuzuma.dart';
import 'package:itsindire/models/isuzuma_score.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_attempt.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_score_review.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/loading_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class IsuzumaOverview extends StatefulWidget {
  final IsuzumaModel isuzuma;

  const IsuzumaOverview({super.key, required this.isuzuma});

  @override
  State<IsuzumaOverview> createState() => _IsuzumaOverviewState();
}

class _IsuzumaOverviewState extends State<IsuzumaOverview> {
  List<String> amasomo = [];
  bool isTitlesLoading = true;
  bool _isMounted = false;

  Future<void> fetchAmasomoTitles() async {
    List<String> amasomoTitles = await IsomoService()
        .getAmasomoTitlesByIds(widget.isuzuma.getIsomoIDs());

    if (_isMounted) {
      setState(() {
        amasomo = amasomoTitles;
        isTitlesLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    fetchAmasomoTitles();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usr = FirebaseAuth.instance.currentUser;

    return MultiProvider(
      providers: [
        StreamProvider<IsuzumaScoreModel?>.value(
          value: IsuzumaScoreService()
              .getScoreByID('${usr!.uid}_${widget.isuzuma.id}'),
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
      ],
      child:
          Consumer<IsuzumaScoreModel?>(builder: (context, scoreUserIsuzuma, _) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 71, 103, 158),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(58.0),
            child: AppBarItsindire(),
          ),
          body: ListView(children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.height * 0.02,
                left: MediaQuery.of(context).size.height * 0.02,
                bottom: MediaQuery.of(context).size.height * 0.02,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF00CCE5),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  width: MediaQuery.of(context).size.width * 0.008,
                  color: const Color(0xFFFFBD59),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      bottom: MediaQuery.of(context).size.height * 0.006,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 6.0,
                          ),
                          child: Image.asset(
                            'assets/images/isuzuma.png',
                            height: MediaQuery.of(context).size.height * 0.028,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.isuzuma.title.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.045,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    color: const Color(0xFFFFBD59),
                    height: MediaQuery.of(context).size.height * 0.009,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.008,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 6.0,
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Iri suzumabumenyi rigizwe n’ibibazo ',
                          ),
                          TextSpan(
                            text: '${widget.isuzuma.questions.length} ',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 27, 116),
                            ),
                          ),
                          const TextSpan(
                            text: 'bikorwa mu minota ',
                          ),
                          const TextSpan(
                            text: '20, ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 27, 116),
                            ),
                          ),
                          const TextSpan(
                            text: ' kumasomo akurikira:',
                          ),
                        ],
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.036,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // ORDERED LIST OF amasomo - HEIGHT = HEIGHT OF LIST amasomo
                  SizedBox(
                    height: isTitlesLoading
                        ? MediaQuery.of(context).size.height * 0.048 * 5
                        : MediaQuery.of(context).size.height *
                            0.04 *
                            amasomo.length,
                    child: isTitlesLoading
                        ? const LoadingWidget()
                        : ListView.builder(
                            itemCount: amasomo.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                dense: true,
                                visualDensity: const VisualDensity(
                                  horizontal: 0,
                                  vertical: -4,
                                ),
                                leading: Text(
                                  '${index + 1}.',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                title: Text(
                                  '${amasomo[index][0].toUpperCase()}${amasomo[index].substring(1).toLowerCase()}',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.032,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                  )
                ],
              ),
            ),

            // REVIEW THE SCORE
            scoreUserIsuzuma != null
                ? Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  IsuzumaScoreReview(isuzuma: widget.isuzuma),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.center,
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.42,
                          MediaQuery.of(context).size.height * 0.0,
                        ),
                        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                        backgroundColor:
                            const Color.fromARGB(255, 187, 201, 221),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.05),
                        ),
                      ),
                      child: Text(
                        'Reba uko wakoze',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                : Container(),

            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.025,
              ),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.leftToRight,
                          child: IsuzumaAttempt(isuzuma: widget.isuzuma)));
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.5,
                    MediaQuery.of(context).size.height * 0.0,
                  ),
                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                  backgroundColor: const Color(0xFFFFBD59),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.05),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Adjust as needed
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 6.0,
                      ),
                      child: Image.asset(
                        'assets/images/isuzuma.png',
                        height: MediaQuery.of(context).size.height * 0.028,
                      ),
                    ),
                    Flexible( // This allows the Text to take only available space
                      child: Text(
                        scoreUserIsuzuma != null
                            ? 'SUBIRAMO'.toUpperCase()
                            : 'RITANGIRE'.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        );
      }),
    );
  }
}
